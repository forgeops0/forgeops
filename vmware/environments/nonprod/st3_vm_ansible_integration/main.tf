# ###connect to parent stack

data "terraform_remote_state" "nonprod" {
  backend = "consul"
  config = {
    address = "http://10.100.1.200:8500"
    path    = "terraform/nonprod"
    scheme  = "http"
  }
}

terraform {
  required_version = "1.10.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }

  backend "consul" {
    address = "http://10.100.1.200:8500" #var.consul_address
    path    = "terraform/nonprod/st3_vm_ansible_integration"
    scheme  = "http"  ####tmp for lab
  }
}

provider "vault" {
  address = "https://10.100.1.200:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
       role_id = "71a5275d-6307-48e0-4c40-462b25f0cca3"
       secret_id = var.vault_secret_id
    }
  }
   skip_tls_verify = true #var.vault_skip_verify ####tmp for lab
}

variable "vault_secret_id" {
  description = "secret id"
  type        = string
}

#Secrets/vspehre/vsphere_secrets
data "vault_kv_secret_v2" "vsphere_credentials" {
  mount = "vsphere"
  name  = "vsphere_secrets"
}

provider "vsphere" {
  vsphere_server       = "vsphere.lab.forgeops.eu"
  user                 = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_username"]
  password             = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_password"]
  allow_unverified_ssl = true 
}