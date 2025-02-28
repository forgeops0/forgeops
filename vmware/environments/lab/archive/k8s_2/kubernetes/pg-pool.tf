provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "pgpooldemo" {
  metadata {
    name = "pgpooldemo"
  }
}

resource "kubernetes_manifest" "pgpool" {
  manifest = {
    apiVersion = "kubedb.com/v1alpha2"
    kind       = "Pgpool"
    metadata = {
      name      = "pgpool"
      namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
    }
    spec = {
      version         = "4.5.0"
      replicas        = 1
      postgresRef     = {
        name      = kubernetes_manifest.citus_postgresql.metadata[0].name
        namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
      }
      syncUsers       = true
      terminationPolicy = "WipeOut"
    }
  }
}


resource "kubernetes_config_map" "pgpool_config" {
  metadata {
    name      = "pgpool-config"
    namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
  }

  data = {
    pgpool.conf   = <<EOF
backend_hostname0='10.0.2.180'
backend_hostname1='10.0.2.180'
backend_port0='5432'
backend_port1='5432'
load_balance_mode='on'
connection_cache='on'
EOF
  }
}