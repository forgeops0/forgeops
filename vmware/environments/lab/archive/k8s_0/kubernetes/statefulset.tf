resource "kubernetes_stateful_set" "pg_controller" {
  metadata {
    name = "pg-controller"
  }

  spec {
    service_name = "pg-controller"
    replicas     = 1
    selector {
      match_labels = {
        app  = "postgres"
        role = "controller"
      }
    }

    template {
      metadata {
        labels = {
          app  = "postgres"
          role = "controller"
        }
      }
#####################################tolerations - temporarily, until the worker node is not created
      spec {
        # toleration { 
        #   key = "node-role.kubernetes.io/control-plane"
        #   operator = "Exists"
        #   effect = "NoSchedule"
        # }

        container {
          name  = "postgres"
          image = "postgres:16"
          port {
            container_port = 5432
          }

          volume_mount {
            name      = "pg-data"
            mount_path = "/var/lib/postgresql/data"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "pg-secret"
                key  = "postgresql-password"
              }
            }
          }
        }

        volume {
          name = "pg-data"
          persistent_volume_claim {
            claim_name = "pg-controller-pvc"
          }
        }
      }
    }
  }
}

resource "kubernetes_stateful_set" "pg_replica" {
  metadata {
    name = "pg-replica"
  }

  spec {
    service_name = "pg-replica"
    replicas     = 1
    selector {
      match_labels = {
        app  = "postgres"
        role = "replica"
      }
    }

    template {
      metadata {
        labels = {
          app  = "postgres"
          role = "replica"
        }
      }
 #####################################tolerations - temporarily, until the worker node is not created
      spec {
        # toleration {
        #   key = "node-role.kubernetes.io/control-plane"
        #   operator = "Exists"
        #   effect = "NoSchedule"
        # }

        container {
          name  = "postgres"
          image = "postgres:16"
          port {
            container_port = 5432
          }

          volume_mount {
            name      = "pg-data"
            mount_path = "/var/lib/postgresql/data"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value_from {
              secret_key_ref {
                name = "pg-secret"
                key  = "postgresql-password"
              }
            }
          }

          env {
            name  = "REPLICATOR_PASSWORD"
            value_from {
              secret_key_ref {
                name = "pg-secret"
                key  = "replication-password"
              }
            }
          }
        }

        volume {
          name = "pg-data"
          persistent_volume_claim {
            claim_name = "pg-replica-pvc"
          }
        }
      }
    }
  }
}
