terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.5.0"
    }
  }
}

data "google_compute_network" "default" {
  name    = "default"
  project = "toof-gke-playground"
}

resource "google_compute_subnetwork" "default" {
  name          = "default"
  project       = "toof-gke-playground"
  ip_cidr_range = "10.138.0.0/20"
  network       = data.google_compute_network.default.self_link
  region        = "us-west1"
  secondary_ip_range {
    range_name    = "gke-my-cluster-pods-1fddcd38"
    ip_cidr_range = "10.52.0.0/17"
  }
  secondary_ip_range {
    range_name    = "pods-range-2"
    ip_cidr_range = "10.40.0.0/16"
  }
}

resource "google_container_cluster" "primary" {
  name               = "my-cluster"
  project            = "toof-gke-playground"
  location           = "us-west1"
  enable_autopilot   = true
  network            = data.google_compute_network.default.self_link
  subnetwork         = google_compute_subnetwork.default.self_link
  deletion_protection = false

  ip_allocation_policy {
    cluster_secondary_range_name = "gke-my-cluster-pods-1fddcd38"
    additional_pod_ranges_config {
      pod_range_names = ["pods-range-2"]
    }
  }
}
