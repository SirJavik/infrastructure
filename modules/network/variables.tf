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
# Description: 
# Version: 1.0.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-07-20
# Changelog: 
# 1.0.0 - Initial version

variable "name" {
  type        = string
  description = "The name of the network"
  default     = "JavikWeb"
}

variable "ip_range" {
  type        = string
  description = "The IP range of the network"
  default     = "10.0.0.0/8"
}

variable "environment" {
  description = "The environment of the network"
  type        = string
}
