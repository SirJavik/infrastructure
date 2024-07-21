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
# Version: 1.3.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-26
# Last Modified: 2024-07-20
# Changelog: 
# 1.3.0 - Remove cloudflare zones data object
# 1.2.0 - Add dkim support
# 1.1.0 - Added terraform_data.atproto_domain_parts
# 1.0.0 - Initial version

resource "terraform_data" "domain_split" {
  for_each = toset(var.domains)

  triggers_replace = {
    parts = split(".", each.key)
  }
}

resource "terraform_data" "subdomain_split" {
  for_each = toset(var.subdomains)

  triggers_replace = {
    parts = split(".", each.key)
  }
}

resource "terraform_data" "atproto_split" {
  for_each = var.atproto

  triggers_replace = {
    parts = split(".", each.key)
  }
}

resource "terraform_data" "dkim_split" {
  for_each = var.dkim

  triggers_replace = {
    parts = split(".", each.key)
  }
}

resource "terraform_data" "domain_parts" {
  for_each = toset(var.domains)

  triggers_replace = {
    tld             = try(element(terraform_data.domain_split[each.key].triggers_replace.parts, length(terraform_data.domain_split[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.domain_split[each.key].triggers_replace.parts, length(terraform_data.domain_split[each.key].triggers_replace.parts) - 2), null)
    domain_with_tld = try(join(".", [element(terraform_data.domain_split[each.key].triggers_replace.parts, length(terraform_data.domain_split[each.key].triggers_replace.parts) - 2), element(terraform_data.domain_split[each.key].triggers_replace.parts, length(terraform_data.domain_split[each.key].triggers_replace.parts) - 1)]), null)
  }

}

resource "terraform_data" "subdomain_parts" {
  for_each = toset(var.subdomains)

  triggers_replace = {
    tld             = try(element(terraform_data.subdomain_split[each.key].triggers_replace.parts, length(terraform_data.subdomain_split[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.subdomain_split[each.key].triggers_replace.parts, length(terraform_data.subdomain_split[each.key].triggers_replace.parts) - 2), null)
    subdomain       = try(element(terraform_data.subdomain_split[each.key].triggers_replace.parts, length(terraform_data.subdomain_split[each.key].triggers_replace.parts) - 3), null)
    domain_with_tld = try(join(".", [element(terraform_data.subdomain_split[each.key].triggers_replace.parts, length(terraform_data.subdomain_split[each.key].triggers_replace.parts) - 2), element(terraform_data.subdomain_split[each.key].triggers_replace.parts, length(terraform_data.subdomain_split[each.key].triggers_replace.parts) - 1)]), null)
  }
}

resource "terraform_data" "atproto_domain_parts" {
  for_each = var.atproto

  triggers_replace = {
    payload         = each.value
    fulldomain      = each.key
    tld             = try(element(terraform_data.atproto_split[each.key].triggers_replace.parts, length(terraform_data.atproto_split[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.atproto_split[each.key].triggers_replace.parts, length(terraform_data.atproto_split[each.key].triggers_replace.parts) - 2), null)
    subdomain       = try(element(terraform_data.atproto_split[each.key].triggers_replace.parts, length(terraform_data.atproto_split[each.key].triggers_replace.parts) - 3), null)
    domain_with_tld = try(join(".", [element(terraform_data.atproto_split[each.key].triggers_replace.parts, length(terraform_data.atproto_split[each.key].triggers_replace.parts) - 2), element(terraform_data.atproto_split[each.key].triggers_replace.parts, length(terraform_data.atproto_split[each.key].triggers_replace.parts) - 1)]), null)
  }
}

resource "terraform_data" "dkim_domain_parts" {
  for_each = var.dkim

  triggers_replace = {
    payload         = each.value
    fulldomain      = each.key
    tld             = try(element(terraform_data.dkim_split[each.key].triggers_replace.parts, length(terraform_data.dkim_split[each.key].triggers_replace.parts) - 1), null)
    domain          = try(element(terraform_data.dkim_split[each.key].triggers_replace.parts, length(terraform_data.dkim_split[each.key].triggers_replace.parts) - 2), null)
    subdomain       = try(element(terraform_data.dkim_split[each.key].triggers_replace.parts, length(terraform_data.dkim_split[each.key].triggers_replace.parts) - 3), null)
    domain_with_tld = try(join(".", [element(terraform_data.dkim_split[each.key].triggers_replace.parts, length(terraform_data.dkim_split[each.key].triggers_replace.parts) - 2), element(terraform_data.dkim_split[each.key].triggers_replace.parts, length(terraform_data.dkim_split[each.key].triggers_replace.parts) - 1)]), null)
  }
}
