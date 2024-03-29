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

resource "terraform_data" "setup_ansible" {
  count = var.server_count["ansible"]

  triggers_replace = {
    packages = [
      "ansible-core",
      "htop",
      "screen",
      "git"
    ]
    #repo = var.ansible_repo
    #key     = var.gitlab_ssh_key
    #keyfile = "/root/.ssh/id_ed25519"
  }

  connection {
    type        = "ssh"
    user        = "root"
    private_key = tls_private_key.terraform_ssh.private_key_openssh
    host        = hcloud_primary_ip.ansible_primary_ipv4[count.index].ip_address
  }

  provisioner "remote-exec" {
    inline = [
      #"mkdir /root/.ssh",
      #"echo \"Host gitlab.com\n    StrictHostKeyChecking no\n\n\" > /root/.ssh/config",
      #"chmod --verbose 600 ${self.triggers_replace.keyfile}",
      "apt-get install -y ${join(" ", self.triggers_replace.packages)}",
      #"git clone ${self.triggers_replace.repo}"
    ]
  }

  depends_on = [
    terraform_data.init_setup
  ]

}

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
  server_type = "cax11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "ansible"
    terraform = true
  }
  public_net {
    ipv4 = hcloud_primary_ip.ansible_primary_ipv4[count.index].id
    ipv6 = hcloud_primary_ip.ansible_primary_ipv6[count.index].id
  }

  placement_group_id = (count.index % 2 == 0 ? hcloud_placement_group.falkenstein-placement.id : hcloud_placement_group.nuernberg-placement.id)

  firewall_ids = [
    hcloud_firewall.default_firewall.id,
  ]

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.10.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )
}
