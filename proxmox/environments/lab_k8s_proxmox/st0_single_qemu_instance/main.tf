terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "=3.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
  }
  required_version = ">= 1.10.0"

  backend "s3" {
    bucket         = "terraform-state-forgeops"
    key            = "proxmox/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_secretsmanager_secret" "proxmox" {
  name = "terraform/proxmox"
}

data "aws_secretsmanager_secret_version" "proxmox" {
  secret_id = data.aws_secretsmanager_secret.proxmox.id
}

provider "proxmox" {
  pm_api_url          = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)["pm_api_url"]
  pm_api_token_id     = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)["pm_api_token_id"]
  pm_api_token_secret = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)["pm_api_token_secret"]
  pm_tls_insecure     = jsondecode(data.aws_secretsmanager_secret_version.proxmox.secret_string)["pm_tls_insecure"]
}