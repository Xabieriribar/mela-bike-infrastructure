resource "hcloud_firewall" "mela_bike_fw" {
    name = "${var.server_name}-firewall"

    rule {
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
    }
}