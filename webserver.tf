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

/**
 * This Terraform configuration defines a resource block for creating an Hetzner Cloud server (hcloud_server) for the webserver.
 * It creates multiple instances of the server based on the value of the "server_count" variable.
 * The server instances are created with the following properties:
 *   - The server instances are named in the format "webstorageX.fsn1.infra.sirjavik.de" or "webstorageX.nbg1.infra.sirjavik.de", where X is the index of the instance.
 *   - The server instances use the "debian-12" image and "cpx21" server type.
 *   - The server instances are located in either "fsn1" or "nbg1" location based on the index.
 *   - The server instances have IPv4 and IPv6 enabled and use the primary IP addresses obtained from the "hcloud_primary_ip" resource.
 *   - The server instances are associated with the "webserver" service and have the "terraform" label.
 *   - The server instances are protected from deletion and rebuild.
 *   - The server instances are associated with the default firewall and the "webserver_firewall" firewall.
 *   - The server instances are placed in the "falkenstein-placement" or "nuernberg-placement" placement group based on the index.
 *   - The server instances are connected to the "javikweb_network" network and assigned IP addresses in the range "10.10.20.1" to "10.10.20.X", where X is the index.
 *   - The server instances are authenticated using SSH keys obtained from the "data.hcloud_ssh_keys" and "hcloud_ssh_key" resources.
 *   - The creation of the server instances depends on the availability of the "javikweb_network_webserver_subnet" subnet.
 */

resource "hcloud_server" "webserver" {
  count                    = var.server_count["webserver"]
  shutdown_before_deletion = true

  delete_protection  = false
  rebuild_protection = false

  name = format("%s-%s.%s",
    "webstorage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  image       = "debian-12"
  server_type = "cpx21"
  location    = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "webserver"
    terraform = true
  }

  public_net {
    ipv4_enabled = true
    ipv6_enabled = true
    ipv4         = hcloud_primary_ip.webserver_primary_ipv4[count.index].id
    ipv6         = hcloud_primary_ip.webserver_primary_ipv6[count.index].id
  }

  firewall_ids = [
    hcloud_firewall.default_firewall.id,
    hcloud_firewall.webserver_firewall.id
  ]

  placement_group_id = (count.index % 2 == 0 ? hcloud_placement_group.falkenstein-placement.id : hcloud_placement_group.nuernberg-placement.id)

  network {
    network_id = hcloud_network.javikweb_network.id
    ip         = "10.10.20.${count.index + 1}"
  }

  ssh_keys = concat(
    [for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name],
    [hcloud_ssh_key.terraform_ssh.name]
  )

  depends_on = [
    hcloud_network_subnet.javikweb_network_webserver_subnet
  ]
}
