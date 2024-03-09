
# Manage files in one or more GitHub repos, such as CodeOwners, .gitignore, or GitHub Actions workflows

# https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_file#commit_email

resource "github_repository_file" "MYFILE" {
  repository = github_repository.foo.name
  branch     = "main" # or "master"
  file       = ".gitignore"
  #content        = "**/*.tfstate"
  # ensure there is a newline at end of file via EOT style so people with IDEs or pre-commit hooks aren't changing the file during PRs
  content = <<EOF
# Managed by Terraform - DO NOT EDIT
PUT YOUR CONTENT HERE IN TERRAFORM
EOF
  # requires both or neither - uses the account owning the github token as the author if omitted
  #commit_author = "Terraform"
  #commit_email  = "terraform@MYCOMPANY.COM"
  #commit_message = "Managed by Terraform"
  overwrite_on_create = false

  lifecycle {
    ignore_changes = [
      commit_message,
      overwrite_on_create
    ]
  }
}
