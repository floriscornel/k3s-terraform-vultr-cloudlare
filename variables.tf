variable "vultr_api_key" {
  description = "Vultr API key"
  type        = string
}

variable "ssh_public_key_url" {
  description = "Url to public key(s) (e.g. https://github.com/cornelfh.keys)"
  type        = string
}

variable "ssh_private_key" {
  description = "Path of private key (e.g. '~/.ssh/id_rsa')."
  type        = string
}

variable "k3s_token" {
  description = "shared token for k3s cluster."
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
