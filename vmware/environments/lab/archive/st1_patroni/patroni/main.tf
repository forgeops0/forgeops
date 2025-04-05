provider "kubernetes" {
  host        = "https://10.0.2.180:6443"
  config_path = "~/.kube/config"
  #version = "~> 2.30"
}

