# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository

# See this script to find any repos that exist in GitHub but not Terraform to find any manually created repos:
#
#   github_repos_not_in_terraform.sh
#
#     https://github.com/HariSekhon/DevOps-Bash-tools

resource "github_repository" "repo" {
  name        = var.name
  description = var.description

  # initial commit creates default branch so that branch protection can be applied (errors out otherwise)
  auto_init = true

  # this module is really just to avoid duplicating all these settings you may want to standardize across all repos without repetition
  allow_auto_merge       = true
  allow_rebase_merge     = false
  archive_on_destroy     = true # safety net for this issue: https://github.com/argoproj/argo-cd/issues/6013#issuecomment-1554412221
  delete_branch_on_merge = true # clean up branches automatically after merge
  has_downloads          = true
  has_issues             = true
  has_wiki               = false          # use a real wiki, don't let people write here
  visibility             = var.visibility # allow this to be variable in case you want some variation of public/private/internal repos
  vulnerability_alerts   = true

  topics = var.topics

  dynamic "pages" {
    for_each = var.pages
    content {
      source {
        branch = pages.value.branch
        path   = pages.value.path
      }
    }
  }

  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
    ignore_changes = [
      etag,
    ]
  }

}

data "github_repository" "repo" {
  full_name = github_repository.repo.full_name
}
