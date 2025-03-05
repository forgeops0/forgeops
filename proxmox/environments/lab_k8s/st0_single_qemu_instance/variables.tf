# SSH public key variable
variable "ssh_key" {
  description = "SSH public key for VM"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVe7UyeUcoyIgzVtxtXHWm1buenJRwBCYQXLCHY6ULN forgeops@spaceops.pl"
}

variable "pm_vm_name" {
  description = "name for VM"
  type        = string
}

variable "pm_vm_target_node" {
  description = "node where the instance is placed"
  type        = string
}

variable "pm_vm_template" {
  description = "template for VM"
  type        = string
}

variable "pm_vm_enable_qemu_agent" {
  description = "Enable QEMU agent (true/false will be converted to 0 or 1)"
  type        = bool
}

variable "pm_vm_cores" {
  description = "Number of CPU cores for the VM"
  type        = number
  default     = 2
}

variable "pm_vm_sockets" {
  description = "Number of CPU sockets for the VM"
  type        = number
  default     = 1
}

variable "pm_vm_vcpus" {
  description = "Number of virtual CPUs for the VM"
  type        = number
  default     = 0
}

variable "pm_vm_memory" {
  description = "Amount of memory for the VM in MB"
  type        = number
  default     = 2048
}

variable "pm_vm_scsihw" {
  description = "SCSI controller type for the VM"
  type        = string
  default     = "lsi"
}

variable "pm_vm_disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 32
}

variable "pm_vm_disk_cache" {
  description = "Cache mode for the disk"
  type        = string
  default     = "writeback"
}

variable "pm_vm_disk_storage" {
  description = "Storage location for the disk"
  type        = string
  default     = "local-lvm"
}

variable "pm_vm_disk_iothread" {
  description = "Enable IO thread for the disk"
  type        = bool
  default     = true
}

variable "pm_vm_disk_discard" {
  description = "Enable discard for the disk"
  type        = bool
  default     = true
}

variable "pm_vm_network_model" {
  description = "Network model for the VM"
  type        = string
  default     = "virtio"
}

variable "pm_vm_network_bridge" {
  description = "Network bridge for the VM"
  type        = string
  default     = "vmbr0"
}

variable "pm_vm_network_tag" {
  description = "VLAN tag for the network interface"
  type        = number
  default     = 256
}

variable "pm_vm_ipconfig0" {
  description = "IP configuration for the VM"
  type        = string
  default     = "ip=192.168.88.190/24,gw=192.168.88.1"
}

variable "pm_vm_os_type" {
  description = "OS type for the VM"
  type        = string
  default     = "cloud-init"
}
