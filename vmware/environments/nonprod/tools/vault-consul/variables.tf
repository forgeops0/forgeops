variable "vsphere_user" {
  description = "vSphere user"
  type        = string
}

variable "vsphere_password" {
  description = "vSphere password"
  type        = string
  sensitive   = true
}




variable "vsphere_insecure" {
  type    = bool
  default = false
}

# vSphere Settings

variable "vsphere_datacenter" {
  type = string
}

variable "vsphere_cluster" {
  type = string
}

variable "vsphere_datastore" {
  type = string
}


variable "vsphere_network" {
  type = string
}

variable "vsphere_template" {
  type = string
}

# Virtual Machine Settings

variable "vm_name" {
  type = string
}

variable "vm_cpus" {
  type = number
}

variable "vm_memory" {
  type = number
}

variable "vm_firmware" {
  type = string
}

variable "vm_efi_secure_boot_enabled" {
  type = bool
}

variable "vm_domain" {
  type = string
}

variable "vsphere_server" {
  type = string
}

variable "ipv4_address" {
  type = string
}

variable "ipv4_netmask" {
  type = string
}
      

variable "ipv4_gateway" {
  type = string
} 

variable "dns_server_list1" {
  type = string
}

variable "dns_server_list2" {
  type = string
}

variable "disk_size" {
  type = number
  default = 30
}
