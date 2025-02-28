data "vsphere_datacenter" "dc" {
  name = "forgeops_datacenter"
}

data "vsphere_datastore" "datastore" {
  name          = "forgeops_datastore"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Cluster"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "VLAN1"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "controller_template" {
  name          = var.controller_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "worker_template" {
  name          = var.worker_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

