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
# Version: 1.1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-07-20
# Changelog: 
# 1.1.0 - Add cloudflare_zones
# 1.0.0 - Initial version 

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
    "benny003.de",
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
    "www.benny003.de",
    "www.javik.net",
    "www.javik.rocks",
    "www.mondbasis24.de",
    "www.undeadbrains.de",
    "www.volunteering.solutions",
    "www.volunteer.rocks",
    "www.volunteers.events"
  ]
}

variable "cloudflare_zones" {
  description = "The Cloudflare zones to use for the network"
  type        = map(string)
  default = {
    "benjamin-schneider.com" = "8b369cb9262cc7f1aaeeef4af6fe5cbf",
    "javik.rocks"            = "8abb36e2012f6b133d76df6cf87b7753",
    "sirjavik.de"            = "d1ad53d186c62b1c21c7c7572efd8c0f",
    "volunteering.solutions" = "517f6a049ccac5b28896ee4f3975e057",
    "volunteers.events"      = "2dc7a7e9b010b94cf8c0698fc0433717",
    "volunteer.rocks"        = "d8663feb3dd23536c29c7254445e9d19",
    "javik.net"              = "2fc554c6e2f1b0b436dfe108aab4391a",
    "mondbasis24.de"         = "54ede00ad9117a57c27bb69eed67b4de",
    "undeadbrains.de"        = "a0c43658e705798318f5248a9f3e1177",
    "benny003.de"            = "89eea9aec8808cb255f2bef6cd700c21",
  }
}
