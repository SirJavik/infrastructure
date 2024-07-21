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
# Version: 1.3.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-27
# Last Modified: 2024-07-20
# Changelog: 
# 1.3.0 - Own mailserver
# 1.2.0 - Remove cloudflare zones data object
# 1.1.0 - DKIM Support
# 1.0.1 - Better SPF record
# 1.0.0 - Initial version

resource "cloudflare_record" "domain_mx" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name     = var.domains[count.index]
  value    = var.mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_ttl
  comment  = "MX record for ${var.domains[count.index]}. Managed by Terraform"
  proxied  = false
}

resource "cloudflare_record" "subdomain_mx" {
  count = length(var.subdomains)

  zone_id = var.cloudflare_zones[
    terraform_data.subdomain_parts[
      var.subdomains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name     = var.subdomains[count.index]
  value    = var.mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_ttl
  comment  = "MX record for ${var.subdomains[count.index]}. Managed by Terraform"
  proxied  = false
}

resource "cloudflare_record" "wildcard_domain_mx" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name     = "*.${var.domains[count.index]}"
  value    = var.mailserver
  type     = "MX"
  priority = 10
  ttl      = var.cloudflare_ttl
  comment  = "Wildcard MX record for ${var.domains[count.index]}. Managed by Terraform"
  proxied  = false
}

resource "cloudflare_record" "domain_dmarc" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_dmarc.${var.domains[count.index]}"
  value   = "v=DMARC1; p=quarantine; rua=mailto:${var.postmaster_email}; ruf=mailto:${var.postmaster_email}; fo=1:d:s;"
  type    = "TXT"
  ttl     = var.cloudflare_ttl
  comment = "DMARC record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_spf" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = var.domains[count.index]
  value   = "v=spf1 mx a ?all"
  type    = "TXT"
  ttl     = var.cloudflare_ttl
  comment = "SPF record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_smtp" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "smtp.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "SMTP record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_imap" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "imap.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "IMAP record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_pop3" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "pop3.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "POP3 record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_mail" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "mail.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "Mail record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_autoconfig" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "autoconfig.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "Autoconfig record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_autodiscover" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "autodiscover.${var.domains[count.index]}"
  value   = var.mailserver
  type    = "CNAME"
  ttl     = var.cloudflare_ttl
  comment = "Autodiscover record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "domain_dkim" {
  for_each = terraform_data.dkim_domain_parts

  zone_id = var.cloudflare_zones[each.value.triggers_replace.domain_with_tld]
  name    = format("dkim._domainkey.%s", each.value.triggers_replace.fulldomain)
  value   = each.value.triggers_replace.payload
  type    = "TXT"
  ttl     = var.cloudflare_ttl
  comment = "For Bluesky. Managed by Terraform"
  proxied = false
}

resource "cloudflare_record" "autodiscover_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_autodiscover._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for autodiscover.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 443
    target   = var.mailserver
  }
}

resource "cloudflare_record" "caldavs_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_caldavs._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for caldavs.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 443
    target   = var.mailserver
  }

}

resource "cloudflare_record" "caldavs_txt" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_caldavs._tcp.${var.domains[count.index]}"
  type    = "TXT"
  ttl     = var.cloudflare_ttl
  comment = "TXT record for caldavs.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  value = "path=/SOGo/dav/"
}

resource "cloudflare_record" "carddavs_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_carddavs._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for carddavs.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 443
    target   = var.mailserver
  }
}

resource "cloudflare_record" "carddavs_txt" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_carddavs._tcp.${var.domains[count.index]}"
  type    = "TXT"
  ttl     = var.cloudflare_ttl
  comment = "TXT record for carddavs.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  value = "path=/SOGo/dav/"
}

resource "cloudflare_record" "imap_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_imap._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for imap.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 143
    target   = var.mailserver
  }
}

resource "cloudflare_record" "imaps_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_imaps._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for imaps.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 993
    target   = var.mailserver
  }
}

resource "cloudflare_record" "pop3_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_pop3._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for pop3.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 110
    target   = var.mailserver
  }
}

resource "cloudflare_record" "pop3s_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_pop3s._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for pop3s.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 995
    target   = var.mailserver
  }
}

resource "cloudflare_record" "sieve_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_sieve._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for sieve.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 4190
    target   = var.mailserver
  }
}

resource "cloudflare_record" "smtps_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_smtps._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for smtps.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 465
    target   = var.mailserver
  }
}

resource "cloudflare_record" "submission_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_submission._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for submission.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 587
    target   = var.mailserver
  }
}

resource "cloudflare_record" "submissions_srv" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_submissions._tcp.${var.domains[count.index]}"
  type    = "SRV"
  ttl     = var.cloudflare_ttl
  comment = "SRV record for submissions.${var.domains[count.index]}. Managed by Terraform"
  proxied = false

  data {
    priority = 0
    weight   = 1
    port     = 465
    target   = var.mailserver
  }
}

resource "cloudflare_record" "smtp_tlsa" {
  count = length(var.domains)

  zone_id = var.cloudflare_zones[
    terraform_data.domain_parts[
      var.domains[
        count.index
      ]
    ].triggers_replace.domain_with_tld
  ]
  name    = "_25._tcp.${var.domains[count.index]}"
  type    = "TLSA"
  ttl     = var.cloudflare_ttl
  comment = "TLSA record for ${var.domains[count.index]}. Managed by Terraform"
  proxied = false
  data {
    usage         = 3
    selector      = 1
    matching_type = 1
    certificate   = var.mailserver_tlsa
  }
}