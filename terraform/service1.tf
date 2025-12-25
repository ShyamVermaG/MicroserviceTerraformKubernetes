############################
# VARIABLES
############################
variable "service1_image" {
  type        = string
  description = "Docker image for service1"
}

############################
# DEPLOYMENT : service1
############################
resource "kubernetes_deployment" "service1" {
  metadata {
    name = "service1"
    labels = {
      app = "service1"
    }
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "service1"
      }
    }

    template {
      metadata {
        labels = {
          app = "service1"
        }
      }

      spec {
        container {
          name  = "service1"
          image = var.service1_image
          image_pull_policy = "IfNotPresent"

          port {
            container_port = 8080
          }

          env {
            name  = "SERVICE2_URL"
            value = "http://service2.microservices.svc.cluster.local:8081"
          }

          resources {
            requests = {
              memory = "256Mi"
              cpu    = "250m"
            }
            limits = {
              memory = "512Mi"
              cpu    = "500m"
            }
          }

          liveness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 30
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/actuator/health"
              port = 8080
            }
            initial_delay_seconds = 20
            period_seconds        = 5
          }
        }
      }
    }
  }
}

############################
# SERVICE : service1
############################
resource "kubernetes_service" "service1" {
  metadata {
    name = "service1"
  }

  spec {
    selector = {
      app = "service1"
    }

    port {
      port        = 8080
      target_port = 8080
    }

    type = "LoadBalancer"
  }
}
