variable "vultr_api_key" {
  description = "Vultr API key"
  type        = string
}

variable "cloudflare_email" {
  description = "Cloudflare Email"
  type        = string
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
  type        = string
}

variable "cloudflare_domain_name" {
  description = "Domain name registered in Cloudflare account."
  type        = string
}

variable "subdomains" {
  description = "Subdomain list."
  type        = list(string)
}

variable "ssh_key_name" {
  description = "Name of public key registered in Vultr account."
  type        = string
}

variable "k3s_token" {
  description = "shared token for k3s cluster."
  type        = string
}
