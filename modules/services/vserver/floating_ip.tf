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
# Version: 1.1
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-06-08
# Last Modified: 2024-06-12
# Changelog: 
# 1.1 - Mutli dns support
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
  dns_ptr        = each.value.dns[0]
}

###################
###     DNS     ###
###################

data "cloudflare_zone" "floating_ip_dns_zone" {
  count = length(var.floating_ips) * length(local.floating_ip_dns)

  name = format("%s.%s",
    element(split(".", local.floating_ip_list[count.index % length(local.floating_ip_list)].dns[count.index % length(local.floating_ip_dns)]), length(split(".", local.floating_ip_list[count.index % length(local.floating_ip_list)].dns[count.index % length(local.floating_ip_dns)])) - 2),
    element(split(".", local.floating_ip_list[count.index % length(local.floating_ip_list)].dns[count.index % length(local.floating_ip_dns)]), length(split(".", local.floating_ip_list[count.index % length(local.floating_ip_list)].dns[count.index % length(local.floating_ip_dns)])) - 1)
  )
}

resource "cloudflare_record" "floating_ip_dns" {
  count = length(local.floating_ip_list) * length(local.floating_ip_dns)

  zone_id = data.cloudflare_zone.floating_ip_dns_zone[count.index % length(local.floating_ip_list)].id
  name    =  local.floating_ip_list[count.index % length(local.floating_ip_list)].dns[count.index % length(local.floating_ip_dns)]
  value   = (local.floating_ip_list[count.index % length(local.floating_ip_list)].type == "ipv4" ? local.hcloud_floating_ip[count.index % length(local.floating_ip_list)].ip_address : "${local.hcloud_floating_ip[count.index % length(local.floating_ip_list)].ip_address}1")
  type    = (local.floating_ip_list[count.index % length(local.floating_ip_list)].type == "ipv4" ? "A" : "AAAA")
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "Managed by Terraform"
}
