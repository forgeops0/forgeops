global_vars = {
  env     = "lab"
  project = "spaceops"
  owner   = "chrisp0"
}

cidr_block_vpc        = "172.17.0.0/16"
enable_dns_support    = true
enable_dns_hostnames  = true

private_subnets = {
  private-a = {
    cidr = "172.17.101.0/24"
    az   = "eu-north-1a"
  }
  private-b = {
    cidr = "172.17.102.0/24"
    az   = "eu-north-1b"
  }
}