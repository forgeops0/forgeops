terraform {
  required_version = "1.3.9"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }

  backend "consul" {
    address = "http://10.0.1.150:8500"   
    path    = "terraform/lab"
    scheme  = "http"  ####tmp for lab
  }
}

provider "vault" {
  address = "https://10.0.1.150:8200"
  skip_child_token = true
  auth_login {
    path = "auth/approle/login"

    parameters = {
       role_id = "6495d099-4ae0-708a-d568-c0647af778fe"
       secret_id = "x"
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
  vsphere_server       = var.vsphere_server
  user                 = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_username"]
  password             = data.vault_kv_secret_v2.vsphere_credentials.data["vsphere_password"]
  allow_unverified_ssl = true 
}



##data
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "vsphere_datastore_zoneA1" {
  name          = var.vsphere_datastore_zoneA1
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "vsphere_datastore_zoneA2" {
  name          = var.vsphere_datastore_zoneA2
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_datastore" "vsphere_datastore_zoneA3" {
  name          = var.vsphere_datastore_zoneA3
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_datastore" "vsphere_datastore_zoneB1" {
  name          = var.vsphere_datastore_zoneB1
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_datastore" "vsphere_datastore_zoneB2" {
  name          = var.vsphere_datastore_zoneB2
  datacenter_id = data.vsphere_datacenter.dc.id
}


data "vsphere_datastore" "vsphere_datastore_zoneB3" {
  name          = var.vsphere_datastore_zoneB3
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
