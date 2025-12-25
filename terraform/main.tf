provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_container_cluster" "gke" {
  name     = "microservices-gke"
  location = var.region

  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "nodes" {
  cluster = google_container_cluster.gke.name
  location = var.region

  node_config {
    machine_type = "e2-medium"
  }

  node_count = 3
}
