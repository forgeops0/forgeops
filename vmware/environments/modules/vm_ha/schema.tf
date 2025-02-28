resource "vsphere_virtual_machine" "vm-node1" {
  for_each                  = local.vm_standard
  name                      = lookup(each.value, "instance_name", null)
  num_cpus                  = lookup(each.value, "vm_cpus", local.vm_cpus)
  memory                    = lookup(each.value, "vm_memory", local.vm_memory)
  firmware                  = lookup(each.value, "vm_firmware", local.vm_firmware)
  efi_secure_boot_enabled   = lookup(each.value, "vm_efi_secure_boot_enabled", local.vm_efi_secure_boot_enabled)
  guest_id                  = var.vm_settings["vsphere_guest_id"]
  datastore_id              = each.value["zone"] == "A" ? var.vm_settings["vsphere_datastore_zoneA1"] : var.vm_settings["vsphere_datastore_zoneB1"]
  resource_pool_id          = var.vm_settings["vsphere_resource_pool_id"]

  network_interface {
    network_id = var.vm_settings["vsphere_network_id"]
  }

  disk {
    label            = "disk0"
    size             = lookup(each.value, "vm_disk_size", local.vm_disk_size)
    eagerly_scrub    = var.vm_settings["disk_eagerly_scrub"]
    thin_provisioned = var.vm_settings["disk_thin_provisioned"]
  }

  clone {
    template_uuid = lookup(each.value, "vm_template", var.vm_settings["default_vm_template_uuid"])

    customize {
      linux_options {
        host_name = lookup(each.value, "instance_name", local.host_name)
        domain    = lookup(each.value, "vm_domain", local.vm_domain)
      }

      network_interface {
        ipv4_address = lookup(each.value, "ipv4_address", null)
        ipv4_netmask = var.vm_settings["ipv4_netmask"]
      }

      ipv4_gateway    = var.vm_settings["ipv4_gateway"]
      dns_server_list = [
        var.vm_settings["dns_server_list1"],
        var.vm_settings["dns_server_list2"]
      ]
    }
  }
}

resource "vsphere_virtual_machine" "vm-node2" {
  for_each                  = local.vm_standard
  name                      = lookup(each.value, "instance_name", null)
  num_cpus                  = lookup(each.value, "vm_cpus", local.vm_cpus)
  memory                    = lookup(each.value, "vm_memory", local.vm_memory)
  firmware                  = lookup(each.value, "vm_firmware", local.vm_firmware)
  efi_secure_boot_enabled   = lookup(each.value, "vm_efi_secure_boot_enabled", local.vm_efi_secure_boot_enabled)
  guest_id                  = var.vm_settings["vsphere_guest_id"]
  datastore_id              = var.vm_settings["vsphere_datastore_zoneB2"]
  resource_pool_id          = var.vm_settings["vsphere_resource_pool_id"]

  network_interface {
    network_id = var.vm_settings["vsphere_network_id"]
  }

  disk {
    label            = "disk0"
    size             = lookup(each.value, "vm_disk_size", local.vm_disk_size)
    eagerly_scrub    = var.vm_settings["disk_eagerly_scrub"]
    thin_provisioned = var.vm_settings["disk_thin_provisioned"]
  }

  clone {
    template_uuid = lookup(each.value, "vm_template", var.vm_settings["default_vm_template_uuid"])

    customize {
      linux_options {
        host_name = lookup(each.value, "instance_name", local.host_name)
        domain    = lookup(each.value, "vm_domain", local.vm_domain)
      }

      network_interface {
        ipv4_address = lookup(each.value, "ipv4_address", null)
        ipv4_netmask = var.vm_settings["ipv4_netmask"]
      }

      ipv4_gateway    = var.vm_settings["ipv4_gateway"]
      dns_server_list = [
        var.vm_settings["dns_server_list1"],
        var.vm_settings["dns_server_list2"]
      ]
    }
  }
}
