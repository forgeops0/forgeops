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

