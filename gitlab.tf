######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
###################################### 

data "gitlab_current_user" "me" {}

data "gitlab_user" "example" {
  username = "Javik"
}

resource "gitlab_user_sshkey" "gitlab-terraform-key" {
  user_id = 0
  title   = "Terraform Key"
  key     = tls_private_key.terraform_ssh.public_key_openssh
}

data "gitlab_user_sshkeys" "keys" {
  username = "Javik"
}

output "gitlab_user_id" {
  value = data.gitlab_user.example.id
}

output "gitlab_keys" {
  value = data.gitlab_user_sshkeys.keys.keys
}
