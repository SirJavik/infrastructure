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
    for server in hcloud_load_balancer.load_balancer : server.name => {
      id       = server.id
      location = server.location
      name     = server.name
      ipv4     = server.ipv4
      ipv6     = server.ipv6
    }
  }

  services_list = [
    for service in var.services : service
  ]

  server_list = [
    for server in local.server : server
  ]
}