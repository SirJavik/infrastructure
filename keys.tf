######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

####
## Public User keys
####

data "hcloud_ssh_keys" "user_ssh_keys" {
  with_selector = "use_in_terraform=true"
}

####
## Terraform SSH Key
####

resource "tls_private_key" "terraform_ssh" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "terraform_ssh" {
  name       = "Terraform SSH"
  public_key = tls_private_key.terraform_ssh.public_key_openssh

  labels = {
    type      = "terraform_ssh"
    terraform = true
  }
}
