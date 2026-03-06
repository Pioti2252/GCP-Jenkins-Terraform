output "vpc_name" {
  value = google_compute_network.vpc.name
}

output "subnet_name" {
  value = google_compute_subnetwork.subnet.name
}

output "pods_range_name" {
  value = "gke-pods-range"
}

output "services_range_name" {
  value = "gke-services-range"
}

output "artifact_registry_repository_name" {
  value = google_artifact_registry_repository.docker_repo.repository_id
}

output "artifact_registry_repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.docker_repo.repository_id}"
}