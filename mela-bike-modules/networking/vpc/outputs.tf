output "network_id" {
  description = "The ID of the network"
  value       = hcloud_network.this.id
}

output "subnet_id" {
  description = "The ID of the subnet"
  value       = hcloud_network_subnet.this.id
}

output "subnet_ip_range" {
  description = "The CIDR block of the subnet"
  value       = hcloud_network_subnet.this.ip_range
}