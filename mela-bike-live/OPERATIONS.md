# Mela Bike Operations Quick Reference

Last verified: March 24, 2026

## Current Live Environment

- Environment: `stage`
- URL: `https://staging.mela.bike`
- Hostname: `mela-bike-stage`
- Odoo DB: `db_mela`
- Odoo edition: `Enterprise`

## What Is Running

- `mela-bike.service`
- `odoo` container
- `odoo-db` container
- `traefik` container
- `traccar` container
- `dockerproxy` container
- `mela-bike-backup.timer`

## Important Paths

- Stack root: `/opt/mela-bike`
- Compose file: `/opt/mela-bike/docker-compose.yml`
- Odoo config: `/opt/mela-bike/odoo/config/odoo.conf`
- Custom addons: `/opt/mela-bike/odoo/addons-local`
- Enterprise addons: `/opt/mela-bike/odoo/addons-enterprise`
- Secrets: `/opt/mela-bike/secrets`
- Backup script: `/usr/local/bin/mela-bike-backup.sh`

## Backups

- Tool: `restic`
- Storage: S3-compatible object storage
- Schedule: daily
- Current timer target: around `03:25 UTC`
- Retention:
  - `7` daily
  - `4` weekly
  - `3` monthly

Backups include:

- PostgreSQL dump
- Odoo filestore
- Odoo config
- Enterprise addon tree
- key runtime secrets
- Traefik ACME state
- Traccar data

## Basic Checks

Check the stack:

```bash
ssh root@91.98.114.63 'systemctl status mela-bike --no-pager'
```

Check containers:

```bash
ssh root@91.98.114.63 'docker compose -f /opt/mela-bike/docker-compose.yml ps'
```

Check Odoo logs:

```bash
ssh root@91.98.114.63 'docker logs odoo --tail 100'
```

Check backup status:

```bash
ssh root@91.98.114.63 'systemctl status mela-bike-backup.service --no-pager'
```

List snapshots:

```bash
ssh root@91.98.114.63 'set -a; . /opt/mela-bike/secrets/backup.env; set +a; restic snapshots'
```

## Safe Restart

```bash
ssh root@91.98.114.63 'systemctl restart mela-bike'
```

## If Something Breaks

Check in this order:

1. `systemctl status mela-bike`
2. `docker compose ps`
3. `docker logs odoo`
4. `docker logs odoo-db`
5. `systemctl status mela-bike-backup.service`

If the server itself is lost:

- rebuild from Terraform
- restore secrets
- restore the latest restic snapshot
- use [BACKUP-RESTORE.md](/tmp/melabike/live/mela-bike-live/BACKUP-RESTORE.md)

## Do Not Touch Casually

- `stage/services` Terraform with a full apply
- files in `/opt/mela-bike/secrets`
- `/opt/mela-bike/odoo/addons-enterprise`
- backup credentials
- the restic password

## Related Documents

- [README.md](/tmp/melabike/live/mela-bike-live/README.md)
- [BACKUP-RESTORE.md](/tmp/melabike/live/mela-bike-live/BACKUP-RESTORE.md)

