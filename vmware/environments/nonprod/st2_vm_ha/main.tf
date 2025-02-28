terraform {
  required_version = "1.10.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }

  backend "consul" {
    address = "http://10.0.1.150:8500"   
    path    = "terraform/nonprod/st2_vm_ha"
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
       secret_id = "xxx"
    }
  }
   skip_tls_verify = true #var.vault_skip_verify ####tmp for lab
}



#Secrets/forgeops/credentials
data "vault_kv_secret_v2" "vsphere_credentials" {
  mount = "vsphere"
  name  = "vsphere_secrets"
}

provider "vsphere" {   
  vsphere_server       = data.terraform_remote_state.lab.outputs.vm_settings.vsphere_server
  user                 = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_username"]
  password             = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_password"]
  allow_unverified_ssl = true 
}



###connect to lab env

data "terraform_remote_state" "nonprod" {
  backend = "consul"
  config = {
    address = "http://xxxxxxx:8500"
    path    = "terraform/nonprod"
    scheme  = "http"
  }
}


data "vsphere_datacenter" "dc" {
  name = "forgeops_datacenter"
}