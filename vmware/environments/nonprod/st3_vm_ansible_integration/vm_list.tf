variable "vm_standard_list" {
  type = list(any)
  default = [
        {
      instance_name       = "test1"
      ipv4_address        = "10.100.1.10"
      #vm_template          = "lab_forgeops_Ubuntu_24.04 OFF V2-beta"
    },
    # {
    #   instance_name       = "test2"
    #   ipv4_address        = "10.100.1.12"
    # }
  ]
}

variable "vm_docker_list" {
  type = list(any)
  default = [
    {
      instance_name       = "test1-docker"
      ipv4_address        = "10.100.1.13"
      #vm_cpus             = 4
    },
    # {
    #   instance_name       = "test2-docker"
    #   ipv4_address        = "10.100.1.14""
    #   #vm_cpus             = 4
    # },
    # {
    #   instance_name       = "test3-docker"
    #   ipv4_address        = "10.100.1.15"
    #   #vm_cpus             = 4
    # },
  ]
}