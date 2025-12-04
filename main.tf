# 1. SSH KEYS (Dynamic Loop from Book)
resource "hcloud_ssh_key" "users" {
  for_each   = var.user_keys
  name       = each.key
  public_key = each.value
}

# 2. SERVER (Website Specs + Book Logic)
resource "hcloud_server" "odoo_app" {
  name        = "odoo-app-prod"
  image       = "ubuntu-22.04"
  server_type = "cax21"
  location    = "fsn1"

  # CRITICAL FIX: This links the keys created above to this server
  # "values(...)[*].id" is a Splat Expression (Book Chapter 2/5)
  ssh_keys    = values(hcloud_ssh_key.users)[*].id

  user_data    = file("${path.module}/config/cloud-init.yaml")
  firewall_ids = [hcloud_firewall.odoo_base.id]

  # Ensure network is ready before server creation
  depends_on = [hcloud_network_subnet.odoo_subnet]
}

# 3. NETWORK (Website Architecture)
resource "hcloud_network" "odoo_private" {
  name     = "odoo-private-network"
  ip_range = "10.0.0.0/16"
}

# FIX: This must be a 'hcloud_network_subnet', not 'hcloud_network'
resource "hcloud_network_subnet" "odoo_subnet" {
  network_id   = hcloud_network.odoo_private.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.1.0/24"
}

# 4. FIREWALL (Website Security)
resource "hcloud_firewall" "odoo_base" {
  name = "odoo-base-firewall"

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = ["0.0.0.0/0"]
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443" # Fixed typo: was 433
    source_ips = ["0.0.0.0/0"]
  }
}
