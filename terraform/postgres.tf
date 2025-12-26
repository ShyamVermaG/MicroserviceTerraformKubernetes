resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  wait_for_rollout = false

  metadata {
    name      = "postgres-pvc"
    namespace = kubernetes_namespace.microservices.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]

    resources {
      requests = {
        storage = "1Gi"
      }
    }

    storage_class_name = "standard-rwo"
  }
    wait_until_bound = false

}

resource "kubernetes_deployment" "postgres" {
  depends_on = [kubernetes_persistent_volume_claim.postgres_pvc]

  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.microservices.metadata[0].name
    labels = {
      app = "postgres"
    }
  }
  lifecycle {
    prevent_destroy = true
  }


  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:15"

          env {
            name  = "POSTGRES_DB"
            value = "mydb"
          }

          env {
            name  = "POSTGRES_USER"
            value = "admin"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "admin123"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "pgdata"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "pgdata"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.microservices.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
    }

    type = "ClusterIP"
  }
}
