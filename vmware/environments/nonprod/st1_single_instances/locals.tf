locals {
    ssh_privkey = file("/home/xxx")
}


#taking data from the parent stack
locals {
  vm_settings = data.terraform_remote_state.nonprod.outputs.vm_settings
}
