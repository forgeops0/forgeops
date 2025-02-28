resource "kubernetes_service" "pg_controller" {
  metadata {
    name = "pg-controller"
  }

  spec {
    type = "NodePort"
    #external_ips = ["10.0.2.190"] 
    port {
      port        = 5432
      target_port = 5432
      node_port   = 32000
    }
    selector = {
      app  = "postgres"
      role = "controller"
    }
  }
}


resource "kubernetes_service" "pg_replica" {
  metadata {
    name = "pg-replica"
  }

  spec {
    #nodeName = "lab-forgeops-worker-1"
    type = "NodePort"
    #external_ips = ["10.0.2.191"] 
    port {
      port        = 5432
      target_port = 5432
      node_port   = 32001
    }
    selector = {
      app  = "postgres"
      role = "replica"
    }
  }
}
