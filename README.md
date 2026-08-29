# Mela Bike Infrastructure

Infrastructure-as-code for a small Odoo-based business platform running on Hetzner Cloud.

This repository demonstrates how I designed a reproducible application environment rather than configuring a server manually. Terraform provisions the network and compute resources; cloud-init prepares the host; Docker Compose runs the services; and documented backup procedures support recovery.

## Stack

- **Terraform:** network, firewall, server and bootstrap configuration
- **Hetzner Cloud:** compute and private networking
- **Docker Compose:** application orchestration
- **Odoo:** ERP and business workflows
- **PostgreSQL:** application database
- **Traefik:** HTTPS termination and reverse-proxy routing
- **Traccar:** optional tracking service
- **Restic:** encrypted off-site backups
- **systemd:** service and backup scheduling

## Architecture

1. Terraform creates the VPC, firewall and server.
2. Cloud-init installs Docker and writes the service configuration.
3. systemd starts the Docker Compose stack.
4. Traefik exposes only the intended HTTPS application route.
5. PostgreSQL remains on an internal Docker network.
6. Restic produces encrypted off-site backups for disaster recovery.

## Repository layout

- [mela-bike-live/stage](mela-bike-live/stage): staging infrastructure
- [mela-bike-live/prod](mela-bike-live/prod): production configuration
- [mela-bike-live/recovery](mela-bike-live/recovery): recovery environment
- [Technical overview](mela-bike-live/README.md)
- [Operations reference](mela-bike-live/OPERATIONS.md)
- [Backup and restore](mela-bike-live/BACKUP-RESTORE.md)

## Security decisions

- Database and application secrets are created outside Git and injected at runtime.
- Terraform variable files containing environment-specific values are ignored.
- PostgreSQL is not exposed publicly.
- Traefik accesses Docker through a restricted socket proxy.
- SSH password authentication is disabled.
- Backups are encrypted and stored away from the application server.
- Public documentation uses placeholders instead of live host addresses or access details.

## Using the configuration

Copy the relevant example variables file before running Terraform:

~~~bash
cp terraform.tfvars.example terraform.tfvars
terraform init
terraform plan
~~~

Review every plan before applying it. Some bootstrap changes can require server replacement.

## What this project demonstrates

- Translating operational requirements into reproducible infrastructure
- Separating public configuration from private runtime secrets
- Designing service boundaries and network exposure
- Automating deployment, backups and disaster recovery
- Documenting a system so it can be operated and rebuilt
