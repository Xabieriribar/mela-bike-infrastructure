variable "server_name" {
  description = "The name of the temporary recovery server"
  type        = string
  default     = "mela-bike-recovery"
}

variable "server_type" {
  description = "The server type for the temporary recovery server"
  type        = string
  default     = "cpx22"
}

variable "image" {
  description = "The OS image for the temporary recovery server"
  type        = string
  default     = "ubuntu-24.04"
}

variable "location" {
  description = "The Hetzner location for the temporary recovery server"
  type        = string
  default     = "nbg1"
}

variable "ssh_keys" {
  description = "The SSH keys to install on the temporary recovery server"
  type        = list(string)
  default     = []
}

variable "ssh_source_ips" {
  description = "Allowed source IPs for SSH and temporary admin access"
  type        = list(string)
}

variable "odoo_domain" {
  description = "Optional public domain for the temporary recovery server"
  type        = string
  default     = ""
}

variable "odoo_db_name" {
  description = "Database name Odoo should use by default after recovery"
  type        = string
  default     = ""
}
