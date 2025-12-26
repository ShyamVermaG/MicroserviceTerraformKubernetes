variable "project_id" {}
variable "region" {
  default = "asia-south1"
}
variable "zone" {
  default = "asia-south1-a"
}
variable "kube_host" {
  type        = string
  description = "Kubernetes API server endpoint"
}

variable "kube_token" {
  type        = string
  description = "Service account token"
  sensitive   = true
}

variable "kube_ca" {
  type        = string
  description = "Base64 encoded cluster CA cert"
}
