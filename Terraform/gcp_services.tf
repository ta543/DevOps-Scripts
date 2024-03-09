
# example of automating the Cloud Functions backup with Terraform
#
# https://medium.com/better-programming/how-to-automate-google-cloud-sql-backups-2de6d3cc7d01

locals {
  # GCP enable these services
  services_to_enable = [
    "cloudscheduler.googleapis.com",
    "sqladmin.googleapis.com",
    "cloudfunctions.googleapis.com"
  ]
}

resource "google_project_service" "service" {
  for_each = toset(local.services_to_enable)
  project  = var.project_id
  service  = each.value
}
