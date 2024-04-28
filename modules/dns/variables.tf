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
# Date: 2024-04-26
# Last Modified: 2024-04-26
# Changelog: 
# 1.0 - Initial version

variable "servers" {
  description = "List of servers to create DNS records for"
  type        = any
}

variable "domains" {
  description = "List of domains to create DNS records for"
  type        = list(string)
  default     = []
}

variable "subdomains" {
  description = "List of subdomains to create DNS records for"
  type        = list(string)
  default     = []
}

variable "loadbalancer" {
  description = "List of loadbalancers names as cname for domains"
  type        = map(map(string))
}

variable "cloudflare_ttl" {
  description = "TTL for cloudflare records"
  type        = number
  default     = 3600
}

variable "cloudflare_proxied_ttl" {
  description = "TTL for cloudflare records with proxy"
  type        = number
  default     = 1
}

variable "postmaster_email" {
  description = "Email address for postmaster"
  type        = string
  default     = "admin@sirjavik.de"

}

variable "atproto" {
  description = "Domains for bluesky"
  type        = map(string)
  default     = {}
}
