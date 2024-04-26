######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: targets.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

resource "hcloud_load_balancer_target" "target" {
  count            = length(local.server)
  type             = "label_selector"
  load_balancer_id = local.server_list[count.index % length(local.server_list)].id
  use_private_ip   = var.targets_use_private_ip
  label_selector   = var.targets_label_selector

  depends_on = [
    hcloud_load_balancer_network.loadbalancer_network
  ]
}
