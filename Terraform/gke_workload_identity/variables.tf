variable "project" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "k8s_service_account" {
  type = string
}

variable "description" {
  type    = string
  default = ""
}

variable "display_name" {
  type    = string
  default = ""
}
