# # Create categories for all keys
# resource "vsphere_tag_category" "env_category" {
#   name        = "env"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# resource "vsphere_tag_category" "app_category" {
#   name        = "app"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# resource "vsphere_tag_category" "monitoring_category" {
#   name        = "monitoring"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# resource "vsphere_tag_category" "patching_category" {
#   name        = "patching"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# resource "vsphere_tag_category" "ansible_category" {
#   name        = "ansible"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# resource "vsphere_tag_category" "terraform_management_category" {
#   name        = "terraform_management"
#   cardinality = "SINGLE"
#   associable_types = [
#     "VirtualMachine"
#   ]
# }

# # Create tags for all categories
# resource "vsphere_tag" "env_lab" {
#   name        = "lab"
#   category_id = vsphere_tag_category.env_category.id
# }

# resource "vsphere_tag" "app_forgeops" {
#   name        = "forgeops"
#   category_id = vsphere_tag_category.app_category.id
# }

# resource "vsphere_tag" "monitoring_out_of_scope" {
#   name        = "out-of-scope"
#   category_id = vsphere_tag_category.monitoring_category.id
# }

# resource "vsphere_tag" "patching_out_of_scope" {
#   name        = "out-of-scope"
#   category_id = vsphere_tag_category.patching_category.id
# }

# resource "vsphere_tag" "ansible_false" {
#   name        = "false"
#   category_id = vsphere_tag_category.ansible_category.id
# }

# resource "vsphere_tag" "terraform_management_true" {
#   name        = "true"
#   category_id = vsphere_tag_category.terraform_management_category.id
# }

