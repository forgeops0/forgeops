locals {
  vm_cpus                   = 2
  vm_memory                 = 4096
  vm_firmware               = "bios"
  vm_efi_secure_boot_enabled = false
  vm_disk_size              = 50
  host_name                 = "linux"
  vm_domain                 = "linux.local"
  vm_standard                 = { for vm in var.vm_list : "${vm.instance_name}" => vm }
}