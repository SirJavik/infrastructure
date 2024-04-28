######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: subdomain.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-28
# Last Modified: 2024-04-28
# Changelog: 
# 1.0 - Initial version

resource "cloudflare_record" "subdomain_ipv4" {
  count = length(var.subdomains) * length(local.loadbalancer_list)

  zone_id = data.cloudflare_zone.subdomain_zone[terraform_data.subdomain_parts[var.subdomains[count.index % length(var.subdomains)]].triggers_replace.domain_with_tld].id
  name    = var.subdomains[count.index % length(var.subdomains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "Managed by Terraform"
}

resource "cloudflare_record" "subdomain_ipv6" {
  count = length(var.subdomains) * length(var.loadbalancer)

  zone_id = data.cloudflare_zone.subdomain_zone[terraform_data.subdomain_parts[var.subdomains[count.index % length(var.subdomains)]].triggers_replace.domain_with_tld].id
  name    = var.subdomains[count.index % length(var.subdomains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "Managed by Terraform"
}
