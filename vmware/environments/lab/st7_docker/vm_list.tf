variable "vm_standard_list" {
  type = list(any)
  default = [
        {
      instance_name       = "test1"
      ipv4_address        = "10.0.2.195"
      #vm_template          = "ubuntu-basic-template-v1.2"
    },
    {
      instance_name       = "test2"
      ipv4_address        = "10.0.2.196"
    }
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
      ipv4_address        = "10.0.2.198"
      ipv4_nat_address        = "10.0.1.198"
    },
    # {
    #   instance_name       = "test5"
    #   ipv4_address        = "10.0.2.199"
    #   vm_cpus             = 4
    # },

  ]
}



