locals {
    ssh_privkey = file("/home/xxx")
}

locals {
  vm_settings = data.terraform_remote_state.lab.outputs.vm_settings
}
