data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "odoo-infra-production-state"
    key    = "prod/services/terraform.tfstate"
    region = "eu-central"

    endpoints = {
      s3 = "https://fsn1.your-objectstorage.com"
    }

    skip_requesting_account_id  = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    use_path_style              = true
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
  source = "github.com/Xabieriribar/mela-bike-modules//networking/firewall?ref=v1.0.1"

  name          = "${var.server_name}-firewall"
  inbound_rules = local.inbound_rules
}

module "app_server" {
  source = "github.com/Xabieriribar/mela-bike-modules//services/app-server?ref=v1.0.1"

  server_name = var.server_name
  server_type = var.server_type
  image       = var.image
  location    = var.location
  network_id  = data.terraform_remote_state.vpc.outputs.network_id
  firewall_id = module.firewall.firewall_id
  ssh_keys    = var.ssh_keys
  user_data = templatefile("${path.module}/cloud-init.yaml.tftpl", {
    odoo_domain = var.odoo_domain
})
}