######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: zone.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-26
# Last Modified: 2024-04-26
# Changelog: 
# 1.0 - Initial version

resource "terraform_data" "parts" {
  for_each = var.servers

  triggers_replace = {
    parts           = split(".", each.value.name)
  }
}

resource "terraform_data" "domain_parts" {
  for_each = var.servers

  triggers_replace = {
    tld             = try(element(terraform_data.parts[each.key].triggers_replace.parts, length(terraform_data.parts[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.parts[each.key].triggers_replace.parts, length(terraform_data.parts[each.key].triggers_replace.parts) - 2), null)
    subdomain       = try(element(terraform_data.parts[each.key].triggers_replace.parts, length(terraform_data.parts[each.key].triggers_replace.parts) - 3), null)
    host            = try(element(terraform_data.parts[each.key].triggers_replace.parts, 0), null)
    domain_with_tld = try(join(".", [element(terraform_data.parts[each.key].triggers_replace.parts, length(terraform_data.parts[each.key].triggers_replace.parts) - 2), element(terraform_data.parts[each.key].triggers_replace.parts, length(terraform_data.parts[each.key].triggers_replace.parts) - 1)]), null)
  }
}

data "cloudflare_zone" "zone" {
  for_each = local.domains
  name     = each.key
}