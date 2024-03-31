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
  server = local.initServers

  loadbalancer_ipv4 = (length(hcloud_floating_ip.loadbalancer_floating_v4) > 0 ? hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address : hcloud_primary_ip.loadbalancer_primary_ipv4[0].ip_address)
  loadbalancer_ipv6 = (length(hcloud_floating_ip.loadbalancer_floating_v6) > 0 ? "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1" : hcloud_primary_ip.loadbalancer_primary_ipv6[0].ip_address)

  initServers = merge(
    { for server in hcloud_server.wireguard : server.name => { name = server.name, id = server.id, ipv4 = server.ipv4_address, ipv6 = server.ipv6_address, location = server.location, datacenter = server.datacenter, status = server.status } },
    { for server in hcloud_server.mailserver : server.name => { name = server.name, id = server.id, ipv4 = server.ipv4_address, ipv6 = server.ipv6_address, location = server.location, datacenter = server.datacenter, status = server.status } },
    { for server in hcloud_server.webserver : server.name => { name = server.name, id = server.id, ipv4 = server.ipv4_address, ipv6 = server.ipv6_address, location = server.location, datacenter = server.datacenter, status = server.status } },
    { for server in hcloud_server.icinga : server.name => { name = server.name, id = server.id, ipv4 = server.ipv4_address, ipv6 = server.ipv6_address, location = server.location, datacenter = server.datacenter, status = server.status } },
    { for server in hcloud_server.loadbalancer : server.name => { name = server.name, id = server.id, ipv4 = server.ipv4_address, ipv6 = server.ipv6_address, location = server.location, datacenter = server.datacenter, status = server.status } },
  )
}
