variable "network_name" {
  description = "The name of the stage network"
  type        = string
  default     = "mela-bike-stage"

  validation {
    condition     = length(trimspace(var.network_name)) > 0
    error_message = "network_name must not be empty."
  }
}

variable "network_ip_range" {
  description = "The CIDR block for the stage network"
  type        = string
  default     = "10.20.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.network_ip_range))
    error_message = "network_ip_range must be a valid CIDR block."
  }
}

variable "subnet_ip_range" {
  description = "The CIDR block for the stage subnet"
  type        = string
  default     = "10.20.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_ip_range))
    error_message = "subnet_ip_range must be a valid CIDR block."
  }
}

variable "network_zone" {
  description = "The network zone for the stage subnet"
  type        = string
  default     = "eu-central"

  validation {
    condition     = length(trimspace(var.network_zone)) > 0
    error_message = "network_zone must not be empty."
  }
}