variable "name" {
  description = "The name of the network"
  type        = string
}

variable "network_ip_range" {
  description = "The CIDR block for the network"
  type        = string
}

variable "subnet_ip_range" {
  description = "The CIDR block for the subnet"
  type        = string
}

variable "network_zone" {
  description = "The network zone for the subnet"
  type        = string
}