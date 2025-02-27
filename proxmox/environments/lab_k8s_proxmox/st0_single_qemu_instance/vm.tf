resource "proxmox_vm_qemu" "cloudinit-test" {
    name = "terraform-test-vm"
    desc = "A test for using terraform and cloudinit"

    # Node name has to be the same name as within the cluster
    # this might not include the FQDN
    target_node = "admin"

    # The destination resource pool for the new VM
    #pool = "pool0"

    # The template name to clone this vm from
    clone = "ubuntu-24.04-template"

    # Activate QEMU agent for this VM
    agent = 1

    os_type = "cloud-init"
    cores = 2
    sockets = 1
    vcpus = 0
    #cpu_type = "host"
    memory = 2048
    scsihw = "lsi"

    # Setup the disk
    # cloudinit {
    #     storage = "local-lvm"
    # }

    disks {
        ide {
            #ide3 {
            ide0 {
            }
        }
        virtio {
            virtio0 {
                disk {
                    size            = 32
                    cache           = "writeback"
                    storage         = "local-lvm"
                    #storage_type    = "rbd"
                    iothread        = true
                    discard         = true
                }
            }
        }
    }

    # Setup the network interface and assign a vlan tag: 256
    network {
        #id = 0
        model = "virtio"
        bridge = "vmbr0"
        tag = 256
    }

    # Setup the ip address using cloud-init.
    boot = "order=virtio0"
    # Keep in mind to use the CIDR notation for the ip.
    ipconfig0 = "ip=192.168.88.190/24,gw=192.168.88.1"

    sshkeys = <<EOF
    ${var.ssh_key}
    EOF
}