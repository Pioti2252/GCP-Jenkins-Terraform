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