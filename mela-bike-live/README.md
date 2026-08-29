# Mela Bike Infrastructure: Technical Overview

This directory contains the staging, production and recovery configurations for an Odoo-based platform deployed on Hetzner Cloud.

Environment-specific endpoints, source IPs and credentials are intentionally excluded from the public repository.

## Components

Terraform provisions:

- a private network
- firewall rules
- a virtual machine
- cloud-init bootstrap data

Cloud-init prepares:

- Docker and Docker Compose
- the Odoo and PostgreSQL services
- Traefik HTTPS routing
- a restricted Docker socket proxy
- Traccar on a non-public interface
- systemd units for the application and backups
- encrypted Restic backups to S3-compatible storage

## Runtime flow

Public HTTPS traffic reaches Traefik. Traefik forwards application requests to Odoo through the proxy network. Odoo communicates with PostgreSQL only through an internal network. Traccar is kept off the public interface. A scheduled backup job collects the database, filestore and required configuration into an encrypted off-site snapshot.

## Environments

- [stage](stage): pre-production validation
- [prod](prod): production configuration
- [recovery](recovery): isolated disaster-recovery configuration

Each services directory contains a terraform.tfvars.example file. Copy it locally to terraform.tfvars and provide the correct environment-specific values. Real tfvars files are ignored by Git.

## Deployment outline

~~~bash
cd stage/vpc
terraform init -backend-config=../../backend.hcl
terraform plan
terraform apply

cd ../services
cp terraform.tfvars.example terraform.tfvars
terraform init -backend-config=../../backend.hcl
terraform plan
terraform apply
~~~

Exact backend keys and credentials should be supplied through local configuration or environment variables.

## Operational design

- Odoo is exposed only through Traefik.
- PostgreSQL remains internal.
- Runtime secrets are stored in permission-restricted files on the host.
- SSH uses key-based authentication.
- Backup credentials are separate from application configuration.
- Restic snapshots are encrypted and retained using daily, weekly and monthly policies.
- Terraform changes are reviewed carefully because changes to bootstrap data may replace a server.

See [OPERATIONS.md](OPERATIONS.md) and [BACKUP-RESTORE.md](BACKUP-RESTORE.md) for sanitized operational examples.
