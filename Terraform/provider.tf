terraform {

  required_version = ">= 0.13"

  required_providers {
    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }

    # https://registry.terraform.io/providers/hashicorp/google/latest/docs
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }

    # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
    azure = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }

    # https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
    cloudflare = {
      source = "cloudflare/cloudflare"
    }

    # https://registry.terraform.io/providers/integrations/github/latest/docs
    github = {
      source  = "integrations/github"
      version = "~> 4.24.1"
    }

    # https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/data_source
    external = {
      source  = "hashicorp/external"
      version = "~> 2.2.0"
    }

  }

}


# https://registry.terraform.io/providers/hashicorp/aws/latest/docs
provider "aws" {
  profile = "default"
  region  = var.region
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.project
  region  = var.gcp_region
}

# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs
provider "azure" {
  features {}
}

# https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs
provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

provider "http" {}

# https://registry.terraform.io/providers/integrations/github/latest/docs
provider "github" {
  #organization = "myorg" # higher precedence than owner, see doc link above
  owner = "HariSekhon" # user or organization
  # throttle to avoid hitting GitHub API rate limits with long 1 hour back-offs causing hours of hanging
  #
  #   https://github.com/integrations/terraform-provider-github/issues/1153
  #
  # calculated from 15,000 reqs/hour for GitHub Enterprise - 15000 / 3600 = 4 or 5 reqs per second => 200ms throttle
  #
  #read_delay_ms  = 200 # ms
  #write_delay_ms = 200 # ms
}

# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs
#provider "kubernetes" {}

# https://registry.terraform.io/providers/hashicorp/helm/latest/docs
#provider "helm" {}
