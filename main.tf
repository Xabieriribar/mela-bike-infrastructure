
resource "hcloud_ssh_key" "users" {
	for_each = var.user_keys
	name	 = each.key
	public_key = each.value
}

resource "hcloud_server" "odoo_app" {
	name = "odoo-app-prod"
	image = "ubuntu-22.04"
	server_type = "cax21"
	location = "fsn1"
	user_data = file("${path.module}/config/cloud-init.yaml")
	firewall_ids = [hcloud_firewall.odoo_base.id]

resource "hcloud_network" "odoo_subnet" {
	network_id = hcloud_network.odoo_private.id
	type = "cloud"
	network_zone = "eu-central"
	ip_range = "10.0.1.0/24"
}

resource "hcloud_firewall" "odoo_base" {
	name = "odoo-base-firewall"
	
	rule {
		direction = "in"
		protocol = "tcp"
		port = "22"
		source_ips = ["0.0.0.0/0"]
	}

	rule {
		direction = "in"
		protocol = "tcp"
		port = "80"
		source_ips = ["0.0.0.0/0"]
	}

	rule {
		direction = "in"
		protocol = "tcp"
		port = "433"
		source_ips = ["0.0.0.0/0"]
	}
}
