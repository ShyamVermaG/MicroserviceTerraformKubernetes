resource "kubernetes_deployment" "auth" {
  metadata {
    name      = "service2"
    namespace = kubernetes_namespace.microservices.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "service2"
      }
    }

    template {
      metadata {
        labels = {
          app = "service2"
        }
      }

      spec {
        container {
          name  = "service2"
          image = "asia-south1-docker.pkg.dev/PROJECT/repo/service2:latest"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVICE_NAME"
            value = "service2"
          }
        }
      }
    }
  }
}
