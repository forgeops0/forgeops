
variable "vsphere_server" {
  description = "The vSphere server address"
  type        = string
  default     = "lab.datacenter.local"
}

variable "vsphere_datacenter" {
  description = "The vSphere datacenter name"
  type        = string
  default     = "forgeops_datacenter"
}

variable "vsphere_cluster" {
  description = "The vSphere cluster name"
  type        = string
  default     = "Cluster"
}


variable "vsphere_datastore_zoneA1" {
  description = "The vSphere datastore name"
  type        = string
  default     = "forgeops_datastore"
}

variable "vsphere_datastore_zoneA2" {
  description = "The vSphere datastore name"
  type        = string
  default     = "Datastore02"
}

variable "vsphere_datastore_zoneA3" {
  description = "The vSphere datastore name"
  type        = string
  default     = "Datastore03"
}

variable "vsphere_datastore_zoneB1" {
  description = "The vSphere datastore name"
  type        = string
  default     = "esxi01dr-local-datastore"
}

variable "vsphere_datastore_zoneB2" {
  description = "The vSphere datastore name"
  type        = string
  default     = "esxi02dr-local-datastore"
}

variable "vsphere_datastore_zoneB3" {
  description = "The vSphere datastore name"
  type        = string
  default     = "esxi03dr-local-datastore"
}

variable "vsphere_network" {
  description = "The vSphere network name"
  type        = string
  default     = "VLAN1"
}

variable "vsphere_insecure" {
  description = "Allow insecure SSL connections to vSphere"
  type        = bool
  default     = false
}

variable "default_vm_template" {
  description = "The name of the VM template to use"
  type        = string
  default     = "ubuntu-basic-template-v1.3"
}
