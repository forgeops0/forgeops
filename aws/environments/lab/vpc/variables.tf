variable "global_vars" {
  description = "Global variables for environment/project/owner"
  type = object({
    env     = string
    project = string
    owner   = string
  })
}

variable "subnet_names" {
  type        = list(string)
  description = "List of subnet name suffixes (for tagging and naming)"
}

variable "cidr_block_vpc" {
  type        = string
  description = "CIDR block for the VPC"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "List of CIDRs for private subnets"
}