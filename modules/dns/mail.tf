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
# Last Modified: 2024-04-27
# Changelog: 
# 1.0 - Initial version

resource "cloudflare_record" "domain_mx" {
  count = length(var.domains)

  zone_id  = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name     = var.domains[count.index]
  value    = "w01dd93a.kasserver.com" # For the moment until we migrate to own mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_proxied_ttl
  comment  = "MX record for ${var.domains[count.index]}, Managed by Terraform"
}

resource "cloudflare_record" "wildcard_domain_mx" {
  count = length(var.domains)

  zone_id  = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name     = "*.${var.domains[count.index]}"
  value    = "w01dd93a.kasserver.com" # For the moment until we migrate to own mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_proxied_ttl
  comment  = "Wildcard MX record for ${var.domains[count.index]}, Managed by Terraform"
}

resource "cloudflare_record" "domain_dmarc" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = "_dmarc.${var.domains[count.index]}"
  value   = "v=DMARC1; p=quarantine; rua=mailto:${var.postmaster_email}; ruf=mailto:${var.postmaster_email}; fo=1:d:s;"
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "DMARC record for ${var.domains[count.index]}, Managed by Terraform"
}

resource "cloudflare_record" "domain_spf" {
  count = length(var.domains)

  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index]].id
  name    = var.domains[count.index]
  value   = "v=spf1 include:_spf.kasserver.com mx ?all"
  type    = "TXT"
  ttl     = var.cloudflare_proxied_ttl
  comment = "SPF record for ${var.domains[count.index]}, Managed by Terraform"

}
