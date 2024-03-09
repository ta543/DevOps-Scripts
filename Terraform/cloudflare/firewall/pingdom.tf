data "http" "pingdom_probes_ipv4" {
  url = "https://my.pingdom.com/probes/ipv4"
}

locals {
  pingdom_IPs = data.http.pingdom_probes_ipv4.body
}

resource "cloudflare_filter" "pingdom" {
  zone_id     = var.zone_id
  description = "Pingdom IPs"
  expression  = "(ip.src in {${local.pingdom_IPs}})"
}

resource "cloudflare_firewall_rule" "pingdom" {
  zone_id     = var.czone_id
  description = "Pingdom"
  filter_id   = cloudflare_filter.pingdom.id
  action      = "allow"
  priority    = 5550
}
