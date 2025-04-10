variable "global_vars" {
  description = "Global variables for environment/project/owner"
  type = object({
    env     = string
    project = string
    owner   = string
  })
}

# variable "subnet_names" {
#   type        = list(string)
#   description = "List of subnet name suffixes (for tagging and naming)"
# }

variable "enable_dns_support" {
  type        = bool
  description = "Enable DNS support in the VPC"
  default     = true
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hostnames in the VPC"
  default     = true
}

variable "private_subnets" {
  description = "Map of private subnet definitions: name => { cidr, az }"
  type = map(object({
    cidr = string
    az   = string
  }))
}

variable "cidr_block_vpc" {
    description = "value of the VPC CIDR block"
    type = string
}