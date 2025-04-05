terraform {
  required_version = "1.3.9"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }
}

provider "vsphere" {
  vsphere_server = var.vsphere_server

  user           = var.vsphere_user
  password       = var.vsphere_password
  allow_unverified_ssl = true
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}



provider "vault" {
  address = "http://10.0.1.150:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "ab0e5ac4-e521-2074-35c4-a47c2890395f"
      secret_id = "x"
    }
  }
}

# Downloading Secrets from HashiCorp Vault
data "vault_kv_secret_v2" "forgeops_credentials" {
  mount = "forgeops"
  name  = "credentials"
}
