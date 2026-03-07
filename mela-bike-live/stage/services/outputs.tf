output "firewall_id" {
  description = "The ID of the firewall protecting the stage server"
  value       = module.firewall.firewall_id
}

output "server_id" {
  description = "The ID of the stage server"
  value       = module.app_server.server_id
}

output "server_ipv4_address" {
  description = "The public IPv4 address of the stage server"
  value       = module.app_server.ipv4_address
}