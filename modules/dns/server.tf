######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: server.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-26
# Last Modified: 2024-04-26
# Changelog: 
# 1.0 - Initial version


resource "cloudflare_record" "ipv4_dns" {
  for_each = var.servers

  zone_id = data.cloudflare_zone.zone[terraform_data.domain_parts[each.key].triggers_replace.domain_with_tld].id
  name    = each.value.name
  value   = try(lookup(each.value, "ipv4"), lookup(each.value, "ipv4_address"))
  type    = "A"
  ttl     = 3600
}

resource "cloudflare_record" "ipv6_dns" {
  for_each = var.servers

  zone_id = data.cloudflare_zone.zone[terraform_data.domain_parts[each.key].triggers_replace.domain_with_tld].id
  name    = each.value.name
  value   = try(lookup(each.value, "ipv6"), lookup(each.value, "ipv6_address"))
  type    = "AAAA"
  ttl     = 3600
}
