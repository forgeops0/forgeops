terraform {
  required_version = ">= 1.0.0"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
    ansible = {
      source  = "nbering/ansible"
      version = ">= 1.0.0"
    }
  }



  backend "consul" {
    address = "http://10.100.1.200:8500" #var.consul_address
    path    = "terraform/nonprod"
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
  vsphere_server       = "vsphere.lab.forgeops.eu" #var.vsphere_server
  user                 = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_username"]
  password             = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_password"]
  allow_unverified_ssl = true 
}



##data
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}

###next output
data "vsphere_virtual_machine" "default_vm_template" {
  name          = var.default_vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.dc.id
}
