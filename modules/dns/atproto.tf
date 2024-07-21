######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: atproto.tf
# Description: 
# Version: 1.1.1
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-07-20
# Changelog: 
# 1.1.1 - Remove cloudflare zones data object
# 1.0.0 - Initial version

resource "cloudflare_record" "atproto_txt" {
  for_each = terraform_data.atproto_domain_parts

  zone_id = var.cloudflare_zones[each.value.triggers_replace.domain_with_tld]
  name    = format("_atproto.%s", each.value.triggers_replace.fulldomain)
  value   = each.value.triggers_replace.payload
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "For Bluesky. Managed by Terraform"
}
