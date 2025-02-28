
# # Create namespace
# resource "kubernetes_namespace" "pgpooldemo" {
#   metadata {
#     name = "pgpooldemo"
#   }
# }

# Create ConfigMap for Pgpool configuration
resource "kubernetes_config_map" "pgpool_config" {
  metadata {
    name      = "pgpool-config"
    namespace = "default"
  }

  data = {
    "pgpool.conf" = <<EOF
backend_hostname0 = '10.0.2.190'
backend_hostname1 = '10.0.2.191'
backend_port0 = '5432'
backend_port1 = '5432'
load_balance_mode = 'on'
connection_cache = 'on'
EOF
  }
}

# Pgpool Deployment
resource "kubernetes_deployment" "pgpool" {
  metadata {
    name      = "pgpool"
    namespace = "default"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "pgpool"
      }
    }

    template {
      metadata {
        labels = {
          app = "pgpool"
        }
      }

      spec {
        container {
          name  = "pgpool"
          image = "bitnami/pgpool:4.5.0"

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "pgpool-config-volume"
            mount_path = "/opt/bitnami/pgpool/conf"
            sub_path   = "pgpool.conf"
          }
        }

        volume {
          name = "pgpool-config-volume"

          config_map {
            name = kubernetes_config_map.pgpool_config.metadata[0].name
          }
        }
      }
    }
  }
}

# Pgpool Service
resource "kubernetes_service" "pgpool" {
  metadata {
    name      = "pgpool"
    namespace = "default"
  }

  spec {
    selector = {
      app = "pgpool"
    }

    port {
      port        = 5432
      target_port = 5432
    }
  }
}
