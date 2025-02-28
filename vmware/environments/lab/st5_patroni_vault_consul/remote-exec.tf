#execute after deploy controller virtual machine 
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

      #temporary until we build an image builder or image repository
      "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.2.170:/home/ubuntu/patroni.tar /home/ubuntu/",
      "sudo ctr -n k8s.io images import /home/ubuntu/patroni.tar"
      #
    ]
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = local.ssh_privkey
      host        = "${var.controller_NAT_address}"
    }
  }
}

# Worker node provisioning and joining the master (after execute deploy_controller)
resource "null_resource" "deploy_worker" {
  depends_on = [
     null_resource.deploy_controller
  ]
  count = var.worker_count
  provisioner "remote-exec" {
    inline = [
      "sleep 3",
      #temporary until we build an image builder
      "sudo apt update",
      "sudo apt install -y socat",
      #
      "sudo kubeadm reset -f",
      "sudo systemctl restart kubelet",
      "echo '${local.ssh_privkey}' > /home/ubuntu/.ssh/id_rsa",
      "chmod 600 /home/ubuntu/.ssh/id_rsa",

      #GET token for join worker
      "GET_TOKEN=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubeadm token create --print-join-command')",
      #performing the worker attachment procedure
      "sudo $GET_TOKEN",
      "sleep 3",

      #Set kubernetes role(label) for worker
      "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.controller_address} 'kubectl label node ${local.worker_name_list[count.index]} node-role.kubernetes.io/worker='",
      "sleep 1",

      #temporary until we build an image builder or image repository
      "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null  -i /home/ubuntu/.ssh/id_rsa ubuntu@10.0.2.170:/home/ubuntu/patroni.tar /home/ubuntu/",
      "sudo ctr -n k8s.io images import /home/ubuntu/patroni.tar",
      #
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
