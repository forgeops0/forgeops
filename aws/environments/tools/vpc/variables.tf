variable "global_vars" {
  description = "Global variables for environment/project/owner"
  type = object({
    env     = string
    project = string
    owner   = string
  })
}

variable "cidr_block_vpc" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "enable_dns_support" {
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  default     = true
}

variable "public_subnets" {
  description = "Map of public subnet definitions: name => { cidr, az }"
  type = map(object({
    cidr = string
    az   = string
  }))
}