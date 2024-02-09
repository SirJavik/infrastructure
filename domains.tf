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
  count   = length(var.domains) * var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index % length(var.domains)] == "sirjavik.de" || var.domains[count.index % length(var.domains)] == "volunteer.rocks" ? "demo.${var.domains[count.index % length(var.domains)]}" : "${var.domains[count.index % length(var.domains)]}")
  value   = hcloud_load_balancer.loadbalancer[count.index % var.server_count["weblb"]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "domain_dns_ipv6" {
  count   = length(var.domains) * var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index % length(var.domains)] == "sirjavik.de" || var.domains[count.index % length(var.domains)] == "volunteer.rocks" ? "demo.${var.domains[count.index % length(var.domains)]}" : "${var.domains[count.index % length(var.domains)]}")
  value   = hcloud_load_balancer.loadbalancer[count.index % var.server_count["weblb"]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "wildcard_domain_dns_ipv4" {
  count   = length(var.domains) * var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index % length(var.domains)] == "sirjavik.de" || var.domains[count.index % length(var.domains)] == "volunteer.rocks" ? "*.demo.${var.domains[count.index % length(var.domains)]}" : "*.${var.domains[count.index % length(var.domains)]}")
  value   = hcloud_load_balancer.loadbalancer[count.index % var.server_count["weblb"]].ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

resource "cloudflare_record" "wildcard_domain_dns_ipv6" {
  count   = length(var.domains) * var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index % length(var.domains)] == "sirjavik.de" || var.domains[count.index % length(var.domains)] == "volunteer.rocks" ? "*.demo.${var.domains[count.index % length(var.domains)]}" : "*.${var.domains[count.index % length(var.domains)]}")
  value   = hcloud_load_balancer.loadbalancer[count.index % var.server_count["weblb"]].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

#resource "cloudflare_record" "domain_dns_ipv4" {
#  for_each = null_resource.domains
#  zone_id = data.cloudflare_zone.domain_zone[each.key].id
#  name    = (each.key == "sirjavik.de" || each.key == "volunteer.rocks" ? "demo.${each.key}" : each.key)
#  value   = hcloud_load_balancer.loadbalancer[0].ipv4
#  type    = "A"
#  ttl     = var.cloudflare_proxied_ttl
#  proxied = true
#}

#resource "cloudflare_record" "domain_dns_ipv6" {
#  for_each = null_resource.domains
#  zone_id = data.cloudflare_zone.domain_zone[each.key].id
#  name    = (each.key == "sirjavik.de" || each.key == "volunteer.rocks" ? "*.demo.${each.key}" : "*.${each.key}")
#  value   = hcloud_load_balancer.loadbalancer[0].ipv6
#  type    = "AAAA"
#  ttl     = var.cloudflare_proxied_ttl
#  proxied = true
#}