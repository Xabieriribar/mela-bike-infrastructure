# Backup and Restore

The stack uses Restic to create encrypted off-site backups in S3-compatible object storage.

## Backup contents

- PostgreSQL custom-format dump
- Odoo filestore
- Odoo configuration
- Required runtime secret files
- Traefik ACME state
- Traccar data
- A manifest containing recovery metadata

## Verification

Use the private operations record to substitute the connection placeholders.

~~~bash
ssh <user>@<server-ip> 'systemctl status mela-bike-backup.service --no-pager'
ssh <user>@<server-ip> 'systemctl start mela-bike-backup.service'
ssh <user>@<server-ip> 'set -a; . /opt/mela-bike/secrets/backup.env; set +a; restic snapshots'
~~~

## Restore drill

A restore drill should extract the latest snapshot into an isolated temporary directory and validate the PostgreSQL dump without modifying the running application.

~~~bash
set -a
. /opt/mela-bike/secrets/backup.env
set +a

restore_root=/var/tmp/mela-bike-restore-test
mkdir -p "$restore_root"
restic restore latest --target "$restore_root"

dump_path="$(find "$restore_root" -path '*/postgres/*.dump' | head -n1)"
docker run --rm -v "$dump_path":/restore.dump postgres:16 \
  pg_restore -l /restore.dump
~~~

## Disaster-recovery outline

1. Provision a replacement host from the Terraform configuration.
2. Recreate runtime secrets from the private password manager.
3. Configure access to the encrypted Restic repository.
4. Restore the latest snapshot to an isolated directory.
5. Start PostgreSQL and recreate the target database.
6. Restore the database dump.
7. Restore the Odoo filestore and required application configuration.
8. Start the full stack.
9. Verify login, attachments, HTTPS routing and backup access.
10. Run a new backup after successful recovery.

## Important properties

- Backups are unusable without the Restic repository password.
- Backup credentials must not be committed to Git.
- Restore drills should be performed before an emergency.
- A separate backup-only bucket and credentials are preferable to reusing infrastructure-state credentials.
