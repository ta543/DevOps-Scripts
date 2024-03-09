resource "github_branch_default" "main" {
  repository = github_repository.repo.name
  branch     = "main"
}

resource "github_branch_protection" "default_branch" {
  repository_id = github_repository.repo.id

  pattern             = data.github_repository.repo.default_branch
  enforce_admins      = false # true prevents Terraform account from updating CODEOWNERS or other files
  allows_deletions    = false
  allows_force_pushes = false

  require_signed_commits          = false
  required_linear_history         = false
  require_conversation_resolution = false

  #required_status_checks {
  #  strict   = false
  #  contexts = []
  #}
  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
    ignore_changes = [
      # may want to add to this on a per repo basis and not have it standardized
      required_status_checks
    ]
  }

  #required_pull_request_reviews {
  #  required_approving_review_count = 0  # XXX: set to 1 to enforce mandatory reviews before PR merges
  #  require_code_owner_reviews: false    # XXX: set to true to enforce CODEOWNERS
  #  dismiss_stale_reviews  = false       # XXX: set to true to prevent slip throughs
  #  restrict_dismissals    = false
  #  #dismissal_restrictions = [
  #  #  data.github_user.harisekhon.node_id,
  #  #  github_team.devops.node_id,
  #  #]
  #}

  push_restrictions = [
    # limited to a list of one type of restriction (user, team, app)
    #data.github_user.harisekhon.node_id,
    #github_team.devops.node_id
  ]

}
