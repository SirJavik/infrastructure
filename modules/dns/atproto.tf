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
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-04-27
# Changelog: 
# 1.0 - Initial version

resource "cloudflare_record" "atproto_txt" {
  for_each = var.atproto

  zone_id = data.cloudflare_zone.atproto_zone[each.key].id
  name    = "_atproto.${each.key}"
  value   = each.value
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "For Bluesky. Managed by Terraform"
}
