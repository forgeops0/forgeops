global_vars = {
  env     = "lab"
  project = "spaceops"
  owner   = "chrisp0"
}

cidr_block_vpc        = "172.17.0.0/16"
private_subnet_cidrs  = ["172.17.101.0/24", "172.17.102.0/24"]
private_subnet_azs    = ["eu-north-1a", "eu-north-1b"]
subnet_names          = ["private-a", "private-b"]

enable_dns_support    = true
enable_dns_hostnames  = true