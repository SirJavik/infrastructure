######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

resource "cloudflare_record" "domain_dns_ipv4" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "sirjavik.de" || var.domains[count.index] == "volunteer.rocks" ? "demo.${var.domains[count.index]}" : "${var.domains[count.index]}")
  value   = local.loadbalancer_ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "domain_dns_ipv6" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "sirjavik.de" || var.domains[count.index] == "volunteer.rocks" ? "demo.${var.domains[count.index]}" : "${var.domains[count.index]}")
  value   = local.loadbalancer_ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "wildcard_domain_dns_ipv4" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "sirjavik.de" || var.domains[count.index] == "volunteer.rocks" ? "*.demo.${var.domains[count.index]}" : "*.${var.domains[count.index]}")
  value   = local.loadbalancer_ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "wildcard_domain_dns_ipv6" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "sirjavik.de" || var.domains[count.index] == "volunteer.rocks" ? "*.demo.${var.domains[count.index]}" : "*.${var.domains[count.index]}")
  value   = local.loadbalancer_ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "terraform_data" "subdomains" {
  count = length(var.subdomains)

  triggers_replace = {
    domain    = join(".", slice(split(".", var.subdomains[count.index]), length(split(".", var.subdomains[count.index])) - 2, length(split(".", var.subdomains[count.index]))))
    subdomain = join(".", slice(split(".", var.subdomains[count.index]), 0, length(split(".", var.subdomains[count.index])) - 2))
    lbv4      = local.loadbalancer_ipv4
    lbv6      = local.loadbalancer_ipv6
  }
}

resource "cloudflare_record" "subdomains_domain_dns_ipv4" {
  count   = length(terraform_data.subdomains)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.subdomains[count.index].triggers_replace.domain].id
  name    = "${terraform_data.subdomains[count.index].triggers_replace.subdomain}.${terraform_data.subdomains[count.index].triggers_replace.domain}"
  value   = terraform_data.subdomains[count.index].triggers_replace.lbv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true

}

resource "cloudflare_record" "subdomains_domain_dns_ipv6" {
  count   = length(terraform_data.subdomains)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.subdomains[count.index].triggers_replace.domain].id
  name    = "${terraform_data.subdomains[count.index].triggers_replace.subdomain}.${terraform_data.subdomains[count.index].triggers_replace.domain}"
  value   = terraform_data.subdomains[count.index].triggers_replace.lbv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true

}
