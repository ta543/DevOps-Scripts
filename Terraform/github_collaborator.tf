
# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator

# XXX: Edit resource name
resource "github_repository_collaborator" "ci" {
  repository = "my-repo"            # XXX: Edit
  username   = "my-ci-machine-user" # XXX: Edit
  permission = "pull"
}
