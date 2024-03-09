# https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/data_source
#
data "http" "github_meta" {
  url = "https://api.github.com/meta"

  request_headers = {
    Accept = "application/json"
  }
}

# verifies SSL unlike http provider but cannot return an array of IPs like I need
#data "external" "github_webhook_ips" {
#  # Error: command "curl" produced invalid JSON: json: cannot unmarshal bool into Go value of type string
#  #program = ["curl", "-sSL", "https://api.github.com/meta"]
#  # Error: command "bash" produced invalid JSON: json: cannot unmarshal object into Go value of type string
#  #program = ["bash", "-c", "curl -sSL https://api.github.com/meta | jq 'walk(if type == \"boolean\" then tostring else . end)'"]
#  # this requires map[string]string which is not suitable for a list of IPs
#}

locals {
  github_ips_data    = jsondecode(data.http.github_meta.body)
  github_webhook_IPs = local.github_ips_data.hooks
}

resource "cloudflare_filter" "github_webhooks" {
  zone_id     = var.zone_id
  description = "GitHub Webhook IPs"
  expression  = "(ip.src in { ${join("\n", local.github_webhook_IPs)} } )"
}

resource "cloudflare_firewall_rule" "github_webhooks" {
  zone_id     = var.zone_id
  description = "GitHub Webhooks"
  filter_id   = cloudflare_filter.github_webhooks.id
  action      = "allow"
  priority    = 5520
}
