resource "null_resource" "install_containerd_and_k8s" {
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
#       # System update and install dependencies
#       "sudo apt-get update",
#       "sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release",

#       # Add Docker GPG key and repository
#       "sudo mkdir -p /etc/apt/keyrings",
#       "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg",
# # #"echo 'deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable' | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null",
#   "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
#       "sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg",



#       # Update repos and install containerd
#             # Enable kernel modules and sysctl parameters
#       "sudo modprobe overlay",
#       "sudo sysctl net.bridge.bridge-nf-call-iptables=1",
#       "sudo sysctl net.bridge.bridge-nf-call-ip6tables=1",
#       "sudo sysctl -w net.ipv4.ip_forward=1",
#       "echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.conf",
#       "sudo sysctl -p",
#       "sudo apt-get update",
#       #"sudo apt-get install -y containerd.io",
#       "echo 'Y' | sudo DEBIAN_FRONTEND=noninteractive apt-get install -y containerd.io",
#      Create default config for containerd
      "sudo mkdir -p /etc/containerd",
      "sudo containerd config default | sudo tee /etc/containerd/config.toml",

#      Restart and enable containerd
      "sudo systemctl restart containerd",
      "sudo systemctl enable containerd",

#       # Install kubelet, kubeadm, kubectl
# #      "sudo apt-get install -y apt-transport-https ca-certificates curl",
# #      "curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.31/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
# #      "sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
# #      "echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https:ezi//pkgs.k8s.io/core:/stable:/v1.31/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list",
# #      "sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list",
# #      "sudo apt update",
# #      "sudo apt install -y kubelet kubeadm kubectl",

      # Configure kubeadm for Kubernetes with containerd
      <<EOT
sudo tee /etc/kubeadm-config.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta4
kind: InitConfiguration
localAPIEndpoint:
  advertiseAddress: "10.0.2.170"
  bindPort: 6443
---
apiVersion: kubeadm.k8s.io/v1beta4
kind: ClusterConfiguration
kubernetesVersion: "v1.30.0"
controlPlaneEndpoint: "10.0.2.170"
apiServer:
  certSANs:
  - "10.0.2.170"
  - "10.0.2.170"
---
apiVersion: kubelet.config.k8s.io/v1beta1  
kind: KubeletConfiguration  
cgroupDriver: systemd
EOF
EOT
      ,

      # Initialize the Kubernetes cluster with kubeadm
      "sudo kubeadm init --config /etc/kubeadm-config.yaml",

      # Configure kubectl for the user
      "mkdir -p $HOME/.kube",
      "rm -rf $HOME/.kube/config",
      "sudo cp  -i /etc/kubeadm-config.yaml $HOME/.kube/config",
      "sudo chown $(id -u):$(id -g) $HOME/.kube/config",

      # Install Calico CNI plugin
      "kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml --server-side"
     ]
   }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = local.ssh_privkey 
    host        = var.controller_NAT_address
  }
}
