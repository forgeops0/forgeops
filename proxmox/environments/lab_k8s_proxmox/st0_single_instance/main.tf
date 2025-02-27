terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc4"
    }
  }
}

# Proxmox provider configuration
provider "proxmox" {
  pm_api_url          = "xyz"
  pm_api_token_id     = "xyz" #tmp
  pm_api_token_secret = "xyz" #tmp
  pm_tls_insecure     = true  # Set to true if using a self-signed certificate
}

# SSH public key variable
variable "ssh_key" {
  description = "SSH public key for VM"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVe7UyeUcoyIgzVtxtXHWm1buenJRwBCYQXLCHY6ULN krzysztof.pytlik11@gmail.com"
}

resource "proxmox_vm_qemu" "vm" {
  name        = "lab-terraform-vm-tmp1"
  target_node = "admin"   # Node name 
  vmid        = 101      
  
  clone       = "toolsVM"  # Set origin template name
  full_clone  = true       # Create full clone instead of linked clone
  
  memory      = 2048      
  cores       = 2          
  sockets     = 1          
  cpu         = "host"
  balloon     = 1024
  scsihw      = "virtio-scsi-pci"

  disk {
    storage = "local-lvm"
    size    = "20G"    # Disk size with unit

    type    = "scsi"
    #format  = "qcow2"
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  os_type = "cloud-init"
  cloudinit_cdrom_storage = "local-lvm"

  sshkeys = var.ssh_key

  agent = 1 # Enable QEMU Guest Agent

  lifecycle {
    ignore_changes = [network]
  }
}