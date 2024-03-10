resource "aws_iam_policy" "test" {
  name        = "test"
  path        = "/"
  description = "My description here"

  # jsonencode converts Terraform code to JSON which AWS IAM needs - alternatively just copy a literal JSON policy, but the Terraform version is handy if you need to reference something dynamically like an arn
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# =======
# GCP IAM
#
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_iam

resource "google_project_iam_member" "project-editors" {

  # to find the role id which doesn't quite correspond to the human names in GCP Console UI, run this:
  #
  #   gcloud projects get-iam-policy <myproject>
  #
  role = "roles/editor"

  # XXX: edit this - don't put individuals users in here please, it's hard to maintain
  member = "group:admins@mydomain.com"
}

resource "google_project_iam_member" "cloudsql-viewer" {
  role = "roles/cloudsql.viewer"
  # XXX: edit this
  member = "serviceAccount:cloud-function-sql-backup@<MYPROJECT>.iam.gserviceaccount.com"
}

resource "google_project_iam_member" "cloudsql-client" {
  role = "roles/cloudsql.client"
  # XXX: edit this
  member = "serviceAccount:cloud-function-sql-backup@<MYPROJECT>.iam.gserviceaccount.com"
}
