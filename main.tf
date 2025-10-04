terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.5.0"
    }
  }
}

resource "google_container_cluster" "primary" {
  name             = "my-cluster"
  project          = "toof-gke-playground"
  location         = "us-west1"
  enable_autopilot = true
}
