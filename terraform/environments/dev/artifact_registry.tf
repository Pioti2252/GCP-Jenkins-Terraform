resource "google_artifact_registry_repository" "docker_repo" {
  location      = var.region
  repository_id = var.artifact_registry_repo_name
  description   = "Docker repository for Jenkins and app images"
  format        = "DOCKER"
}