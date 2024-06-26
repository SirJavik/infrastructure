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
# Version: 1.2
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-06-12
# Changelog: 
# 1.2 - Changed dns in floating_ip to list
# 1.1 - Added floating_ips variable
# 1.0 - Initial version 

variable "environment" {
  description = "The environment of the vserver"
  type        = string
}

variable "service_count" {
  description = "The number of vserver to create"
  type        = number
  default     = 3
}

variable "domain" {
  description = "The domain of the vserver"
  type        = string
}

variable "ssh_key_ids" {
  description = "The SSH key IDs to use for the vserver"
  type        = list(string)
}

variable "image" {
  description = "The image to use for the vserver"
  type        = string
  default     = "debian-12"
}

variable "type" {
  description = "The server type to use for the vserver"
  type        = string
  default     = "cx11"
}

variable "locations" {
  description = "The locations of the vserver"
  type        = list(string)
  default     = ["fsn1", "nbg1"]
}

variable "name_prefix" {
  description = "The name prefix of the vserver"
  type        = string
  default     = "webstorage"
}

variable "datacenters" {
  description = "The datacenters of the vserver"
  type        = list(string)
  default     = ["fsn1-dc14", "nbg1-dc3"]
}

variable "network_id" {
  description = "The network ID of the vserver"
  type        = number
}

variable "labels" {
  description = "The labels of the vserver"
  type        = map(string)
}

variable "subnet" {
  description = "The subnet of the vserver"
  type        = string
  default     = "10.0.20.0/24"
}

variable "volumes" {
  description = "The volumes of the vserver"
  type = map(object({
    size = number
  }))
  default = {}
}

variable "floating_ips" {
  description = "The floating IPs of the vserver"
  type = map(object({
    type        = string
    dns         = list(string)
    description = string
    location    = string
  }))
  default = {}
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
