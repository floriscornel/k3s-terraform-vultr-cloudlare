provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

data "cloudflare_zones" "domain_zone" {
  filter {
    name = var.cloudflare_domain_name
  }
}

resource "cloudflare_record" "dns_record_v4" {
  for_each = toset(var.subdomains)
  zone_id  = lookup(data.cloudflare_zones.domain_zone.zones[0], "id")
  name     = each.key
  value    = vultr_instance.k3s_server.main_ip
  type     = "A"
  proxied  = false
}

resource "cloudflare_record" "dns_record_v6" {
  for_each = toset(var.subdomains)
  zone_id  = lookup(data.cloudflare_zones.domain_zone.zones[0], "id")
  name     = each.key
  value    = vultr_instance.k3s_server.v6_main_ip
  type     = "AAAA"
  proxied  = false
}
