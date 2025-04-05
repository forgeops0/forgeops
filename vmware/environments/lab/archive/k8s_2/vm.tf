data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm-forgeops-controller" {
  name                    = "${var.env}-${var.app}-controller"
  num_cpus                = var.vm_cpus
  memory                  = var.vm_memory
  firmware                = var.vm_firmware
  efi_secure_boot_enabled = var.vm_efi_secure_boot_enabled
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  datastore_id            = data.vsphere_datastore.datastore.id
  resource_pool_id        = data.vsphere_resource_pool.pool.id

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.controller_template.id

    customize {
      linux_options {
        host_name = "${var.env}-${var.app}-controller"
        domain    = var.vm_domain
      }

      network_interface {
        ipv4_address = var.controller_address
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway = var.ipv4_gateway
      dns_server_list = [var.dns_server_list1, var.dns_server_list2]
    }
  }
  }




resource "vsphere_virtual_machine" "vm-forgeops-worker" {
  count =  var.worker_count 
    depends_on = [
    vsphere_virtual_machine.vm-forgeops-controller
  ]
   name                    = local.worker_name_list[count.index]
  num_cpus                = var.vm_cpus
  memory                  = var.vm_memory
  firmware                = var.vm_firmware
  efi_secure_boot_enabled = var.vm_efi_secure_boot_enabled
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  datastore_id            = data.vsphere_datastore.datastore.id
  resource_pool_id        = data.vsphere_resource_pool.pool.id

  network_interface {network_id = data.vsphere_network.network.id}

  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks.0.eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.worker_template.id

    customize {
      linux_options {
        host_name = local.worker_name_list[count.index]
        domain    = var.vm_domain
      }

      network_interface {
        #ipv4_address = var.replica1_address
        ipv4_address = local.ipworker_list[count.index]
        ipv4_netmask = var.ipv4_netmask
      }

      ipv4_gateway = var.ipv4_gateway
      dns_server_list = [var.dns_server_list1, var.dns_server_list2]
    }
  }
  # lifecycle {
  #   ignore_changes = [
  #     clone[0].template_uuid,
  #   ]
  # }
}