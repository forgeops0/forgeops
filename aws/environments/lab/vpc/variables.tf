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

variable "private_subnet_azs" {
  type        = list(string)
  description = "List of AZs for private subnets (index-aligned with private_subnet_cidrs)"
}