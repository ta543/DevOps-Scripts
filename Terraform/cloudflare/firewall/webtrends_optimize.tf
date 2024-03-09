locals {
  webtrends_optimize_IPs = [
    "213.123.137.249",
    "62.31.105.234"
  ]
}

resource "cloudflare_filter" "webtrends-optimize" {
  zone_id     = var.zone_id
  description = "Webtrends Optimize IPs"
  expression  = "( ip.src in { ${join("\n", local.webtrends_optimize_IPs)} } )"
}

resource "cloudflare_firewall_rule" "webtrends-optimize" {
  zone_id     = var.zone_id
  description = "Webtrends Optimize"
  filter_id   = cloudflare_filter.webtrends-optimize.id
  action      = "allow"
  priority    = 5600
}
