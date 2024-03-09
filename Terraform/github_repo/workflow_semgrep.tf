resource "github_repository_file" "workflow-semgrep" {
  count               = var.actions_repo ? 0 : 1
  repository          = github_repository.repo.name
  branch              = data.github_repository.repo.default_branch
  file                = ".github/workflows/semgrep.yaml"
  content             = file("${path.module}/../../.github/workflows/semgrep.yaml") # path must be relative to module since Terraform doesn't understand relative to git root
  commit_message      = "Semgrep workflow managed by Terraform"
  overwrite_on_create = true

  lifecycle {
    ignore_changes = [
      commit_message,
      overwrite_on_create
    ]
  }
}
