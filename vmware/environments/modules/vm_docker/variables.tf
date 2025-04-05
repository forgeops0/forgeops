variable "vm_docker_list" {
  description = "List of VMs to create"
  type        = list(map(string))
}

variable "vm_settings" {
  description = "Settings for the VM instances"
  type        = map(string)
}

variable "ssh_user" {
  description = "SSH user to connect to the VM"
  type        = string
}

variable "ssh_private_key" {
  description = "Path to the SSH private key for connection"
  type        = string
}
