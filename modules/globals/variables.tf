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

variable "domain" {
  description = "The domain of the infrastructure"
  type        = string
  default     = "infra.sirjavik.de"
}

variable "locations" {
  description = "The locations of the infrastructure"
  type        = list(string)
  default     = ["fsn1", "nbg1"]
}

variable "environment" {
  description = "The environment of the infrastructure"
  type        = string
}

variable "domains" {
  description = "List of domains"
  type        = list(string)

  default = [
    "benjamin-schneider.com",
    "sirjavik.de",
    "javik.net",
    "javik.rocks",
    "mondbasis24.de",
    "undeadbrains.de",
    "volunteering.solutions",
    "volunteer.rocks",
    "volunteers.events"
  ]
}

variable "subdomains" {
  description = "List of subdomains"
  type        = list(string)

  default = [
    "www.benjamin-schneider.com",
    "www.sirjavik.de",
    "www.javik.net",
    "www.javik.rocks",
    "www.mondbasis24.de",
    "www.undeadbrains.de",
    "www.volunteering.solutions",
    "www.volunteer.rocks",
    "www.volunteers.events"
  ]
}
