######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

resource "terraform_data" "init_setup" {
  for_each = local.server

  triggers_replace = {
    packages = [
      "htop",
      "screen",
      "git",
      "sudo"
    ]
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.terraform_ssh.private_key_openssh
    host        = each.value["ipv4"]
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get upgrade -y",
      "apt-get autoremove -y",
      "apt-get install -y ${join(" ", self.triggers_replace.packages)}",
    ]
  }

}

resource "terraform_data" "terraform_key" {
  for_each = local.initServers

  triggers_replace = {
    private_key = tls_private_key.terraform_ssh.private_key_openssh
    server_id   = each.value["id"]
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.terraform_ssh.private_key_openssh
    host        = each.value["ipv4"]
  }

  provisioner "file" {
    content     = self.triggers_replace.private_key
    destination = "/root/.ssh/terraform_key"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod --verbose 600 /root/.ssh/terraform_key",
    ]
  }

  depends_on = [
    terraform_data.init_setup
  ]
}
