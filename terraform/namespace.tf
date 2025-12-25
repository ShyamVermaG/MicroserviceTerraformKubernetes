resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices"
  }
}
resource "kubernetes_namespace_v1" "microservices" {
  metadata {
    name = "microservices"
  }
}
