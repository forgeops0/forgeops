#Secrets/forgeops/credentials
data "vault_kv_secret_v2" "forgeops_credentials" {
  mount = "forgeops"
  name  = "forgeops_secrets"
}

# Create kubernetes secret
resource "kubernetes_secret" "superuser_secret" {
  metadata {
    name      = "superuser-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["superuser-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["superuser-password"]
  }

  type = "Opaque"
}

# Create kubernetes secret
resource "kubernetes_secret" "admin_secret" {
  metadata {
    name      = "admin-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["admin-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["admin-password"]
  }

  type = "Opaque"
}

# Create kubernetes secret
resource "kubernetes_secret" "backup_secret" {
  metadata {
    name      = "backup-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["backup-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["backup-password"]
  }

  type = "Opaque"
}

# Create kubernetes secret
resource "kubernetes_secret" "readonly_secret" {
  metadata {
    name      = "readonly-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["readonly-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["readonly-password"]
  }

  type = "Opaque"
}

# Create kubernetes secret
resource "kubernetes_secret" "replication_secret" {
  metadata {
    name      = "replication-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["replication-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["replication-password"]
  }

  type = "Opaque"
}

# Create kubernetes secret
resource "kubernetes_secret" "standby_secret" {
  metadata {
    name      = "standby-secret"
    namespace = "default"
  }

  data = {
    username = data.vault_kv_secret_v2.forgeops_credentials.data["standby-username"]
    password = data.vault_kv_secret_v2.forgeops_credentials.data["standby-password"]
  }

  type = "Opaque"
}
