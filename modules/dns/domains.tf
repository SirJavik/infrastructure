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
# Version: 1.1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-07-20
# Changelog:
# 1.1.0 - Remove cloudflare zones data object
# 1.0.0 - Initial version

resource "cloudflare_record" "domain_ipv4" {
  count = length(var.domains) * length(local.loadbalancer_list)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index % length(var.domains)
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = var.domains[count.index % length(var.domains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "A record for ${var.domains[count.index % length(var.domains)]}. Managed by Terraform."
}

resource "cloudflare_record" "domain_ipv6" {
  count = length(var.domains) * length(var.loadbalancer)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index % length(var.domains)
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = var.domains[count.index % length(var.domains)]
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "AAAA record for ${var.domains[count.index % length(var.domains)]}. Managed by Terraform."
}

resource "cloudflare_record" "wildcard_domain_ipv4" {
  count = length(var.domains) * length(local.loadbalancer_list)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index % length(var.domains)
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "*.${var.domains[count.index % length(var.domains)]}"
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "A record for *.${var.domains[count.index % length(var.domains)]}. Managed by Terraform."
}

resource "cloudflare_record" "wildcard_domain_ipv6" {
  count = length(var.domains) * length(var.loadbalancer)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index % length(var.domains)
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "*.${var.domains[count.index % length(var.domains)]}"
  value   = var.loadbalancer[local.loadbalancer_list[count.index % length(local.loadbalancer_list)]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
  comment = "AAAA record for *.${var.domains[count.index % length(var.domains)]}. Managed by Terraform."
}

