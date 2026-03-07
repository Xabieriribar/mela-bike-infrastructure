variable "server_name" {
  type = string
}

variable "server_type" {
  type = string
}

variable "image" {
  type = string
}

variable "location" {
  type = string
}

variable "network_id" {
  type = string
}

variable "firewall_id" {
  type = string
}

variable "ssh_keys" {
  type    = list(string)
  default = []
}

variable "user_data" {
  type    = string
  default = null
}