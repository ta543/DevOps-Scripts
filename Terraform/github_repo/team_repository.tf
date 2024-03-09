# automatically grant admin on the platform engineering team
resource "github_team_repository" "platform-engineering" {
  permission = "admin"
  repository = github_repository.repo.id
  team_id    = "platform-engineering" # team slug

  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
    ignore_changes = [
      etag,
    ]
  }
}
