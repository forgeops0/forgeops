# SSH public key variable
variable "ssh_key" {
  description = "SSH public key for VM"
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHVe7UyeUcoyIgzVtxtXHWm1buenJRwBCYQXLCHY6ULN forgeops@spaceops.pl"
}
