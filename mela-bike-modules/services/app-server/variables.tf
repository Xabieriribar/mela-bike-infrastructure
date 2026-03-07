variable "server_name" {
  description = "The server name"
  type        = string
}

variable "server_type" {
  description = "The Hetzner server type"
  type        = string
}

variable "image" {
  description = "The OS image"
  type        = string
}

variable "location" {
  description = "The Hetzner location"
  type        = string
}

variable "network_id" {
  description = "The network ID to attach the server to"
  type        = string
}

variable "firewall_id" {
  description = "The firewall ID to attach to the server"
  type        = string
}

variable "ssh_keys" {
  description = "SSH keys to install on the server"
  type        = list(string)
  default     = []
}

variable "user_data" {
  description = "Optional cloud-init user_data"
  type        = string
  default     = null
}