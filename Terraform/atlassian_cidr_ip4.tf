#
# https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/data_source
#
data "http" "atlassian_ips" {
  url = "https://ip-ranges.atlassian.com/"

  request_headers = {
    Accept = "application/json"
  }
}

# verifies SSL - gets a casting type error though - Error: command "curl" produced invalid JSON: json: cannot unmarshal number into Go value of type string
#data "external" "atlassian_ips" {
#  program = ["curl", "-sSL", "https://ip-ranges.atlassian.com/"]
#}

locals {
  atlassian_ips_data = jsondecode("${data.http.atlassian_ips.body}")
  #atlassian_ips_data = jsondecode("${data.external.atlassian_ips.result}")
  atlassian_cidr_ipv4 = [
    for item in "${local.atlassian_ips_data.items}" :
    item.cidr if length(regexall(":|[[:alpha:]]", item.cidr)) < 1
  ]
}

output "atlassian_cidr_ip4" {
  value = local.atlassian_cidr_ipv4
}
