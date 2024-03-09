locals {
  sailthru_IPs = [
    "100.25.66.222/32",
    "136.175.24.64/30",
    "136.175.25.64/30",
    "162.208.117.0/24",
    "162.208.117.58/32",
    "163.47.180.0/23",
    "173.228.155.0/24",
    "192.64.236.0/24",
    "192.64.237.0/24",
    "192.64.238.0/24",
    "204.153.121.0/24",
    "3.143.206.16/30",
    "3.89.166.254/32",
    "44.192.201.56/30",
    "52.86.20.3/32",
    "64.34.47.128/27",
    "64.34.57.192/26",
    "65.39.215.0/24",
    "66.216.49.248/29",
    "66.216.55.248/29",
    "66.216.58.64/27"
  ]
}

resource "cloudflare_filter" "sailthru" {
  zone_id     = var.zone_id
  description = "Sailthru IPs"
  expression  = "( ip.src in { ${join("\n", local.sailthru_IPs)} } )"
}

resource "cloudflare_firewall_rule" "sailthru" {
  zone_id     = var.zone_id
  description = "Sailthru"
  filter_id   = cloudflare_filter.sailthru.id
  action      = "allow"
  priority    = 5580
}
