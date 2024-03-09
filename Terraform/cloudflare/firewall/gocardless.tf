locals {
  # https://developer.gocardless.com/api-reference/#overview-approved-ip-addresses
  gocardless_IPs = [
    "35.204.73.47",
    "35.204.191.250",
    "35.204.214.181"
  ]
}

resource "cloudflare_filter" "gocardless" {
  zone_id     = var.zone_id
  description = "GoCardless IPs"
  expression  = "( ip.src in { ${join("\n", local.gocardless_IPs)} } )"
}

resource "cloudflare_firewall_rule" "gocardless" {
  zone_id     = var.zone_id
  description = "GoCardless"
  filter_id   = cloudflare_filter.gocardless.id
  action      = "allow"
  priority    = 5530
}
