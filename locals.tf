######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

locals {
  server = merge(
    { for server in hcloud_server.ansible : server.name => server.ipv4_address },
    { for server in hcloud_server.mailserver : server.name => server.ipv4_address },
    { for server in hcloud_server.webserver : server.name => server.ipv4_address },
    { for server in hcloud_server.storageserver : server.name => server.ipv4_address }
  )

  loadbalancer_ipv4 = (length(hcloud_floating_ip.loadbalancer_floating_v4) > 0 ? hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address : hcloud_primary_ip.loadbalancer_primary_ipv4[0].ip_address)
  loadbalancer_ipv6 = (length(hcloud_floating_ip.loadbalancer_floating_v6) > 0 ? "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1" : hcloud_primary_ip.loadbalancer_primary_ipv6[0].ip_address)
}
