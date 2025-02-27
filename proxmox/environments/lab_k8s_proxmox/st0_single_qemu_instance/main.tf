# terraform {
#   required_version = ">= 1.1.0"
#   required_providers {
#     proxmox = {
#       source  = "telmate/proxmox"
#       version = ">= 2.9.5"
#     }
#   }
# }
# Proxmox provider configuration

# Define the usual provider things
terraform {
  required_providers {
    proxmox = {
      # Use these two lines to run a locally compiled version of the provider
      #source = "registry.example.com/telmate/proxmox"
      #version = ">=1.0.0"

      # Normally we want the provider from the registry
      source = "Telmate/proxmox"
      # We can specificy a specific version. If we do not, terraform will use
      # the latest official release.
      #version = "=2.9.11"
      version = "=3.0.1-rc1"
    }
  }
  #required_version = ">= 0.14"
  required_version = ">= 1.1.0"
}

provider "proxmox" {
  pm_api_url          = "xxx"
  pm_api_token_id     = "xxx" #tmp
  pm_api_token_secret = "xxx" #tmp
  pm_tls_insecure     = true  # Set to true if using a self-signed certificate
}
