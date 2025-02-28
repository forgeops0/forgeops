locals {
    vm_settings = {
        vsphere_server           =  "vsphere.lab.forgeops.eu"    
        ipv4_netmask             = "24"
        ipv4_gateway             = "10.154.114.1"
        vsphere_datacenter       = "forgeops_datacenter"
        vsphere_guest_id         = data.vsphere_virtual_machine.default_vm_template.guest_id
        vsphere_datastore_id     = data.vsphere_datastore.datastore.id
        vsphere_resource_pool_id = data.vsphere_resource_pool.pool.id
        vsphere_network_id       = data.vsphere_network.network.id
        disk_eagerly_scrub       = false
        disk_thin_provisioned    = true
        default_vm_template_uuid = data.vsphere_virtual_machine.default_vm_template.id
        ipv4_netmask             = "24"
        dns_server_list1         = "10.154.186.101"
        dns_server_list2         = "10.154.186.102"
  }
}
