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
## Wireguard
####

resource "hcloud_server" "wireguard" {
  count                    = var.server_count["wireguard"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "wireguard${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cx11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "wireguard"
    terraform = true
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.wireguard_primary_ipv4[count.index].id
    ipv6         = hcloud_primary_ip.wireguard_primary_ipv6[count.index].id
  }

  firewall_ids = [
    hcloud_firewall.default_firewall.id,
    hcloud_firewall.wireguard_firewall.id
  ]

  placement_group_id = (count.index % 2 == 0 ? hcloud_placement_group.falkenstein-placement.id : hcloud_placement_group.nuernberg-placement.id)

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.10.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )

  depends_on = [
    hcloud_network_subnet.javikweb_network_wireguard_subnet
  ]
}
