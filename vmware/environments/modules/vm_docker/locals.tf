locals {
      vm_docker ={ for vm in var.vm_docker_list : vm.instance_name => vm }
}