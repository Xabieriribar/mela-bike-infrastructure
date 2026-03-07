variable "network_name" {
  description = "The name of the production network"
  type        = string
  default     = "mela-bike-prod"
}

variable "network_ip_range" {
  description = "The CIDR block for the production network"
  type        = string
  default     = "10.10.0.0/16"
}

variable "subnet_ip_range" {
  description = "The CIDR block for the production subnet"
  type        = string
  default     = "10.10.1.0/24"
}

variable "network_zone" {
  description = "The network zone for the production subnet"
  type        = string
  default     = "eu-central"
}