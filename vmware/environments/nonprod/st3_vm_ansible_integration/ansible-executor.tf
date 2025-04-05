# resource "null_resource" "deploy_docker" {

#   provisioner "remote-exec" {
#     inline = [
#         ""
#     ]
#     connection {
#       type        = "ssh"
#       user        = "ubuntu"
#       private_key = local.ssh_privkey
#       host        = local.ip_ansible
#       #timeout     = "5m"
#     }
#   }
# }
