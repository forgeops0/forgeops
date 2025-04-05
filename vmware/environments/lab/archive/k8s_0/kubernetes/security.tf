resource "kubernetes_secret" "pg_secret" {
  metadata {
    name = "pg-secret"
  }
  data = {
    "postgresql-password"  = base64encode("admin123") #for test
    "replication-password" = base64encode("admin123")
  }
}
