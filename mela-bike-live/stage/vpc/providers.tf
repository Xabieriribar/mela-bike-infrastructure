terraform {
  required_version = ">= 1.5.0, < 2.0.0"

  backend "s3" { key = "stage/vpc/terraform.tfstate" }

  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.50.0, < 2.0.0"
    }
  }
}

provider "hcloud" {}