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
# Last Modified: 2024-04-27
# Changelog: 
# 1.0 - Initial version

resource "terraform_data" "parts" {
  for_each = var.servers

  triggers_replace = {
    parts = split(".", each.value.name)
  }
}

resource "terraform_data" "subparts" {
  for_each = toset(var.subdomains)

  triggers_replace = {
    parts = split(".", each.key)
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

resource "terraform_data" "subdomain_parts" {
  for_each = toset(var.subdomains)

  triggers_replace = {
    tld             = try(element(terraform_data.subparts[each.key].triggers_replace.parts, length(terraform_data.subparts[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.subparts[each.key].triggers_replace.parts, length(terraform_data.subparts[each.key].triggers_replace.parts) - 2), null)
    subdomain       = try(element(terraform_data.subparts[each.key].triggers_replace.parts, length(terraform_data.subparts[each.key].triggers_replace.parts) - 3), null)
    domain_with_tld = try(join(".", [element(terraform_data.subparts[each.key].triggers_replace.parts, length(terraform_data.subparts[each.key].triggers_replace.parts) - 2), element(terraform_data.subparts[each.key].triggers_replace.parts, length(terraform_data.subparts[each.key].triggers_replace.parts) - 1)]), null)
  }
}

data "cloudflare_zone" "server_zone" {
  for_each = local.server_domains
  name     = each.key
}

data "cloudflare_zone" "domain_zone" {
  for_each = toset(var.domains)
  name     = each.key
}

data "cloudflare_zone" "subdomain_zone" {
  for_each = local.subdomains
  name     = each.key
}

data "cloudflare_zone" "atproto_zone" {
  for_each = var.atproto
  name     = each.key
}
