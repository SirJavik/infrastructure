######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: locals.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

locals {
  server = {
    for server in hcloud_server.vserver : server.name => server
  }

  volumes_list = [
    for key, volume in var.volumes : {
      name = key,
      size = volume.size
    }
  ]

  server_list = [
    for server in local.server : server
  ]

  labels = merge({ environment = var.environment }, var.labels)
}
