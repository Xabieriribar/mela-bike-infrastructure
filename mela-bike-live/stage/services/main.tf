data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

locals {
  inbound_rules = [
    {
      protocol   = "tcp"
      port       = "22"
      source_ips = var.ssh_source_ips
    },
    {
      protocol   = "tcp"
      port       = "80"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol   = "tcp"
      port       = "5000-5150"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      protocol   = "udp"
      port       = "5000-5150"
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]
}

module "firewall" {
  source = "../../../mela-bike-modules/networking/firewall"

  name          = "${var.server_name}-firewall"
  inbound_rules = local.inbound_rules
}

module "app_server" {
  source = "../../../mela-bike-modules/services/app-server"

  server_name = var.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  network_id  = data.terraform_remote_state.vpc.outputs.network_id
  firewall_id = module.firewall.firewall_id
  ssh_keys    = var.ssh_keys
}