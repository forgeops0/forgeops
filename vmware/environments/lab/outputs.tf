output "vsphere_server" {
  value       = var.vsphere_server
}

#next st_
output "vm_settings" {
  description = "VM settings for instances"
  value       = local.vm_settings
}