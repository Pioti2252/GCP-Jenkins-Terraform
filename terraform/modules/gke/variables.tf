variable "project_id" {
  type = string
}

variable "region" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "gke_node_count" {
  type = number
}

variable "gke_machine_type" {
  type = string
}

variable "gke_disk_size_gb" {
  type = number
}

variable "network_id" {
  type = string
}

variable "subnetwork_id" {
  type = string
}

variable "pods_range_name" {
  type = string
}

variable "services_range_name" {
  type = string
}

variable "node_service_account" {
  type = string
}