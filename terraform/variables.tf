variable "project_id" {
  type = "string"
  default = "andela-learning"
}

variable "region" {
  type = "string"
  default = "europe-west1"
}
variable "zone" {
  type = "string"
  default = "europe-west1-b"
}

variable "cluster_username" {
    type        = "string"
    description = "User name for authentication to the Kubernetes cluster."
}
variable "cluster_password" {
    type ="string"
    description = "The password for the cluster."
}
// GCP Variables
variable "gcp_cluster_count" {
    type = "string"
    description = "Count of cluster instances to start."
}
variable "cluster_name" {
    type = "string"
    description = "Cluster name for the GCP Cluster."
}
// GCP Outputs
output "gcp_cluster_endpoint" {
    value = "${google_container_cluster.gcp_kubernetes.endpoint}"
}
output "gcp_ssh_command" {
    value = "ssh ${var.cluster_username}@${google_container_cluster.gcp_kubernetes.endpoint}"
}
output "gcp_cluster_name" {
    value = "${google_container_cluster.gcp_kubernetes.name}"
}