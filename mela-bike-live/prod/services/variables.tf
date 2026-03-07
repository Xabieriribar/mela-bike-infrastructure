variable "server_name" {
  description = "The name of the production server"
  type        = string
  default     = "mela-bike-prod"

  validation {
    condition     = length(trimspace(var.server_name)) > 0
    error_message = "server_name must not be empty."
  }
}

variable "server_type" {
  description = "The server type for production"
  type        = string
  default     = "cax32"

  validation {
    condition     = length(trimspace(var.server_type)) > 0
    error_message = "server_type must not be empty."
  }
}

variable "image" {
  description = "The OS image for production"
  type        = string
  default     = "ubuntu-22.04"

  validation {
    condition     = length(trimspace(var.image)) > 0
    error_message = "image must not be empty."
  }
}

variable "location" {
  description = "The Hetzner location for production"
  type        = string
  default     = "fsn1"

  validation {
    condition     = length(trimspace(var.location)) > 0
    error_message = "location must not be empty."
  }
}

variable "network_id" {
  description = "The ID of the production network"
  type        = string
}

variable "ssh_keys" {
  description = "The SSH keys to install on the production server"
  type        = list(string)
  default     = []
}