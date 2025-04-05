variable "vm_standard_list" {
  type = list(any)
  default = [
        {
      instance_name       = "test1"
      ipv4_address        = "10.154.114.214"
      #vm_template          = "lab_forgeops_Ubuntu_24.04 OFF V2-beta"
    },
    # {
    #   instance_name       = "test2"
    #   ipv4_address        = "10.0.2.196"
    # }
  ]
}

variable "vm_docker_list" {
  type = list(any)
  default = [
    #     {
    #   instance_name       = "test3"
    #   ipv4_address        = "10.0.2.197"
    # },
    {
      instance_name       = "test4"
      ipv4_address        = "10.100.1.10"
    },
    # {
    #   instance_name       = "test5"
    #   ipv4_address        = "10.0.2.199"
    #   vm_cpus             = 4
    # },
  ]
}



