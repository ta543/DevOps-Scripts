locals {
  VPN_IPs = [
    # XXX: Edit
    "x.x.x.x"
  ]
}

resource "cloudflare_filter" "vpn" {
  zone_id     = var.zone_id
  description = "VPN IPs"
  expression  = "( ip.src in { ${join("\n", local.VPN_IPs)} } )"
}

resource "cloudflare_firewall_rule" "vpn" {
  zone_id     = var.zone_id
  description = "VPN"
  filter_id   = cloudflare_filter.vpn.id
  action      = "allow"
  priority    = 5590
}
