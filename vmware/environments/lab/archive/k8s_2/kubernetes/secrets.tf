resource "kubernetes_secret" "postgres_secret" {
  metadata {
    name      = "mypostgres-secret"
    namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
  }

  data = {
    username = base64encode("your_username")
    password = base64encode("your_password")
  }
}

resource "kubernetes_secret" "pgpool_secret" {
  metadata {
    name      = "pgpool-pcp-secret"
    namespace = kubernetes_namespace.pgpooldemo.metadata[0].name
  }

  data = {
    username = base64encode("pgpool_user")
    password = base64encode("pgpool_password")
  }
}