output "server_ip" {
  description = "The public IP of the Odoo server"
  value       = hcloud_server.odoo_app.ipv4_address
}
