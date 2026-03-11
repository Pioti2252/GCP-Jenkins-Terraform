resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-sa"
  display_name = "Terraform Service Account"
}

resource "google_service_account" "jenkins_gsa" {
  account_id   = "jenkins-gsa"
  display_name = "Jenkins Google Service Account"
}

locals {
  terraform_roles = [
    "roles/container.admin",
    "roles/compute.admin",
    "roles/artifactregistry.admin",
    "roles/iam.serviceAccountAdmin",
    "roles/resourcemanager.projectIamAdmin"
  ]

  jenkins_roles = [
    "roles/artifactregistry.writer"
  ]
}

resource "google_project_iam_member" "terraform_sa_roles" {
  for_each = toset(local.terraform_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.terraform_sa.email}"
}

resource "google_project_iam_member" "jenkins_gsa_roles" {
  for_each = toset(local.jenkins_roles)
  project  = var.project_id
  role     = each.value
  member   = "serviceAccount:${google_service_account.jenkins_gsa.email}"
}

resource "google_service_account_iam_member" "wi_binding" {
  service_account_id = google_service_account.jenkins_gsa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${var.project_id}.svc.id.goog[jenkins/jenkins]"
}