output "network_id" {
  description = "The ID of the stage network"
  value       = module.vpc.network_id
}

output "subnet_id" {
  description = "The ID of the stage subnet"
  value       = module.vpc.subnet_id
}

output "subnet_ip_range" {
  description = "The CIDR block of the stage subnet"
  value       = module.vpc.subnet_ip_range
}