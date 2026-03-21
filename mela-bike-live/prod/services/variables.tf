variable "server_name" {
  description = "The name of the production server"
  type        = string
  default     = "mela-bike-prod"
}

variable "server_type" {
  description = "The server type for production"
  type        = string
  default     = "cpx22"
}

variable "image" {
  description = "The OS image for production"
  type        = string
  default     = "ubuntu-22.04"
}

variable "location" {
  description = "The Hetzner location for production"
  type        = string
  default     = "fsn1"
}

variable "ssh_keys" {
  description = "The SSH keys to install on the production server"
  type        = list(string)
  default     = []
}

variable "ssh_source_ips" {
  description = "Allowed source IPs for SSH"
  type        = list(string)
}
variable "odoo_domain" {
  description = "Public domain for the Odoo instance"
  type        = string
}

variable "odoo_db_name" {
  description = "Database name Odoo should use by default"
  type        = string
  default     = ""
}
