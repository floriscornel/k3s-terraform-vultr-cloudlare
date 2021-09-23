terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "2.4.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 2.0"
    }
  }
}
