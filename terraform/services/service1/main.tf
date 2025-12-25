resource "kubernetes_deployment" "auth" {
  metadata {
    name      = "service1"
    namespace = kubernetes_namespace.microservices.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "service1"
      }
    }
    
    
    port {
      port        = 80
      target_port = 8080
    }

    type = "LoadBalancer"


    template {
      metadata {
        labels = {
          app = "service1"
        }
      }

      spec {
        container {
          name  = "service1"
          image = "asia-south1-docker.pkg.dev/PROJECT/repo/service1:latest"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVICE_NAME"
            value = "service1"
          }
        }
      }
    }
  }
}
