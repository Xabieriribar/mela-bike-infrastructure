variable "name" {
  description = "The name of the firewall"
  type        = string
}

variable "inbound_rules" {
  description = "Inbound firewall rules"
  type = list(object({
    protocol   = string
    port       = string
    source_ips = list(string)
  }))
}