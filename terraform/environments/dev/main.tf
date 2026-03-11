terraform {
  required_version = ">= 1.5.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

module "network" {
  source = "../../modules/network"

  project_id          = var.project_id
  region              = var.region
  vpc_name            = "jenkins-vpc"
  subnet_name         = "jenkins-subnet"
  subnet_cidr         = "10.10.0.0/24"
  pods_range_name     = "gke-pods-range"
  pods_range_cidr     = "10.20.0.0/16"
  services_range_name = "gke-services-range"
  services_range_cidr = "10.30.0.0/20"
}

module "iam" {
  source = "../../modules/iam"

  project_id = var.project_id
}

module "artifact_registry" {
  source = "../../modules/artifact_registry"

  region        = var.region
  repository_id = var.artifact_registry_repo_name
}

module "gke" {
  source = "../../modules/gke"

  project_id           = var.project_id
  region               = var.region
  cluster_name         = var.cluster_name
  gke_node_count       = var.gke_node_count
  gke_machine_type     = var.gke_machine_type
  gke_disk_size_gb     = var.gke_disk_size_gb
  network_id           = module.network.vpc_id
  subnetwork_id        = module.network.subnet_id
  pods_range_name      = module.network.pods_range_name
  services_range_name  = module.network.services_range_name
  node_service_account = module.iam.terraform_sa_email
}