variable "vsphere_datacenter" {
  description = "The vSphere datacenter name"
  type        = string
  default     = "forgeops_datacenter"
}

variable "vsphere_cluster" {
  description = "The vSphere cluster name"
  type        = string
  default     = "cluster"
}

variable "vsphere_datastore" {
  description = "The vSphere datastore name"
  type        = string
  default     = "forgeops_datastore"
}

variable "vsphere_network" {
  description = "The vSphere network name"
  type        = string
  default     = "VLAN2"
}

variable "vsphere_insecure" {
  description = "Allow insecure SSL connections to vSphere"
  type        = bool
  default     = false
}

variable "default_vm_template" {
  description = "The name of the VM template to use"
  type        = string
  default = "ubuntu-basic-template-v1.3.1"
}

variable "consul_address" {
  type        = string
  default     = "https://10.100.1.200:443"
}
