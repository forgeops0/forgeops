module "docker_instances" {
  source      = "../vm_standard"
  vm_list     = var.vm_docker_list
  vm_settings = var.vm_settings
}

resource "null_resource" "install_docker" {
  for_each = local.vm_docker
    depends_on = [module.docker_instances]
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = var.ssh_private_key
    host        =  "10.100.1.10" #lookup(each.value, "ipv4_nat_address", "ipv4_address")
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 3",
      #temporary until we build an image builder
      "sudo apt update",
      "sudo apt upgrade -y",
    #   "echo '${local.ssh_privkey}' > /home/ubuntu/.ssh/id_rsa",
    #   "chmod 600 /home/ubuntu/.ssh/id_rsa",
      "sleep 1",
      # Install required packages
      "sudo apt-get install -y ca-certificates curl",

      # Create directory for keyrings if it doesn't exist
      "sudo install -m 0755 -d /etc/apt/keyrings",

      # Download Docker's GPG key and save it
      "sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc",

      # Set permissions for the GPG key
      "sudo chmod a+r /etc/apt/keyrings/docker.asc",

      # Add Docker's repository to Apt sources
      "echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \\\"$VERSION_CODENAME\\\") stable\" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",

      # Update package lists again
      "sudo apt-get update",
      "sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",
      "sudo usermod -aG docker $USER",
    ]
  }
}
