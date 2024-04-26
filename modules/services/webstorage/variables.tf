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
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

variable "environment" {
  description = "The environment of the webstorage"
  type        = string
}

variable "service_count" {
  description = "The number of webstorage to create"
  type        = number
  default     = 3
}

variable "domain" {
  description = "The domain of the webstorage"
  type        = string
}

variable "ssh_key_ids" {
  description = "The SSH key IDs to use for the webstorage"
  type        = list(string)
}

variable "image" {
  description = "The image to use for the webstorage"
  type        = string
  default     = "debian-12"
}

variable "type" {
  description = "The server type to use for the webstorage"
  type        = string
  default     = "cx11"
}

variable "locations" {
  description = "The locations of the webstorage"
  type        = list(string)
  default     = ["fsn1", "nbg1"]
}

variable "network_id" {
  description = "The network ID of the webstorage"
  type        = number
}
