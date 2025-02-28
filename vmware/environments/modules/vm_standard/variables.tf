variable "vm_list"       { 
    type = list(any) 
}

variable "vsphere_guest_id" {
  type    = string
  default = ""
}

variable "vsphere_datastore_id" {
  type    = string
  default = ""
}

variable "vsphere_resource_pool_id" {
  type    = string
  default = ""
}

variable "vsphere_network_id" {
  type    = string
  default = ""
}

variable "disk_eagerly_scrub" {
  type    = bool
  default = false
}

variable "disk_thin_provisioned" {
  type    = bool
  default = true
}

variable "default_vm_template_uuid" {
  type    = string
  default = ""
}

variable "ipv4_netmask"{
    type    = string
    default = ""
}

variable "ipv4_gateway"{
    type    = string
    default = ""
}

variable "dns_server_list1"{
    
    type    = string
    default = ""

}

variable "dns_server_list2"{      
    type    = string
    default = ""
}

variable "vm_settings" {
  description = "Configuration settings for VM instances"
  type        = map(string)
}
