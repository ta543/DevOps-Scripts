# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator

resource "github_repository_collaborator" "ci" {
  repository = github_repository.repo.id
  username   = "my-ci-machine-user"
  #permission = var.ci_permission # may need to set this to "admin" if using this account to run Terraform CI/CD
  permission = "admin"
}

resource "github_user_invitation_accepter" "ci" {
  invitation_id = github_repository_collaborator.ci.invitation_id
}
