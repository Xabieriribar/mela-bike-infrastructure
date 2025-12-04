variable "hcloud_token" {
	description = "The API token for Hetzner Cloud"
	type = string
	sensitive = true
}

variable "user_keys" {
	description = "A map of user names and their SSH public keys"
	type	= map(string)
	default = {}
}
