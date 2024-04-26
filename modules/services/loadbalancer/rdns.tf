######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: rdns.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version

resource "hcloud_rdns" "load_balancer_ipv4_rdns" {
  for_each         = local.server
  load_balancer_id = each.value.id
  ip_address       = each.value.ipv4
  dns_ptr          = each.value.name
}

resource "hcloud_rdns" "load_balancer_ipv6_rdns" {
  for_each         = local.server
  load_balancer_id = each.value.id
  ip_address       = each.value.ipv6
  dns_ptr          = each.value.name
}
