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
## Ansible
####

resource "hcloud_server" "ansible" {
  count                    = var.server_count["ansible"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "ansible${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cx11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "ansible"
    terraform = true
  }
  public_net {
    ipv4 = hcloud_primary_ip.ansible_primary_ipv4[count.index].id
    ipv6 = hcloud_primary_ip.ansible_primary_ipv6[count.index].id
  }

  ssh_keys = concat(
    [hcloud_ssh_keys.user_ssh_keys.ssh_keys],
    [hcloud_ssh_key.terraform_ssh.name]
  )

  connection {
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.terraform_ssh.private_key_openssh
    host        = self.ipv6_address
  }

  provisioner "file" {
    content     = tls_private_key.terraform_ssh.private_key_openssh
    destination = "/root/.ssh/terraform_key"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod --verbose 600 /root/.ssh/terraform_key",
    ]
  }
}

resource "hcloud_server_network" "ansible_ansible_network" {
  count      = length(hcloud_server.ansible)
  server_id  = hcloud_server.ansible[count.index].id
  network_id = hcloud_network.ansible_network.id
}