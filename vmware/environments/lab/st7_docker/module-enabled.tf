module "standard_instances" {
  source       = "../../modules/vm_standard"
  vm_list      = var.vm_standard_list
  vm_settings  = local.vm_settings
}


######

module "instances_with_docker" {
  source         = "../../modules/vm_docker"
  vm_docker_list = var.vm_docker_list
  vm_settings    = local.vm_settings
  ssh_user       = var.ssh_user
  ssh_private_key = local.ssh_privkey
}


variable "ssh_user" {
  description = "SSH user to connect to the VM"
  type        = string
  default     = "ubuntu"
}
