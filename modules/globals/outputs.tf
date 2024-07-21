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
# Version: 1.1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-07-20
# Changelog: 
# 1.1.0 - Add cloudflare_zones
# 1.0.0 - Initial version 

output "domain" {
  description = "The domain of the infrastructure"
  value       = var.domain
}

output "domains" {
  description = "List of domains"
  value       = var.domains
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
  value = concat(
    [hcloud_ssh_key.terraform.id],
    data.hcloud_ssh_keys.keys_by_selector.ssh_keys[*].id
  )
}

output "subdomains" {
  description = "List of subdomains"
  value       = var.subdomains
}

output "cloudflare_zones" {
  description = "The Cloudflare zones to use for the infrastructure"
  value       = var.cloudflare_zones
}
