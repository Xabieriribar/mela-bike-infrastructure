variable "network_name" {
    description = "The name to use for the network"
    type        = string
}

variable "network_ip_range" {
    description = "The CIDR block for the entire network"
    type        = string
}

variable "subnet_ip_range" {
    description = "The CIDR block for the subnet"
    type        = string
}

variable "network_zone" {
    description = "The network zone (e.g., eu-central)"
    type        = string
}