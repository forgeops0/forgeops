provider "kubernetes" {
  host        = "https://10.0.2.180:6443"
  config_path = "~/.kube/config"
  #version = "~> 2.30"
}

provider "vault" {
  address = "https://10.0.2.150:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
       role_id = "6495d099-4ae0-708a-d568-c0647af778fe"
       secret_id = "x"
    }
  }
}

