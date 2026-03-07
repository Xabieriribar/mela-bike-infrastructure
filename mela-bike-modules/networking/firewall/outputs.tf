output "firewall_id" {
  description = "The ID of the firewall"
  value       = hcloud_firewall.this.id
}