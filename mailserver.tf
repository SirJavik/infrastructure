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
## Mailserver
####

resource "hcloud_server" "mailserver" {
  count                    = var.server_count["mailserver"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "mail${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cx11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "mailserver"
    terraform = true
  }

  public_net {
    ipv4 = hcloud_primary_ip.mailserver_primary_ipv4[count.index].id
    ipv6 = hcloud_primary_ip.mailserver_primary_ipv6[count.index].id
  }

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.30.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )

}

resource "hcloud_firewall_attachment" "mailserver_default_firewall" {
  firewall_id = hcloud_firewall.default_firewall.id
  server_ids  = [for server in hcloud_server.mailserver : server.id]
}

resource "hcloud_firewall_attachment" "mailserver_firewall" {
  firewall_id = hcloud_firewall.mailserver_firewall.id
  server_ids  = [for server in hcloud_server.mailserver : server.id]
}