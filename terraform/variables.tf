variable "project_id" {}
variable "region" {
  default = "asia-south1"
}
variable "zone" {
  default = "asia-south1-a"
}
variable "kube_host" {
  type = string
}

variable "kube_token" {
  type = string
}

variable "kube_ca" {
  type = string
}

variable "service1_image" {
  type = string
}

variable "service2_image" {
  type = string
}
