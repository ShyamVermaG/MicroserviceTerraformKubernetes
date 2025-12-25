resource "kubernetes_namespace" "microservices" {
  metadata {
    name = "microservices"
  }
}
