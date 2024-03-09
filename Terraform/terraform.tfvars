
# XXX: Not used in Terraform Cloud - must set in workspace instead or use *.auto.tfvars
#                                  - see terraform_cloud_*.sh scripts for easy credential uploads to Terraform Cloud
#                                    in DevOps Bash tools repo: https://github.com/H;wariSekhon/DevOps-Bash-tools

# AWS
#
#   https://docs.aws.amazon.com/general/latest/gr/rande.html#ec2_region
#
profile = "default"
region  = "eu-west-2"

# GCP
#
#   https://cloud.google.com/compute/docs/regions-zones#available
#
project = "myproject-123456"
#region  = "europe-west2"

vpc_name = "default"

node_count = 3

private_cidrs = [
  "10.0.0.0/8",
  "172.16.0.0/16",
  "192.168.0.0/16"
  # XXX: set your 3rd party VPN provider's address range here for restricting access to these address ranges in firewall rules defined in main.tf
]
