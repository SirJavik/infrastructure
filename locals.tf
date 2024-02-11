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
    {for server in hcloud_server.ansible: server.name => server.ipv4_address},
    {for server in hcloud_server.mailserver: server.name => server.ipv4_address},
    {for server in hcloud_server.webserver: server.name => server.ipv4_address},
    {for server in hcloud_server.storageserver: server.name => server.ipv4_address}
  )
}
