######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: outputs.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

output "domain" {
  description = "The domain of the infrastructure"
  value       = var.domain
}

output "locations" {
  description = "The locations of the infrastructure"
  value       = var.locations
}

output "environment" {
  description = "The environment of the infrastructure"
  value       = var.environment
}

output "ssh_key_ids" {
  value = [
    hcloud_ssh_key.terraform.id
  ]
}
