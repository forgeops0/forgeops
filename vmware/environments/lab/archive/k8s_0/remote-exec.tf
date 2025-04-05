# resource "null_resource" "deploy_controller" {
#   depends_on = [
#    null_resource.deploy_worker
#   ]

#   provisioner "remote-exec" {
#     inline = [
#       # "sleep 10",
#       # "sudo apt update",
#       # "sudo apt install -y docker.io",
#       # "sudo systemctl start docker",
#       # "sudo systemctl enable docker",
#       # "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
#       # "curl -fsSL https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
#       # "sudo apt update",
#       # "sudo apt install -y kubelet kubeadm kubectl",
#         "sleep 3",
#       # Writing the kubeadm configuration file
#       <<-EOT
#       sudo tee /etc/kubeadm-config.yaml <<EOF
# apiVersion: kubeadm.k8s.io/v1beta3
# kind: InitConfiguration
# localAPIEndpoint:
#   advertiseAddress: "${var.controller_address}"
#   bindPort: 6443
# ---
# apiVersion: kubeadm.k8s.io/v1beta3
# kind: ClusterConfiguration
# kubernetesVersion: "v1.30.0"
# controlPlaneEndpoint:  "${var.controller_address}"
# # networking:
# #   podSubnet: "${var.kube_pod_cidr}"  # Updated pod network CIDRte
# apiServer:
#   certSANs:
#   - "${var.controller_address}"
#   - "${var.controller_NAT_address}"
# EOF
#       EOT
#       ,

#       # Initializing the Kubernetes cluster using the generated configuration
# "sudo kubeadm init --config=/etc/kubeadm-config.yaml",

# # Configure kubectl for the ubuntu user
# "sleep 60",
# "mkdir -p $HOME/.kube",
# "sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config",
# "sudo chown $(id -u):$(id -g) $HOME/.kube/config",

# "kubectl label node 10.0.2.191 node-role.kubernetes.io/worker=",
# "GET_TOKEN=$(kubeadm token create --print-join-command)",

# "EXEC_COMM=$(ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i /home/ubuntu/.ssh/id_rsa ubuntu@${var.worker_address} "sudo ${GET_TOKEN}")",

# # Execute kubejoin in controller

# # Download and apply Calico manifest to set the correct pod CIDR
# "curl https://calico-v3-25.netlify.app/archive/v3.25/manifests/calico.yaml -o calico.yaml",
# #'sed -i "s#192.168.0.0/16#${var.kube_pod_cidr}#g" calico.yaml',

# # Modify CALICO_NETWORKING_BACKEND directly in the calico.yaml file to disable BIRD (BGP)
# #'sed -i "s#name: CALICO_NETWORKING_BACKEND#name: CALICO_NETWORKING_BACKEND\\n  value: \"none\"#g" calico.yaml',

# # Apply the modified Calico manifest
# #'kubectl apply -f calico.yaml --validate=false',

# "kubectl apply -f /home/ubuntu/calico.yaml --validate=false",

# "mkdir /tmp/pg-controller",
# "mkdir /tmp/pg-replica"

#     ]

#     connection {
#       type     = "ssh"
#       user     = "ubuntu"
#       private_key = local.ssh_privkey 
#       host     = "${var.controller_NAT_address}"
#     }
#   }
# }




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