# resource "null_resource" "deploy_controller" {
#   triggers = {
#     file_hash = filesha256("${path.module}/remote-exec.tf")
#   }

#   # depends_on = [
#   #   vsphere_virtual_machine.vm-forgeops-worker
#   # ]

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
#       # "sleep 3",

#       # Writing the kubeadm configuration file for the master
#       "sudo tee /etc/kubeadm-config.yaml <<EOF",
#       "kind: ClusterConfiguration",
#       "apiVersion: kubeadm.k8s.io/v1beta3",
#       "kubernetesVersion: v1.30.0",
#       "networking:",
#       "  podSubnet: \"192.168.0.0/16\"",
#       #"  serviceSubnet: \"10.96.0.0/12\"",
#       "---",
#       "kind: KubeletConfiguration",
#       "apiVersion: kubelet.config.k8s.io/v1beta1",
#       "cgroupDriver: systemd",
#       "apiServer:",
#       "  certSANs:",
#       "  - \"${var.controller_address}\"",        # Internal IP of controller
#       #"  - \"${var.controller_NAT_address}\"",   # External IP of controller (if behind NAT)
#       "---",
#       # "apiVersion: kubeproxy.config.k8s.io/v1alpha1",
#       # "kind: KubeProxyConfiguration",
#       # "mode: 'iptables'",  # or 'ipvs'
#       #"nodePortAddresses:",
#       #"  - '192.168.1.0/24'",  # Example CIDR range for valid node IPs
#       #"localhostNodePorts: false",  # Disable localhost access for NodePorts

# "apiVersion: kubeproxy.config.k8s.io/v1alpha1",
# "kind: KubeProxyConfiguration",
# "mode: 'iptables'",  # lub "ipvs"
# "detectLocalMode: NodeCIDR",  # Wybór opcji, która bazuje na CIDR węzłów
# # Nie ustawiaj ClusterCIDR na IPv6, tylko na IPv4, jeśli to wymagane.

#       "EOF", 
#       # # Initializing the Kubernetes cluster
#       # "sudo kubeadm init --config=/etc/kubeadm-config.yaml",

#       # # Allow some time for initialiation
#       # "sleep 60",

#       # # Configuring kubectl for the ubuntu user
#       # "mkdir -p $HOME/.kube",
#       # "sudo cp -i /etc/kubeadm-config.yaml $HOME/.kube/kubeadm-config.yaml",
#       # "sudo chown $(id -u):$(id -g) $HOME/.kube/kubeadm-config.yaml",

#       # # # Get the token for joining worker nodes
#       # # "JOIN_CMD=$(sudo kubeadm token create --print-join-command)",

#       # # # Save the join command in a temporary file for later
#       # # "echo $JOIN_CMD > /tmp/join_command.sh",

#       # # Download and apply the Calico CNI plugin for networking
#       # # "curl https://calico-v3-25.netlify.app/archive/v3.25/manifests/calico.yaml -o calico.yaml",
#       # # "kubectl apply -f calico.yaml --validate=false",

#       # # Create directories needed for PostgreSQL (if necessary for later steps)
#       # "mkdir -p /tmp/pg-controller /tmp/pg-replica"
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
#     null_resource.deploy_controller
#   ]
#   count = var.worker_count
#   provisioner "remote-exec" {
#     inline = [
#       # "sleep 10",
#       # "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
#       # "curl -fsSL https://pkgs.k8s.io/core:/stable:/${var.kube_version}/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
#       # "sudo apt update",
#       # "sudo apt install -y docker.io",
#       # "sudo systemctl start docker",
#       # "sudo systemctl enable docker",
      
#       # "sudo apt install -y kubelet kubeadm kubectl",
#       # # Sleep to ensure the master has time to generate the join command
#       # # "sleep 10",

#       # # # Fetch the join command from the controller
#       # # "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ubuntu@${var.controller_address}:/tmp/join_command.sh /tmp/join_command.sh",

#       # # # Execute the join command to add the worker node to the cluster
#       # # "sudo bash /tmp/join_command.sh",
#       # # "exit"
#     ]

#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = local.ssh_privkey
#       host        = local.ipworker_NAT_list[count.index]
#     }
#   }
# }
