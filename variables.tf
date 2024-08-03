######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: variables.tf
# Description: Variables for the infrastructure
# Version: 1.0.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-08-03
# Last Modified: 2024-08-03
# Changelog: 
# 1.0.0 - Initial version

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  sensitive   = true
  type        = string
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  sensitive   = true
  type        = string
}
