provider "google" {
    credentials = "${file("../account.json")}"
    project     = "${var.project_id}"
    region      = "${var.region}"
}

resource "google_container_cluster" "gcp_kubernetes" {
    name               = "${var.cluster_name}"
    zone               = "${var.zone}"
    initial_node_count = "${var.gcp_cluster_count}"
    
    master_auth {
        username = "${var.cluster_username}"
        password = "${var.cluster_password}}"
    }
    node_config {
        oauth_scopes = [
          "https://www.googleapis.com/auth/compute",
          "https://www.googleapis.com/auth/devstorage.read_only",
          "https://www.googleapis.com/auth/logging.write",
          "https://www.googleapis.com/auth/monitoring",
        ]
        labels {
            product = "${var.cluster_name}"
        }
        tags = ["test-db-loadbalance"]
    }
}