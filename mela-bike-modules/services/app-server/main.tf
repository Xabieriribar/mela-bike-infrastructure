resource "hcloud_server" "this" {
    name        = var.server_name
    server_type = var.server_type
    image       = var.image
    location    = var.location

    firewall_ids    = [var.firewall_id]

    ssh_keys        = var.ssh_keys
    user_data       = var.user_data
    
    network {
        network_id = var.network_id
    }
}