

############################
# DEPLOYMENT : service2
############################
resource "kubernetes_deployment" "service2" {
  metadata {
    name      = "service2"
    namespace = "microservices"
    labels = {
      app = "service2"
    }
  }

  spec {
    replicas = 1

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
          image = var.service2_image
          image_pull_policy = "Always"

          port {
            container_port = 8081
          }

          env {
            name  = "DB_HOST"
            value = "postgres"
          }
          env {
            name  = "DB_PORT"
            value = "5432"
          }
          env {
            name  = "DB_NAME"
            value = "testdb"
          }
          env {
            name  = "DB_USER"
            value = "postgres"
          }
          env {
            name  = "DB_PASSWORD"
            value = "postgres"
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

          startup_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = 8081
            }
            failure_threshold = 30
            period_seconds    = 5
          }

          liveness_probe {
            http_get {
              path = "/actuator/health/liveness"
              port = 8081
            }
            initial_delay_seconds = 40
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/actuator/health/readiness"
              port = 8081
            }
            initial_delay_seconds = 30
            period_seconds        = 5
          }
        }
      }
    }
  }
}

############################
# SERVICE : service2
############################
resource "kubernetes_service" "service2" {
  metadata {
    name      = "service2"
    namespace = "microservices"
  }

  spec {
    selector = {
      app = "service2"
    }

    port {
      port        = 8081
      target_port = 8081
    }

    type = "ClusterIP"
  }
}
