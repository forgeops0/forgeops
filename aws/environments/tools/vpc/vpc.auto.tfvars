global_vars = {
  env     = "tools"
  project = "spaceops"
  owner   = "chrisp0"
}

cidr_block_vpc        = "172.16.0.0/16"
enable_dns_support    = true
enable_dns_hostnames  = true

public_subnets = {
  public-a = {
    cidr = "172.16.1.0/24"
    az   = "eu-north-1a"
  }
  public-b = {
    cidr = "172.16.2.0/24"
    az   = "eu-north-1b"
  }
}