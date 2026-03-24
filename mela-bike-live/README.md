# Mela Bike Project Documentation

Last verified: March 24, 2026

This document is the main reference for the Mela Bike Odoo stack. It is written for two audiences:

- business users, especially your brother, who need to start using `staging.mela.bike`
- operators, who need to understand how the server, backups, and infrastructure work

This stack is currently running and usable.

## Current Live State

Verified on March 24, 2026:

- Environment: `stage`
- Hostname: `mela-bike-stage`
- Public Odoo URL: `https://staging.mela.bike`
- Default database: `db_mela`
- Odoo version: `18.0+e-20260305`
- Edition: `Enterprise Edition`
- Backup timer: active
- Main application service: `mela-bike.service`

Running containers:

- `odoo` using `odoo:18.0`
- `odoo-db` using `postgres:16`
- `traefik` using `traefik:v3.6`
- `traccar` using `traccar/traccar:6.12.2`
- `dockerproxy` using `tecnativa/docker-socket-proxy:latest`

## What This Project Is

This project provisions and runs a small business platform on Hetzner using Terraform, Docker Compose, and Odoo Enterprise.

Main components:

- Odoo Enterprise for ERP/business operations
- PostgreSQL for Odoo data
- Traefik for HTTPS and routing
- Traccar for tracking
- Restic for encrypted off-site backups

## Repository Structure

Infrastructure code lives in:

- [README.md](/tmp/melabike/live/mela-bike-live/README.md)
- [OPERATIONS.md](/tmp/melabike/live/mela-bike-live/OPERATIONS.md)
- [BACKUP-RESTORE.md](/tmp/melabike/live/mela-bike-live/BACKUP-RESTORE.md)
- [stage/vpc](/tmp/melabike/live/mela-bike-live/stage/vpc)
- [stage/services](/tmp/melabike/live/mela-bike-live/stage/services)
- [prod/vpc](/tmp/melabike/live/mela-bike-live/prod/vpc)
- [prod/services](/tmp/melabike/live/mela-bike-live/prod/services)

Important stage service files:

- [stage/services/main.tf](/tmp/melabike/live/mela-bike-live/stage/services/main.tf)
- [stage/services/variables.tf](/tmp/melabike/live/mela-bike-live/stage/services/variables.tf)
- [stage/services/terraform.tfvars](/tmp/melabike/live/mela-bike-live/stage/services/terraform.tfvars)
- [stage/services/cloud-init.yaml.tftpl](/tmp/melabike/live/mela-bike-live/stage/services/cloud-init.yaml.tftpl)

Modules are referenced from the remote modules repo, not from a local path.

## High-Level Architecture

Terraform creates:

- a Hetzner private network
- a firewall
- a VM server
- cloud-init bootstrap data

Cloud-init then prepares the server by creating:

- `/opt/mela-bike/docker-compose.yml`
- `/opt/mela-bike/start-stack.sh`
- `/opt/mela-bike/odoo/config/odoo.conf`
- `/etc/systemd/system/mela-bike.service`
- `/usr/local/bin/mela-bike-backup.sh`

The running stack is:

- Traefik receives public HTTP/HTTPS traffic
- Odoo is reachable only through Traefik
- PostgreSQL is internal only
- Traccar web is localhost-only
- backups go to S3-compatible object storage using `restic`

## Server File Layout

Important directories on the server:

- `/opt/mela-bike`
- `/opt/mela-bike/odoo/config`
- `/opt/mela-bike/odoo/addons-local`
- `/opt/mela-bike/odoo/addons-enterprise`
- `/opt/mela-bike/secrets`
- `/opt/mela-bike/traefik`
- `/opt/mela-bike/traccar/data`

Important files:

- `/opt/mela-bike/docker-compose.yml`
- `/opt/mela-bike/start-stack.sh`
- `/opt/mela-bike/odoo/config/odoo.conf`
- `/opt/mela-bike/secrets/postgres_password.txt`
- `/opt/mela-bike/secrets/odoo_admin_passwd.txt`
- `/opt/mela-bike/secrets/backup.env`
- `/opt/mela-bike/secrets/restic_repository_password.txt`
- `/usr/local/bin/mela-bike-backup.sh`
- `/etc/systemd/system/mela-bike.service`
- `/etc/systemd/system/mela-bike-backup.timer`

## Credentials And What They Mean

These are different credentials and should not be confused:

- Hetzner Terraform token
  - used for infrastructure changes
- Object storage credentials
  - used for Terraform state
  - currently also used for backups
- PostgreSQL password
  - used by Odoo to connect to Postgres
  - stored in `postgres_password.txt`
- Odoo admin user password
  - used to log into Odoo as an administrator
- Odoo database manager password
  - stored in `odoo_admin_passwd.txt`
  - used for database management actions
- Restic repository password
  - decrypts backups

Full recovery needs:

- infrastructure code
- infra credentials
- runtime secrets
- backup credentials
- the restic password
- the backup data itself

## Odoo Access For Your Brother

Normal user login URL:

- `https://staging.mela.bike/web/login`

He should use:

- his Odoo email/login
- his Odoo user password

He should not use:

- the PostgreSQL password
- the Odoo database manager password

Recommended way of working:

- keep one admin account for technical/configuration work
- create named normal users for daily business work
- avoid sharing the main admin login

## Quick Tutorial For Your Brother

### 1. First login

- Open `https://staging.mela.bike/web/login`
- Sign in with the user created for him

### 2. What he can do first

- update company details
- add contacts and customers
- create products or services
- install the business apps he actually needs
- define the first business workflows

### 3. Good first setup order

1. company profile
2. users and roles
3. customers and suppliers
4. products/services
5. sales flow
6. invoicing/accounting setup
7. inventory or field service if used

### 4. Basic rule

Do business setup in Odoo first. Do not change infrastructure or server configuration while someone is actively configuring the business inside Odoo.

## Odoo Enterprise Status

This instance is now confirmed to be Enterprise in practice.

Verified facts:

- Odoo UI shows `Odoo 18.0+e-20260305 (Enterprise Edition)`
- `web_enterprise` is installed in `db_mela`
- the Enterprise addon tree exists on the server
- the database shows an Enterprise expiration date in the Odoo UI

Enterprise source now lives on the server at:

- `/opt/mela-bike/odoo/addons-enterprise`

Backups now include this Enterprise addon tree too.

## Starting, Stopping, And Checking The Stack

Main systemd service:

- `mela-bike.service`

Useful commands:

```bash
ssh root@91.98.114.63 'systemctl status mela-bike --no-pager'
```

```bash
ssh root@91.98.114.63 'systemctl restart mela-bike'
```

```bash
ssh root@91.98.114.63 'docker compose -f /opt/mela-bike/docker-compose.yml ps'
```

```bash
ssh root@91.98.114.63 'docker logs odoo --tail 100'
```

## Backups

Backups are encrypted and stored off-server with `restic`.

What is backed up:

- PostgreSQL dump
- Odoo filestore
- Odoo config
- Enterprise addon tree
- PostgreSQL secret
- Odoo database manager secret
- Traefik ACME state
- Traccar data
- metadata manifest

Main backup document:

- [BACKUP-RESTORE.md](/tmp/melabike/live/mela-bike-live/BACKUP-RESTORE.md)

Useful commands:

```bash
ssh root@91.98.114.63 'systemctl status mela-bike-backup.service --no-pager'
```

```bash
ssh root@91.98.114.63 'systemctl status mela-bike-backup.timer --no-pager'
```

```bash
ssh root@91.98.114.63 'systemctl start mela-bike-backup.service'
```

```bash
ssh root@91.98.114.63 'set -a; . /opt/mela-bike/secrets/backup.env; set +a; restic snapshots'
```

Important:

- without the restic repository password, backups cannot be restored
- do not lose the backup credentials or the restic password

## Disaster Recovery

The rebuild/recovery path has been tested.

That means:

- a fresh server can be created from Terraform
- secrets can be restored
- data can be restored from backups
- Odoo can come back online

Main restore procedure:

- [BACKUP-RESTORE.md](/tmp/melabike/live/mela-bike-live/BACKUP-RESTORE.md)

## Security Summary

Current security posture is good enough for controlled business use in stage.

Current properties:

- only `22`, `80`, and `443` are publicly reachable
- Odoo is behind HTTPS
- PostgreSQL is not public
- Traccar web is localhost-only
- Traefik uses a restricted Docker socket proxy instead of a raw Docker socket mount
- SSH password login is disabled
- backups are encrypted and off-site

Important limitations:

- this is still a `stage` environment, not final production
- backups and some secrets still rely on files on the server
- object storage credentials are currently shared across purposes more than ideal

## Traccar Access

Traccar web is not public.

Use an SSH tunnel if needed:

```bash
ssh -L 8082:127.0.0.1:8082 root@91.98.114.63
```

Then open:

- `http://127.0.0.1:8082`

## Terraform Notes

Important operational rule:

- do not run a full `terraform apply` on [stage/services](/tmp/melabike/live/mela-bike-live/stage/services) casually

Why:

- the server bootstrap is encoded in `user_data`
- for `hcloud_server`, `user_data` changes can force server replacement

That is acceptable for disaster recovery, but disruptive for a working server.

Use Terraform deliberately for:

- firewall changes
- controlled rebuilds
- future prod creation

## Production Notes

Production code exists, but production is not the thing to touch next unless you intentionally want to build it.

Before production, decide:

- final production domain
- final access policy
- whether Traccar needs public access at all
- whether backup credentials should be split into dedicated backup-only credentials

## Operational Rules

Do:

- keep secrets in KeePass
- use named user accounts
- run backups after important milestones
- test the business process in stage
- avoid infrastructure changes during active business configuration

Do not:

- share the PostgreSQL password with users
- use the Odoo database manager password as a normal login
- run broad Odoo updates without a reason
- treat Docker volumes as backups
- assume GitHub alone is enough for full recovery

## Recommended Next Business Step

The infrastructure side is in a usable state.

The right next step is simple:

- let your brother start configuring the business in Odoo
- keep backups running
- make fewer infrastructure changes, not more
