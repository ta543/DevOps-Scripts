# teams must be set to "closed" (visible in the UI), not "secret", otherwise they'll appear in PR draft but disappear in PR, looking like a bug, but it's expected behaviour, team visibility is a requirement

resource "github_repository_file" "codeowners" {
  repository = github_repository.repo.name
  branch     = data.github_repository.repo.default_branch
  file       = ".github/CODEOWNERS"
  # permit codeowners override in module caller using var below instead
  #content       = ".github/ @myorg/devops-team"
  # ensure there is a newline at end of file via EOT style so people with IDEs or pre-commit hooks aren't changing the file during PRs
  # XXX: Edit the MYORG/DEVOPS-TEAM with your actual github team (which must be Visible aka "closed" in Terraform)
  #%{if var.codeowners != ""}${var.codeowners}%{else}.github/ @MYORG/DEVOPS-TEAM%{endif}
  content        = <<EOF
# Managed by Terraform - DO NOT EDIT
CODEOWNERS          @MYORG/DEVOPS-TEAM
.github/            @MYORG/DEVOPS-TEAM
**devops**          @MYORG/DEVOPS-TEAM
**infrastructure**  @MYORG/DEVOPS-TEAM
**infra**           @MYORG/DEVOPS-TEAM
**terraform**       @MYORG/DEVOPS-TEAM
**docker**          @MYORG/DEVOPS-TEAM
**kubernetes**      @MYORG/DEVOPS-TEAM
**k8s**             @MYORG/DEVOPS-TEAM
**Dockerfile**      @MYORG/DEVOPS-TEAM
**Jenkinsfile**     @MYORG/DEVOPS-TEAM
**cloudbuild.y*ml** @MYORG/DEVOPS-TEAM
**.envrc**          @MYORG/DEVOPS-TEAM
${var.codeowners}
EOF
  commit_message = "CODEOWNERS managed by Terraform"
  # requires both or neither - uses the account owning the github token as the author if omitted
  #commit_author = "Terraform"
  #commit_email  = "terraform@MYCOMPANY.COM"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      commit_message,
      overwrite_on_create
    ]
  }
}
