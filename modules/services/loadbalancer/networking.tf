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
  ip_range     = var.subnet
}

resource "hcloud_load_balancer_network" "loadbalancer_network" {
  count            = var.service_count
  load_balancer_id = hcloud_load_balancer.load_balancer[count.index].id
  subnet_id        = hcloud_network_subnet.loadbalancer_subnet.id
  ip               = "${substr(var.subnet, 0, length(var.subnet) - 5)}.${(count.index + 1) * 10}"

  depends_on = [
    hcloud_network_subnet.loadbalancer_subnet
  ]
}
