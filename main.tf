# --- 1. ACCESS CONTROL ---
resource "hcloud_ssh_key" "users" {
  for_each   = var.user_keys
  name       = each.key
  public_key = each.value
}

# --- 2. NETWORK ARCHITECTURE ---
resource "hcloud_network" "odoo_private" {
  name     = "odoo-private-network"
  ip_range = "10.0.0.0/16"
}

resource "hcloud_network_subnet" "odoo_subnet" {
  network_id   = hcloud_network.odoo_private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# --- 3. SECURITY ---
resource "hcloud_firewall" "odoo_base" {
  name = "odoo-base-firewall"

  # SSH
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["0.0.0.0/0"]
  }

  # HTTP (Odoo/Traefik)
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = ["0.0.0.0/0"]
  }

  # HTTPS (Odoo/Traefik)
  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443" # Corrected from 433
    source_ips = ["0.0.0.0/0"]
  }
}

# --- 4. COMPUTE INSTANCE ---
resource "hcloud_server" "odoo_app" {
  name        = "odoo-app-prod"
  image       = "ubuntu-22.04"
  server_type = "cax21" # ARM64 (Cheaper/Efficient)
  location    = "fsn1"  # Falkenstein DC

  # Dynamic Key Attachment
  ssh_keys    = values(hcloud_ssh_key.users)[*].id

  # Automated Bootstrapping
  user_data   = file("${path.module}/config/cloud-init.yaml")

  # Security Attachment
  firewall_ids = [hcloud_firewall.odoo_base.id]

  # Wait for network to be ready before creating server
  depends_on = [hcloud_network_subnet.odoo_subnet]
}

resource "hcloud_volume" "odoo_data" {
	name = "odoo-data-volume"
	size = 10
	location = "fsn1"
	format = "ext4"
	automount = false
}

resource "hcloud_volume_attachment" "main" {
	volume_id = hcloud_volume.odoo_data.id
	server_id = hcloud_server.odoo_app.id
	automount = false
}
