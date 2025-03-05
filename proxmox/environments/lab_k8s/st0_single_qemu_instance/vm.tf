resource "proxmox_vm_qemu" "cloudinit-test" {
    name = var.pm_vm_name
    #desc = "A test for using terraform and cloudinit"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = var.pm_vm_target_node

    # The destination resource pool for the new VM
    #pool = "pool0"

    # The template name to clone this vm from
    clone = var.pm_vm_template

    # Activate QEMU agent for this VM
    agent = var.pm_vm_enable_qemu_agent ? 1 : 0

    os_type = "cloud-init"
    cores = var.pm_vm_cores
    sockets = var.pm_vm_sockets
    vcpus = var.pm_vm_vcpus
    memory = var.pm_vm_memory
    scsihw = var.pm_vm_scsihw

    disks {
        ide {
            #ide3 {
            ide0 {
            }
        }
        virtio {
            virtio0 {
                disk {
                    size            = var.pm_vm_disk_size
                    cache           = var.pm_vm_disk_cache
                    storage         = var.pm_vm_disk_storage
                    iothread        = var.pm_vm_disk_iothread
                    discard         = var.pm_vm_disk_discard
                }
            }
        }
    }

    network {
        model = var.pm_vm_network_model
        bridge = var.pm_vm_network_bridge
        tag = var.pm_vm_network_tag
    }

    boot = "order=virtio0"
    ipconfig0 = var.pm_vm_ipconfig0

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}