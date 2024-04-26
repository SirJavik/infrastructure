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
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

resource "hcloud_server" "webstorage" {
  count = var.service_count

  name = (var.environment == "live" ? format("%s-%s.%s",
    "webstorage${count.index + 1}",
    (count.index % 2 == 0 ? var.locations[0] : var.locations[1]),
    var.domain
    ) : format("%s-%s-%s.%s",
    var.environment,
    "webstorage${count.index + 1}",
    (count.index % 2 == 0 ? var.locations[0] : var.locations[1]),
    var.domain
  ))

  image       = var.image
  server_type = var.type
  location    = (count.index % 2 == 0 ? var.locations[0] : var.locations[1])
  ssh_keys    = var.ssh_key_ids
  user_data   = file("${path.module}/cloud-init.yml")

  labels = {
    "environment" = var.environment,
    "managed_by"  = "terraform"
  }
}