variable "name"  {
    type = string
}

variable "inbound_rules" {
    type = list(object ({
        protocol    = string
        port        = string
    }))
}