######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: domains.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-04-27
# Changelog: 
# 1.0 - Initial version

resource "cloudflare_record" "domain_ipv4" {
  count = length(var.domains) * length(local.loadbalancer_list)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = var.domains[count.index % length(var.domains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "domain_ipv6" {
  count = length(var.domains) * length(var.loadbalancer)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = var.domains[count.index % length(var.domains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}
