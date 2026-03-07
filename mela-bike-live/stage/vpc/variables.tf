variable "network_name" {
  description = "The name of the stage network"
  type        = string
  default     = "mela-bike-stage"
}

variable "network_ip_range" {
  description = "The CIDR block for the stage network"
  type        = string
  default     = "10.20.0.0/16"
}

variable "subnet_ip_range" {
  description = "The CIDR block for the stage subnet"
  type        = string
  default     = "10.20.1.0/24"
}

variable "network_zone" {
  description = "The network zone for the stage subnet"
  type        = string
  default     = "eu-central"
}