# Backup And Restore

This stack uses encrypted off-site backups with `restic` stored in S3-compatible object storage.

## What Gets Backed Up

- PostgreSQL custom-format dump for the Odoo database
- Odoo filestore
- Odoo configuration
- PostgreSQL connection secret
- Traefik ACME state
- Traccar data directory
- A small manifest with timestamp, hostname, and database name

## Stage Backup Configuration

On the stage server:

- Backup environment file: `/opt/mela-bike/secrets/backup.env`
- Restic password file: `/opt/mela-bike/secrets/restic_repository_password.txt`
- Backup script: `/usr/local/bin/mela-bike-backup.sh`
- Backup timer: `mela-bike-backup.timer`

## Verify Backups

Check the last backup job:

```bash
ssh root@91.98.114.63 'systemctl status mela-bike-backup.service --no-pager'
```

List snapshots:

```bash
ssh root@91.98.114.63 'set -a; . /opt/mela-bike/secrets/backup.env; set +a; restic snapshots'
```

Run an immediate manual backup:

```bash
ssh root@91.98.114.63 'systemctl start mela-bike-backup.service'
```

## Restore Drill

Restore the latest snapshot into a temporary directory without touching the live app:

```bash
ssh root@91.98.114.63 '
set -e
restore_root=/var/tmp/mela-bike-restore-test
rm -rf "$restore_root"
mkdir -p "$restore_root"
set -a
. /opt/mela-bike/secrets/backup.env
set +a
restic restore latest --target "$restore_root"
find "$restore_root" -maxdepth 4 -type f | sort | sed -n "1,50p"
dump_path="$(find "$restore_root" -path '*/postgres/*.dump' | head -n1)"
docker run --rm -v "$dump_path":/restore.dump postgres:16 pg_restore -l /restore.dump | sed -n "1,20p"
'
```

## Full Disaster Recovery

These steps assume the original server is gone and you are restoring onto a fresh replacement server.

1. Provision a replacement server with the same stack layout.

2. Install Docker, the compose file, Odoo config, and the backup tooling.

3. Recreate these two files on the replacement server:

- `/opt/mela-bike/secrets/postgres_password.txt`
- `/opt/mela-bike/secrets/restic_repository_password.txt`

4. Recreate `/opt/mela-bike/secrets/backup.env` with the backup repository and object storage credentials.

5. Restore the latest snapshot into a temporary directory:

```bash
set -a
. /opt/mela-bike/secrets/backup.env
set +a
restic restore latest --target /var/tmp/mela-bike-restore
```

6. Start only PostgreSQL first:

```bash
POSTGRES_PASSWORD="$(< /opt/mela-bike/secrets/postgres_password.txt)" docker compose -f /opt/mela-bike/docker-compose.yml up -d db
```

7. Create the Odoo database:

```bash
docker exec odoo-db createdb -U odoo -O odoo db_mela
```

8. Restore the PostgreSQL dump:

```bash
dump_path="$(find /var/tmp/mela-bike-restore -path '*/postgres/*.dump' | head -n1)"
cat "$dump_path" | docker exec -i odoo-db pg_restore -U odoo -d db_mela --clean --if-exists --no-owner
```

9. Create the Odoo container so the named volume exists:

```bash
POSTGRES_PASSWORD="$(< /opt/mela-bike/secrets/postgres_password.txt)" docker compose -f /opt/mela-bike/docker-compose.yml up -d odoo
```

10. Restore the Odoo filestore:

```bash
filestore_src="$(find /var/tmp/mela-bike-restore -type d -name filestore | head -n1)"
odoo_volume_path="$(docker inspect odoo --format '{{range .Mounts}}{{if eq .Destination "/var/lib/odoo"}}{{.Source}}{{end}}{{end}}')"
rm -rf "$odoo_volume_path/filestore"
mkdir -p "$odoo_volume_path/filestore"
cp -a "$filestore_src"/. "$odoo_volume_path/filestore"/
chown -R 100:101 "$odoo_volume_path/filestore"
docker restart odoo
```

11. Restore Traccar data if needed:

```bash
traccar_src="$(find /var/tmp/mela-bike-restore -type d -path '*/traccar-data' | head -n1)"
if [ -n "$traccar_src" ]; then
  rm -rf /opt/mela-bike/traccar/data/*
  cp -a "$traccar_src"/. /opt/mela-bike/traccar/data/
fi
```

12. Restart the full stack:

```bash
systemctl restart mela-bike
```

13. Verify:

- Odoo login works
- attachments are present
- `restic snapshots` still lists the repository
- if Odoo drops all capabilities, restore filestore ownership on the host volume, not inside the container

You can verify the login page without exposing the temporary recovery host publicly:

```bash
docker exec odoo python3 -c "import urllib.request; print(urllib.request.urlopen('http://127.0.0.1:8069/web/login').status)"
```

## Notes

- Backups are encrypted. Without the restic repository password, restores are impossible.
- The current setup stores backups under a separate prefix in the existing object storage bucket.
- A future hardening step is to move backups to a dedicated backup-only bucket with dedicated credentials.
