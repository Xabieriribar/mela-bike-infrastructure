module "vpc" {
  source = "github.com/Xabieriribar/mela-bike-modules//networking/vpc?ref=v1.0.1"

  name             = var.network_name
  network_ip_range = var.network_ip_range
  subnet_ip_range  = var.subnet_ip_range
  network_zone     = var.network_zone
}