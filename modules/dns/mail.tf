######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: mail.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-04-28
# Changelog: 
# 1.0 - Initial version

# Mailserver: w01c0755.kasserver.com

resource "cloudflare_record" "domain_mx" {
  count = length(var.domains)

  zone_id  = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name     = var.domains[count.index]
  value    = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_proxied_ttl
  comment  = "MX record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "subdomain_mx" {
  count = length(var.subdomains)

  zone_id  = data.cloudflare_zone.subdomain_zone[terraform_data.subdomain_parts[var.subdomains[count.index]].triggers_replace.domain_with_tld].id
  name     = var.subdomains[count.index]
  value    = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_proxied_ttl
  comment  = "MX record for ${var.subdomains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "wildcard_domain_mx" {
  count = length(var.domains)

  zone_id  = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name     = "*.${var.domains[count.index]}"
  value    = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_proxied_ttl
  comment  = "Wildcard MX record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "domain_dmarc" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = "_dmarc.${var.domains[count.index]}"
  value   = "v=DMARC1; p=quarantine; rua=mailto:${var.postmaster_email}; ruf=mailto:${var.postmaster_email}; fo=1:d:s;"
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "DMARC record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "domain_spf" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = var.domains[count.index]
  value   = "v=spf1 include:_spf.kasserver.com mx ?all"
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "SPF record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "domain_smtp" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = "smtp.${var.domains[count.index]}"
  value   = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_proxied_ttl
  comment = "SMTP record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "domain_imap" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = "imap.${var.domains[count.index]}"
  value   = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_proxied_ttl
  comment = "IMAP record for ${var.domains[count.index]}. Managed by Terraform"
}

resource "cloudflare_record" "domain_pop3" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = "pop3.${var.domains[count.index]}"
  value   = "w01c0755.kasserver.com" # For the moment until we migrate to own mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_proxied_ttl
  comment = "POP3 record for ${var.domains[count.index]}. Managed by Terraform"
}
