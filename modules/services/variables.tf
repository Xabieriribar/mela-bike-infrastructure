variable "server_name" {
    description = "The name of the Mela Bike server"
    type        = string
}

variable "server_type" {
    description = "The type of server"
    type        = string
}

variable "image" {
    description = "The OS image"
    type        = string
}

variable "location" {
    description = "The data center location"
    type        = string
}

variable "network_id" {
    description = "The ID of the VPC network to attach the server to"
    type        = string
}

variable "ssh_keys" {
    description = "A map of SSH public keys to add to the server"
    type        = map(string)
}