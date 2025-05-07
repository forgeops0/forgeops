// ---------------------------
// File: vpc.auto.tfvars
// ---------------------------

global_vars = {
  env     = "lab"
  project = "spaceops"
  owner   = "chrisp0"
}

cidr_block_vpc        = "172.17.0.0/16"
enable_dns_support    = true
enable_dns_hostnames  = true
create_public_subnets = true
create_nat_instance   = true

nat_instance_config = {
  ami           = "ami-09ebacdc178ae24c4"
  instance_type = "t4g.nano"
  private_ip    = "172.17.1.10"
  key_name      = "YOUR_KEY_NAME"
  volume_size   = 8
  volume_type   = "gp3"
}

public_subnets = {
  web-a = {
    cidr = "172.17.1.0/24"
    az   = "eu-north-1a"
  }
  web-b = {
    cidr = "172.17.2.0/24"
    az   = "eu-north-1b"
  }
}

private_subnets = {
  app-a = {
    cidr = "172.17.101.0/24"
    az   = "eu-north-1a"
  }
  app-b = {
    cidr = "172.17.102.0/24"
    az   = "eu-north-1b"
  }
  db-a = {
    cidr = "172.17.201.0/24"
    az   = "eu-north-1a"
  }
  db-b = {
    cidr = "172.17.202.0/24"
    az   = "eu-north-1b"
  }
}
