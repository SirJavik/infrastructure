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
## Webserver
####

resource "hcloud_server" "icinga" {
  count                    = var.server_count["icinga"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "icinga${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cax11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "icinga"
    terraform = true
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.icinga_primary_ipv4[count.index].id
    ipv6         = hcloud_primary_ip.icinga_primary_ipv6[count.index].id
  }

  firewall_ids = [
    hcloud_firewall.default_firewall.id,
    hcloud_firewall.webserver_firewall.id
  ]

  placement_group_id = (count.index % 2 == 0 ? hcloud_placement_group.falkenstein-placement.id : hcloud_placement_group.nuernberg-placement.id)

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.60.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )

}
