output "artifact_registry_repository_name" {
  value = module.artifact_registry.repository_id
}

output "artifact_registry_repository_url" {
  value = "${var.region}-docker.pkg.dev/${var.project_id}/${module.artifact_registry.repository_id}"
}

output "gke_cluster_name" {
  value = module.gke.cluster_name
}

output "gke_cluster_location" {
  value = module.gke.cluster_location
}

output "gke_endpoint" {
  value = module.gke.endpoint
}

output "vpc_name" {
  value = module.network.vpc_name
}

output "subnet_name" {
  value = module.network.subnet_name
}