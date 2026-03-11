resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  network    = var.network_id
  subnetwork = var.subnetwork_id

  deletion_protection = false

  remove_default_node_pool = true
  initial_node_count       = 1

  networking_mode = "VPC_NATIVE"

  ip_allocation_policy {
    cluster_secondary_range_name  = var.pods_range_name
    services_secondary_range_name = var.services_range_name
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  release_channel {
    channel = "REGULAR"
  }

  node_config {
    machine_type = var.gke_machine_type
    disk_size_gb = var.gke_disk_size_gb
    disk_type    = "pd-standard"

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name     = "general-node-pool"
  location = var.region
  cluster  = google_container_cluster.primary.name

  node_count = var.gke_node_count

  node_config {
    machine_type    = var.gke_machine_type
    disk_size_gb    = var.gke_disk_size_gb
    disk_type       = "pd-standard"
    service_account = var.node_service_account

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    labels = {
      env = "dev"
    }

    tags = ["gke-node", "jenkins"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }
}