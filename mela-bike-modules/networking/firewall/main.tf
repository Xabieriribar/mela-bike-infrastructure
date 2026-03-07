resource "hcloud_firewall" "this" {
  name = var.name

  dynamic "rule" {
    for_each = var.inbound_rules

    content {
      direction  = "in"
      protocol   = rule.value.protocol
      port       = rule.value.port
      source_ips = rule.value.source_ips
    }
  }
}