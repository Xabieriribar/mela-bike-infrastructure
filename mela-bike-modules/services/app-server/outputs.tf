output "server_id" {
  description = "The ID of the server"
  value       = hcloud_server.this.id
}

output "ipv4_address" {
  description = "The public IPv4 address of the server"
  value       = hcloud_server.this.ipv4_address
}