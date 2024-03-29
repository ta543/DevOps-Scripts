
# AWS
variable "profile" {
  type    = string
  default = "default"
}

# GCP
variable "project" {
  type = string
  #default = "myproject-123456"
}

variable "vpc_name" {
  type = string
  #default = "default"
}


variable "some_secret" {
  type        = string
  description = "Description shown at CLI prompt if not auto provided via terraform.tfvars, *.auto.tfvars, TF_VAR_ etc"
  sensitive   = true # obscures in 'terraform plan' but still echo's when input prompted on CLI
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
  validation {
    condition     = can(regex("^t3\\.", var.instance_type))
    error_message = "Must be a t3 type instance."
  }
}

variable "myvar" {
  type    = string
  default = "testing"
  validation {
    condition     = length(var.myvar) > 4
    error_message = "The string must be more than 4 characters."
  }
}

variable "node_count" {
  # only accept integers/floats
  type = number
  #default = 2
}

variable "private_cidrs" {
  type = list(any)
  default = [
    "10.0.0.0/8",
    "172.16.0.0/16",
    "192.168.0.0/16"
  ]
}
