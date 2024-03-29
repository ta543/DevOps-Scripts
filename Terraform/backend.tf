terraform {
  backend "s3" {
    bucket         = "X"
    key            = "terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "terraform_locks"
    encrypt        = true
  }
}




terraform {
  backend "remote" {
  #  hostname = "app.terraform.io"  # for Terraform Enterprise adjust this to your on-prem installation address
  #  organization = "mycompany"  # XXX: EDIT
  #
  #  workspaces {
  #    # XXX: EDIT
  #    # single workspace
  #    name = "my-app-prod"
  #    # or multiple workspaces - prompts with a list of prefix matching workspaces at runtime
  #    prefix = "my-app-"
  #  }
  #}
}





