output "network_id" {
    value = hcloud_network.main.id
    description = "The ID of the created network"
}

output "subnet_id" {
    value = hcloud_network_subnet.main.id
    description = "The ID of the created subnet"
}