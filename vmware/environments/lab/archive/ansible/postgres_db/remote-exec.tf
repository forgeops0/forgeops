# Run an Ansible playbook after the VM is provisioned
# Run an Ansible playbook after the VM is provisioned
resource "null_resource" "ansible_provisioner" {
  #depends_on = [vsphere_virtual_machine.vm-forgeops-worker] # Ensure VM is created first
  depends_on = [ 
    null_resource.deploy_controller 
    ]

  provisioner "local-exec" {
    command     = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i '10.0.2.130' playbook.yml --extra-vars 'master=10.0.2.130 worker=10.0.2.131'"
    working_dir = "/home/ubuntu/terraform-lab/environments/lab/ansible/postgres_db"
    
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
  }

  triggers = {
    playbook_checksum = filemd5("/home/ubuntu/terraform-lab/environments/lab/ansible/postgres_db/playbook.yml")
  }
}
resource "null_resource" "deploy_controller" {
  depends_on = [
    vsphere_virtual_machine.vm-forgeops-controller
  ]


  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo apt-get update",
      "sudo apt-get install -y software-properties-common",
      
      # Install Ansible
      "sudo add-apt-repository --yes --update ppa:ansible/ansible",
      "sudo apt-get update",
      "sudo apt-get install -y ansible",

      # Install Kubernetes (kubectl)
      "sudo apt-get install -y apt-transport-https ca-certificates curl",
      "sudo curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/kubernetes-archive-keyring.gpg",
      "echo 'deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
      "sudo apt-get update",
      "sudo apt-get install -y kubectl"
    ]
  }



    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = local.ssh_privkey 
      host        = var.controller_NAT_address
    }
  }


# resource "null_resource" "deploy_worker" {
#   count = var.worker_count
#   depends_on = [
#     vsphere_virtual_machine.vm-forgeops-worker
#   ]

#   provisioner "remote-exec" {
#     inline = [
#       "sleep 10",
#       "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
#       "curl -fsSL https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
#       "sudo apt update",
#       "sudo apt install -y docker.io",
#       "sudo systemctl start docker",
#       "sudo systemctl enable docker",
      
#       "sudo apt install -y kubelet kubeadm kubectl",

#       #Get token for workers

#       "echo '${local.ssh_privkey}' > /home/ubuntu/.ssh/id_rsa",

#       "chmod 600 /home/ubuntu/.ssh/id_rsa",

#       "GET_TOKEN=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubeadm token create --print-join-command')",
      
#       #Execute kubejoin in controller
#       "sudo $GET_TOKEN",
#       "sleep 3",

#       "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubectl label node ${local.worker_name_list[count.index]} node-role.kubernetes.io/worker='"
#     ]


#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = local.ssh_privkey 
#       host        = local.ipworker_NAT_list[count.index]
#     }
#   }
# }