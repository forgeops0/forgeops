#first instance without module

pm_vm_name = "terraform-test-vm"
pm_vm_target_node = "admin"
pm_vm_template = "ubuntu-24.04-template"
pm_vm_enable_qemu_agent = true
pm_vm_cores = 2
pm_vm_sockets = 1
pm_vm_vcpus = 0
pm_vm_memory = 2048
pm_vm_scsihw = "lsi"
pm_vm_disk_size = 32
pm_vm_disk_cache = "writeback"
pm_vm_disk_storage = "local-lvm"
pm_vm_disk_iothread = true
pm_vm_disk_discard = true
pm_vm_network_model = "virtio"
pm_vm_network_bridge = "vmbr0"
pm_vm_network_tag = 256
pm_vm_ipconfig0 = "ip=192.168.88.190/24,gw=192.168.88.1"
