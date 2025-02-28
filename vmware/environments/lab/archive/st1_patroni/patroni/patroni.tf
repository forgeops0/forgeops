# Namespace dla patroni-etcd
resource "kubernetes_namespace" "patroni_etcd" {
  metadata {
    name = "patroni-etcd"
  }
}

# Namespace dla patroni
resource "kubernetes_namespace" "patroni" {
  metadata {
    name = "patroni"
  }
}

# PersistentVolume dla etcd-data
resource "kubernetes_persistent_volume" "etcd_data" {
  count = 3
  metadata {
    name = "etcd-data-${count.index}"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"
    
    persistent_volume_source {
      host_path {
        path = "/mnt/disks/etcd-data-${count.index}"
      }
    }
  }
}

# PersistentVolumeClaim dla etcd-data
resource "kubernetes_persistent_volume_claim" "etcd_data" {
  count = 3
  metadata {
    name      = "etcd-data-${count.index}"

  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

# StatefulSet dla etcd (patroni_etcd)
resource "kubernetes_stateful_set" "patroni_etcd" {
  metadata {
    name      = "patroni-etcd"

    labels = {
      app = "patroni-etcd"
    }
  }

  spec {
    service_name = "patroni-etcd"
    replicas     = 3

    selector {
      match_labels = {
        app = "patroni-etcd"
      }
    }

    update_strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "patroni-etcd"
        }
      }

      spec {
        container {
          name  = "etcd"
          image = "quay.io/coreos/etcd:v3.5.0"

          env {
            name  = "ETCD_LISTEN_CLIENT_URLS"
            value = "http://0.0.0.0:2379"
          }

          env {
            name  = "ETCD_ADVERTISE_CLIENT_URLS"
            value = "http://$(hostname).patroni-etcd.default.svc.cluster.local:2379"
          }

          port {
            container_port = 2379
          }

          volume_mount {
            name       = "etcd-data"
            mount_path = "/home/ubuntu/postgres"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "etcd-data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}

# PersistentVolume dla pgdata
resource "kubernetes_persistent_volume" "pgdata" {
  count = 3
  metadata {
    name = "pgdata-${count.index}"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "/home/ubuntu/pgdata-${count.index}"
      }
    }
  }
}

# PersistentVolumeClaim dla pgdata
resource "kubernetes_persistent_volume_claim" "pgdata" {
  count = 3
  metadata {
    name      = "pgdata-${count.index}"
    
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}

# StatefulSet dla patroni
resource "kubernetes_stateful_set" "patroni" {
  metadata {
    name      = "patroni"
    
    labels = {
      app = "patroni"
    }
  }

  spec {
    service_name = "patroni"
    replicas     = 3

    selector {
      match_labels = {
        app = "patroni"
      }
    }

    update_strategy {
      type = "RollingUpdate"
    }

    template {
      metadata {
        labels = {
          app = "patroni"
        }
      }

      spec {
        container {
          name  = "patroni"
          image = "patroni:latest"

          env {
            name  = "PATRONI_KUBERNETES_USE_ENDPOINTS"
            value = "true"
          }

          env {
            name  = "PATRONI_ETCD_HOSTS"
            value = "etcd:2379"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "pgdata"
            mount_path = "/home/ubuntu/postgres"
          }
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "pgdata"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "1Gi"
          }
        }
      }
    }
  }
}
