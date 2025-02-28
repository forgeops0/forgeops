#controller
resource "kubernetes_persistent_volume" "pg_controller_pv" {
  metadata {
    name = "pg-controller-pv"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "/tmp/pg-controller"
      }
    }
  }
}

## Persistent Volume Claim dla controller:

resource "kubernetes_persistent_volume_claim" "pg_controller_pvc" {
  metadata {
    name = "pg-controller-pvc"
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

#Replica
resource "kubernetes_persistent_volume" "pg_replica_pv" {
  metadata {
    name = "pg-replica-pv"
  }

  spec {
    capacity = {
      storage = "1Gi"
    }
    access_modes = ["ReadWriteOnce"]
    persistent_volume_reclaim_policy = "Retain"

    persistent_volume_source {
      host_path {
        path = "/tmp/pg-replica"
      }
    }
  }
}

## Persistent Volume Claim dla Replica:

resource "kubernetes_persistent_volume_claim" "pg_replica_pvc" {
  metadata {
    name = "pg-replica-pvc"
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
