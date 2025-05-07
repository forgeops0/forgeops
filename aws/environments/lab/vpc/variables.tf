variable "global_vars" {
  type = object({
    env     = string
    project = string
    owner   = string
  })
}

variable "cidr_block_vpc" {
  type = string
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "create_public_subnets" {
  type    = bool
  default = true
}

variable "create_nat_instance" {
  type    = bool
  default = true
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "nat_instance_config" {
  type = object({
    ami           = string
    instance_type = string
    private_ip    = string
    key_name      = string
    volume_size   = number
    volume_type   = string
  })
}