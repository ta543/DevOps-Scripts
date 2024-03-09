resource "github_repository" "NAME" {
  name        = "NAME"
  description = ""

  # initial commit creates default branch so that branch protection can be applied (errors out otherwise)
  auto_init = true

  allow_rebase_merge     = false
  archive_on_destroy     = true # safety net for this issue: https://github.com/argoproj/argo-cd/issues/6013#issuecomment-1554412221
  delete_branch_on_merge = true # clean up branches automatically after merge
  has_downloads          = true
  has_issues             = true
  has_wiki               = false     # use a real wiki, don't let people write here
  visibility             = "private" # or "public", or "internal" (available only in an Org)
  vulnerability_alerts   = true

  topics = [
  ]

  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
  }
}

# or using the adjacent module to standardize + deduplicate common settings
module "repo-NAME" {
  source      = "../modules/github_repo"
  name        = "NAME"
  description = ""
  # set this to prevent overwriting shared workflows with the client deployed workflows eg. semgrep.yaml
  #actions_repo = true
}
