Mela Bike Infrastructure

Project Overview

This repository contains the Terraform configuration files used to provision and manage the "Mela Bike" infrastructure on Hetzner Cloud. The setup is specifically tailored to securely host an Odoo production application alongside a Traccar GPS tracking service.

Architecture & Features

The automated Infrastructure as Code (IaC) configuration handles the deployment of the following resources:

Compute Instance: Provisions a cost-efficient ARM64 server (cax21) running Ubuntu 22.04 in the Falkenstein (fsn1) data center.

Persistent Storage: Attaches a dedicated 10GB ext4 formatted block volume to the server to securely store application data.

Networking: Creates an isolated private network (10.0.0.0/16) and subnet (10.0.1.0/24) in the eu-central zone.

Security & Firewalls: Configures a Hetzner Cloud firewall that restricts inbound traffic to essential services only:

Port 22 (TCP): SSH Access.

Ports 80 & 443 (TCP): HTTP/HTTPS traffic for Odoo and Traefik.

Port 5013 (TCP/UDP): Ingestion for Traccar GPS Devices (specifically SinoTrack ST915 using the H02 Protocol).

Automated Bootstrapping: Uses a cloud-init.yaml configuration to automatically configure the system on the first boot. This process:

Creates a passwordless odoo user with sudo privileges and adds them to the docker group.

Installs and enables docker.io and docker-compose.

Enables and configures the local Uncomplicated Firewall (UFW) to permit ports 22, 80, and 443.

Automatically formats and mounts the external Hetzner volume to the /data directory.

Prerequisites

To deploy this infrastructure, you will need the following installed and configured:

Terraform: Version 0.12 or higher (tested with provider hetznercloud/hcloud ~> 1.45).

Hetzner Cloud Account: An active Hetzner Cloud API token to authorize infrastructure creation.

SSH Keys: An SSH public key pair to allow secure access into the newly created server.

Configuration & Variables

Before executing Terraform, you must provide values for the variables defined in variables.tf. It is recommended to create a terraform.tfvars file in the root directory.

(Note: *.tfvars files are excluded from source control by the .gitignore policy to prevent leaking secrets).

Required variables include:

hcloud_token: Your sensitive Hetzner Cloud API token.

user_keys: A map containing usernames and their corresponding SSH public keys, which will be attached dynamically to the server instance.

Example terraform.tfvars:

hcloud_token = "your_super_secret_hetzner_api_token_here"

user_keys = {
  "admin1" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC..."
  "admin2" = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAI..."
}


Deployment Instructions

Initialize Terraform: Download the required providers and set up the working directory.

terraform init


Preview Changes: Review the infrastructure additions and changes before they are provisioned.

terraform plan


Apply Configuration: Deploy the infrastructure. You will be prompted to confirm the execution.

terraform apply


Outputs

Upon successful completion of the deployment, Terraform will print the public IPv4 address of the newly provisioned Odoo server to your console (server_ip). You can use this IP to SSH into the machine or to configure your domain's DNS records.

# Example Output
server_ip = "198.51.100.12"
