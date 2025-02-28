resource "kubernetes_manifest" "citus_postgresql" {
  manifest = {
    apiVersion = "kubedb.com/v1alpha2"
    kind       = "Postgres"
    metadata = {
      name      = "citus-cluster"
      namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
    }
    spec = {
      replicas     = 3
      version      = "16.1"
      storageType  = "Durable"
      storage = {
        storageClassName = "standard"
        accessModes     = ["ReadWriteOnce"]
        resources = {
          requests = {
            storage = "1Gi"
          }
        }
      }
      terminationPolicy = "WipeOut"
      extensions = ["citus"]
    }
  }
}