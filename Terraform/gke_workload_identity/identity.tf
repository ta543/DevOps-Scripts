# Creates a GCP IAM service account of the same name as the Kubernetes service account
#
# then adds the Workload Identity format service account as a member of the GCP service account, permitting the Kubernetes service account to use it implicitly
#
# You can then assign any normal GCP IAM permissions to other services to let Kubernetes pods using this k8s_service_account to acces them

locals {
  workload_identity_service_account = "serviceAccount:${var.project}.svc.id.goog[${var.k8s_namespace}/${var.k8s_service_account}]"
}

resource "google_service_account" "main" {
  account_id   = var.k8s_service_account
  display_name = var.display_name
  project      = var.project
  description  = var.description
}

resource "google_service_account_iam_member" "main" {
  service_account_id = google_service_account.main.id
  role               = "roles/iam.workloadIdentityUser"
  member             = local.workload_identity_service_account
}
