# resource "null_resource" "deploy_controller" {
#   # triggers = {
#   #   file_hash = filesha256("${path.module}/remote-exec.tf")
#   # }

#   depends_on = [
#     vsphere_virtual_machine.vm-forgeops-worker
#   ]

#   provisioner "remote-exec" {
#     inline = [
#       "sudo kubeadm reset -f",
#       "sudo systemctl restart kubelet",
#       "sudo kubeadm config images pull",
#       "sudo kubeadm init --pod-network-cidr=10.10.0.0/16",
#       "mkdir -p $HOME/.kube",
#       "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
#       "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
#       "kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml",
#       "curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml -O",
#       "sed -i 's/cidr: 192\.168\.0\.0\/16/cidr: 10.10.0.0\/16/g' custom-resources.yaml",
#       "kubectl create -f custom-resources.yaml",
#     ]
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = local.ssh_privkey
#       host        = "${var.controller_NAT_address}"
#     }
#   }
# }




# # Worker node provisioning and joining the master
# resource "null_resource" "deploy_worker" {
#   depends_on = [
#     vsphere_virtual_machine.vm-forgeops-worker
#   ]
#   count = var.worker_count
#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt install -y socat",
#       "sudo kubeadm reset -f",
#       "sudo systemctl restart kubelet",
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

resource "null_resource" "deploy_controller" {
  depends_on = [
    vsphere_virtual_machine.vm-forgeops-controller
  ]

  provisioner "remote-exec" {
    inline = [
      "sudo kubeadm reset -f",
      "sudo systemctl restart kubelet",
      "sudo kubeadm config images pull",
      "sudo kubeadm init --pod-network-cidr=10.10.0.0/16",
      "mkdir -p $HOME/.kube",
      "sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",
      "kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml",
      "curl https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml -O",
      "sed -i 's/cidr: 192\\.168\\.0\\.0\\/16/cidr: 10.10.0.0\\/16/g' custom-resources.yaml",
      "kubectl create -f custom-resources.yaml",
      "echo '${local.ssh_privkey}' > /home/ubuntu/.ssh/id_rsa",
      "chmod 600 /home/ubuntu/.ssh/id_rsa",
      "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.2.170:/home/ubuntu/patroni.tar /home/ubuntu/",
      "sudo ctr -n k8s.io images import /home/ubuntu/patroni.tar"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = local.ssh_privkey
      host        = "${var.controller_NAT_address}"
    }
  }
}

# Worker node provisioning and joining the master
resource "null_resource" "deploy_worker" {
  depends_on = [
     null_resource.deploy_controller
  ]
  count = var.worker_count
  provisioner "remote-exec" {
    inline = [
      "sleep 3",
      "sudo apt install -y socat",
      "sudo kubeadm reset -f",
      "sudo systemctl restart kubelet",
      "echo '${local.ssh_privkey}' > /home/ubuntu/.ssh/id_rsa",
      "chmod 600 /home/ubuntu/.ssh/id_rsa",

      "GET_TOKEN=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubeadm token create --print-join-command')",
      "sudo $GET_TOKEN",
      "sleep 3",
      "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubectl label node ${local.worker_name_list[count.index]} node-role.kubernetes.io/worker='",
      "sleep 1",
      "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.2.170:/home/ubuntu/patroni.tar /home/ubuntu/",
      "sudo ctr -n k8s.io images import /home/ubuntu/patroni.tar",
      "sleep 1"
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = local.ssh_privkey
      host        = local.ipworker_NAT_list[count.index]
      #timeout     = "5m"
    }
  }
}
