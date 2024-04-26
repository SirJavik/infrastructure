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

resource "hcloud_network" "network" {
  name     = (var.environment == "live" ? var.name : format("[%s] %s", title(var.environment), var.name))
  ip_range = var.ip_range

  labels = {
    "environment" = var.environment,
    "managed_by"  = "terraform"
  }
}