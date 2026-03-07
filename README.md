# 🚲 Mela Bike Infrastructure

Terraform configuration files used to provision and manage the Mela Bike infrastructure on Hetzner Cloud using Infrastructure as Code (IaC) principles.

---

## 📋 Project Overview
This setup is specifically tailored to securely host an **Odoo** production application alongside a **Traccar** GPS tracking service. By using Terraform, the entire environment—from networking to storage—is reproducible and version-controlled.

---

## 🏗️ Architecture & Features
The automated configuration handles the deployment of the following resources:

* **Compute Instance**: Provisions a cost-efficient **ARM64** server (`cax21`) running Ubuntu 22.04 in the Falkenstein (`fsn1`) data center.
* **Persistent Storage**: Attaches a dedicated **10GB ext4** formatted block volume to the server to securely store application data.
* **Networking**: Creates an **isolated private network** (`10.0.0.0/16`) and subnet (`10.0.1.0/24`) in the `eu-central` zone.
* **Security & Firewalls**: Configures a Hetzner Cloud firewall restricting inbound traffic to essential services:
    * **Port 22 (TCP)**: SSH Access.
    * **Ports 80 & 443 (TCP)**: HTTP/HTTPS traffic for Odoo and Traefik.
    * **Port 5013 (TCP/UDP)**: Ingestion for Traccar GPS Devices (specifically SinoTrack ST915 using the H02 Protocol).

---

## 🤖 Automated Bootstrapping
Uses a `cloud-init.yaml` configuration to automatically configure the system on the first boot:

1.  Creates a passwordless **odoo user** with sudo privileges and adds them to the `docker` group.
2.  Installs and enables `docker.io` and `docker-compose`.
3.  Configures the local **Uncomplicated Firewall (UFW)** to permit ports 22, 80, and 443.
4.  Automatically **formats and mounts** the external Hetzner volume to the `/data` directory.

---

## ✅ Prerequisites
Before deployment, ensure you have the following:

* **Terraform**: Version 0.12 or higher (tested with provider `hetznercloud/hcloud ~> 1.45`).
* **Hetzner Cloud Account**: An active API token.
* **SSH Keys**: A public key pair for secure server access.

---

## ⚙️ Configuration & Variables
Provide values for variables defined in `variables.tf`. It is highly recommended to use a `terraform.tfvars` file (this file is ignored by git to prevent leaking secrets).

### Required Variables

| Variable | Description |
| :--- | :--- |
| **hcloud_token** | Your sensitive Hetzner Cloud API token. |
| **user_keys** | A map of usernames and their corresponding SSH public keys. |
