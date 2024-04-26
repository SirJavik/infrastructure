######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: networking.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version

resource "hcloud_network_subnet" "loadbalancer_subnet" {
  network_id   = var.network_id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.0.10.0/24"
}

resource "hcloud_load_balancer_network" "loadbalancer_network" {
  for_each         = local.server
  load_balancer_id = each.value.id
  subnet_id        = hcloud_network_subnet.loadbalancer_subnet.id
}
