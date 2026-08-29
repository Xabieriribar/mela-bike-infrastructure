# Operations Reference

This public document describes the operating model without exposing live hosts, endpoints or access details.

## Services

- mela-bike.service
- odoo
- odoo-db
- traefik
- traccar
- dockerproxy
- mela-bike-backup.timer

## Main paths

- Stack root: /opt/mela-bike
- Compose file: /opt/mela-bike/docker-compose.yml
- Odoo config: /opt/mela-bike/odoo/config/odoo.conf
- Custom addons: /opt/mela-bike/odoo/addons-local
- Secrets directory: /opt/mela-bike/secrets
- Backup script: /usr/local/bin/mela-bike-backup.sh

## Routine checks

Replace the placeholders with values from the private operations record.

~~~bash
ssh <user>@<server-ip> 'systemctl status mela-bike --no-pager'
ssh <user>@<server-ip> 'docker compose -f /opt/mela-bike/docker-compose.yml ps'
ssh <user>@<server-ip> 'docker logs odoo --tail 100'
ssh <user>@<server-ip> 'systemctl status mela-bike-backup.service --no-pager'
~~~

## Safe restart

~~~bash
ssh <user>@<server-ip> 'systemctl restart mela-bike'
~~~

## Troubleshooting order

1. Check the systemd service.
2. Check Docker Compose state.
3. Inspect Odoo logs.
4. Inspect PostgreSQL logs.
5. Check the most recent backup job.
6. Confirm that required runtime secret files exist and have restrictive permissions.

## Operational cautions

- Review Terraform plans before applying them.
- Do not edit runtime secrets through Git.
- Do not treat Docker volumes as backups.
- Test restoration procedures periodically.
- Keep live endpoints, host addresses and credentials in a private password manager or operations record.

See [BACKUP-RESTORE.md](BACKUP-RESTORE.md) for the recovery model.
