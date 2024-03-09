# replace with variables if inside module
locals {
  rules = [
    {
      port        = 80
      proto       = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      port        = 22
      proto       = "tcp"
      cidr_blocks = ["1.2.3.4/32"]
    }
  ]
}

resource "aws_security_group" "my-sg" {
  name   = "my-aws-security-group"
  vpc_id = "some-vpc" # aws_vpc.my-vpc.id
  dynamic "ingress" {
    for_each = local.rules # or var.rules if inside module
    content {
      from_port   = ingress.value["port"]
      to_port     = ingress.value["port"]
      protocol    = ingress.value["proto"]
      cide_blocks = ingress.value["cidr_blocks"]
    }
  }
}
