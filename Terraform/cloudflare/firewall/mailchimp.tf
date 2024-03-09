locals {
  # https://mailchimp.com/about/ips/
  mailchimp_IPs = [
    "205.201.128.0/20",
    "198.2.128.0/18 ",
    "148.105.0.0/16"
  ]
}

resource "cloudflare_filter" "mailchimp" {
  zone_id     = var.zone_id
  description = "MailChimp IPs"
  expression  = "( ip.src in { ${join("\n", local.mailchimp_IPs)} } )"
}

resource "cloudflare_firewall_rule" "mailchimp" {
  zone_id     = var.zone_id
  description = "MailChimp"
  filter_id   = cloudflare_filter.mailchimp.id
  action      = "allow"
  priority    = 5540
}
