######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: floating_ip.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-06-08
# Last Modified: 2024-06-08
# Changelog: 
# 1.0 - Initial version 

###################
### Floating IP ###
###################

resource "hcloud_floating_ip" "floating_ip" {
  for_each = var.floating_ips

  name = format("%s-%s",
    each.key,
    each.value.type,
  )

  type          = each.value.type
  description   = each.value.description
  home_location = each.value.location
}

###################
###    rDNS     ###
###################

resource "hcloud_rdns" "floating_ip_rdns" {
  for_each = var.floating_ips

  floating_ip_id = hcloud_floating_ip.floating_ip[each.key].id
  ip_address     = (each.value.type == "ipv4" ? hcloud_floating_ip.floating_ip[each.key].ip_address : "${hcloud_floating_ip.floating_ip[each.key].ip_address}1")
  dns_ptr        = each.value.dns
}

###################
###     DNS     ###
###################

data "cloudflare_zone" "floating_ip_dns_zone" {
  for_each = var.floating_ips
  name     = format("%s.%s", 
    element(split(".", each.value.dns), length(split(".", each.value.dns)) - 2), 
    element(split(".", each.value.dns), length(split(".", each.value.dns)) - 1)
  )
}

resource "cloudflare_record" "floating_ip_dns" {
  for_each = var.floating_ips

  zone_id = data.cloudflare_zone.floating_ip_dns_zone[each.key].id
  name    = each.value.dns
  value   = (each.value.type == "ipv4" ? hcloud_floating_ip.floating_ip[each.key].ip_address : "${hcloud_floating_ip.floating_ip[each.key].ip_address}1")
  type    = (each.value.type == "ipv4" ? "A" : "AAAA")
  ttl     = 1
}
