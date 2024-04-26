######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: main.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version

resource "hcloud_load_balancer" "load_balancer" {
  count = var.service_count
  name = (var.environment == "live" ? format("%s-%s.%s",
    "lb${count.index + 1}",
    (count.index % 2 == 0 ? var.locations[0] : var.locations[1]),
    var.domain
    ) : format("%s-%s-%s.%s",
    var.environment,
    "lb${count.index + 1}",
    (count.index % 2 == 0 ? var.locations[0] : var.locations[1]),
    var.domain
  ))

  load_balancer_type = var.type
  location           = (count.index % 2 == 0 ? var.locations[0] : var.locations[1])

  labels = {
    "environment" = var.environment,
    "managed_by"  = "terraform"
  }
}