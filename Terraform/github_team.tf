
locals {
  github_teams = [
    "team1",
    "team2",
  ]
}

resource "github_team" "team" {
  for_each = toset(local.github_teams)
  name     = each.key

  privacy = "closed" # must be "closed", not "secret", otherwise can't be @mentioned or used in CODEOWNERS for auto PR review requests

  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
  }
}
