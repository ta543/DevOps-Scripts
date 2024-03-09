data "http" "aws_ip_ranges" {
  url = "https://ip-ranges.amazonaws.com/ip-ranges.json"

  request_headers = {
    Accept = "application/json"
  }
}

locals {
  aws_ip_ranges_data = jsondecode(data.http.aws_ip_ranges.body)
  aws_IPs            = local.aws_ip_ranges_data.prefixes[*]
  aws_us_east_1_IPs = [
    for x in local.aws_IPs :
    x.ip_prefix if x.region == "us-east-1" &&
    x.service == "EC2"
  ]
}

resource "cloudflare_filter" "aws_us-east-1-ec2" {
  zone_id     = var.zone_id
  description = "AWS us-east-1 EC2 IPs"
  expression  = "(ip.src in { ${join("\n", local.aws_us_east_1_IPs)} } )" # and http.host eq \"MY.DOMAIN.COM\" and http.request.uri.path matches \"^/MY/PATH/\" and ssl )"
}

resource "cloudflare_firewall_rule" "aws_us-east-1-ec2" {
  zone_id     = var.zone_id
  description = "Zapier / AWS us-east-1 EC2"
  filter_id   = cloudflare_filter.aws_us-east-1-ec2.id
  action      = "allow"
  priority    = 5610
}

#output "aws_us-east-1_IPs" {
#  #value = local.aws_IPs
#  value = local.aws_us_east_1_IPs
#}
