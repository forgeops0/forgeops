#Associate tags for resource
# resource "vsphere_tag_association" "assign_tags_to_vm" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"

#   # Przypisanie każdego tagu
#   tag_id = vsphere_tag.env_lab.id
# }

# resource "vsphere_tag_association" "assign_app_tag" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"
#   tag_id      = vsphere_tag.app_forgeops.id
# }

# resource "vsphere_tag_association" "assign_monitoring_tag" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"
#   tag_id      = vsphere_tag.monitoring_out_of_scope.id
# }

# resource "vsphere_tag_association" "assign_patching_tag" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"
#   tag_id      = vsphere_tag.patching_out_of_scope.id
# }

# resource "vsphere_tag_association" "assign_ansible_tag" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"
#   tag_id      = vsphere_tag.ansible_false.id
# }

# resource "vsphere_tag_association" "assign_terraform_management_tag" {
#   object_id   = vsphere_virtual_machine.vm.id
#   object_type = "VirtualMachine"
#   tag_id      = vsphere_tag.terraform_management_true.id
# }
