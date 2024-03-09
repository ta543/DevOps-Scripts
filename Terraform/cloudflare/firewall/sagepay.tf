locals {
  sagepay_IPs = [
    "195.170.169.0/24",
  ]
}

resource "cloudflare_filter" "sagepay" {
  zone_id     = var.zone_id
  description = "SagePay IPs"
  expression  = "( ip.src in { ${join("\n", local.sagepay_IPs)} } )"
}

resource "cloudflare_firewall_rule" "sagepay" {
  zone_id     = var.zone_id
  description = "SagePay"
  filter_id   = cloudflare_filter.sagepay.id
  action      = "allow"
  priority    = 5570
}
