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
## Storageserver
####

resource "hcloud_server" "storageserver" {
  count                    = var.server_count["storageserver"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "storage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cx11"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "storageserver"
    terraform = true
  }

  public_net {
    ipv4_enabled = false
    ipv6_enabled = false
  }

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.50.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )

}
