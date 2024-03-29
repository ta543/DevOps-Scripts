
# name is just for reference purposes, the org will be set in github{} in provider.tf
resource "github_actions_organization_permissions" "MYORG" {
  allowed_actions      = "selected"
  enabled_repositories = "all" # if "selected" then specify list of allowed repos below
  allowed_actions_config {
    github_owned_allowed = true
    verified_allowed     = true
    patterns_allowed = [
      "aquasecurity/trivy-action@*",
      "dawidd6/action-download-artifact@c776311571668da4ded92c1376aa799424360b2d",
      "peaceiris/actions-gh-pages@068dc23d9710f1ba62e86896f84735d869951305",
      "returntocorp/semgrep-action@v1",
      "simple-elf/allure-report-action@4cf605e31141e43479bff86bc4e3a5b642bedaa3",
      "snok/install-poetry@b618b9a0f1ac514ac332510e913d89907016d7b0",
    ]
  }
  #enabled_repositories_config {
  #  repository_ids = [github_repository.example.repo_id]
  #}
  lifecycle {
    # XXX: doesn't prevent destroy when the entire resource code block is removed!
    prevent_destroy = true
  }
  # may want to add to this on a per repo basis and not have it standardized
}
