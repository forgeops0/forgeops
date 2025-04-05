provider "kubernetes" {
  host        = "https://10.0.2.190:6443"
  config_path = "~/.kube/config"
  #version = "~> 2.30"
}

terraform {
  required_version = "1.3.9"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.0"
    }
  }

  backend "consul" {
    address = "http://10.0.2.150:8500"   
    path    = "terraform/lab/st5/forgeops/everest"
    scheme  = "http"  ####tmp for lab
  }
}

provider "vault" {
  address = "https://10.0.2.150:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
       role_id = "6495d099-4ae0-708a-d568-c0647af778fe"
       secret_id = var.secret_id
    }
  }
   skip_tls_verify = var.vault_skip_verify ####tmp for lab
}