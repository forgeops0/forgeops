output "vsphere_server" {
  value       = "vsphere.lab.forgeops.eu" #var.vsphere_server
}

output "vm_settings" {
  description = "VM settings for instances"
  value       = local.vm_settings
}