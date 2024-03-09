
# Get dynamic data from outside Terraform to use elsewhere in manifests, such as finding a suitable EC2 AMI for the region

data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

  # TODO: add more filters here such as search for Ubuntu 20.04 LTS
}

output "AMI-id" {
  value = data.aws_ami.myAMI.id
}
