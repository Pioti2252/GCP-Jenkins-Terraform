output "terraform_sa_email" {
  value = google_service_account.terraform_sa.email
}

output "jenkins_gsa_email" {
  value = google_service_account.jenkins_gsa.email
}