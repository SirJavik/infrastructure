######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

####
## Cloudflare Zones
####

data "cloudflare_zone" "domain_zone" {
  for_each = null_resource.domains
  name     = each.key
}

####
## Mailserver
####

## DNS

resource "cloudflare_record" "mailserver_dns_ipv4" {
  count   = var.server_count["mailserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.mailserver[count.index].name
  value   = hcloud_primary_ip.mailserver_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "mailserver_dns_ipv6" {
  count   = var.server_count["mailserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.mailserver[count.index].name
  value   = "${hcloud_primary_ip.mailserver_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "mailserver_rdns_ipv4" {
  count         = var.server_count["mailserver"]
  primary_ip_id = hcloud_primary_ip.mailserver_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.mailserver_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.mailserver[count.index].name
}
resource "hcloud_rdns" "mailserver_rdns_ipv6" {
  count         = var.server_count["mailserver"]
  primary_ip_id = hcloud_primary_ip.mailserver_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.mailserver_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.mailserver[count.index].name
}

####
## Webserver
####

## DNS

resource "cloudflare_record" "webserver_dns_ipv4" {
  count   = var.server_count["webserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.webserver[count.index].name
  value   = hcloud_primary_ip.webserver_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "webserver_dns_ipv6" {
  count   = var.server_count["webserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.webserver[count.index].name
  value   = "${hcloud_primary_ip.webserver_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "webserver_rdns_ipv4" {
  count         = var.server_count["webserver"]
  primary_ip_id = hcloud_primary_ip.webserver_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.webserver_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.webserver[count.index].name
}
resource "hcloud_rdns" "webserver_rdns_ipv6" {
  count         = var.server_count["webserver"]
  primary_ip_id = hcloud_primary_ip.webserver_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.webserver_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.webserver[count.index].name
}

####
## Icinga
####

## DNS

resource "cloudflare_record" "icinga_dns_ipv4" {
  count   = var.server_count["icinga"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.icinga[count.index].name
  value   = hcloud_primary_ip.icinga_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "icinga_dns_ipv6" {
  count   = var.server_count["icinga"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.icinga[count.index].name
  value   = "${hcloud_primary_ip.icinga_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "icinga_rdns_ipv4" {
  count         = var.server_count["icinga"]
  primary_ip_id = hcloud_primary_ip.icinga_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.icinga_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.icinga[count.index].name
}

resource "hcloud_rdns" "icinga_rdns_ipv6" {
  count         = var.server_count["icinga"]
  primary_ip_id = hcloud_primary_ip.icinga_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.icinga_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.icinga[count.index].name
}

####
## Loadbalancer
####

## DNS

resource "cloudflare_record" "loadbalancer_dns_ipv4" {
  count   = var.server_count["loadbalancer"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.loadbalancer[count.index].name
  value   = hcloud_primary_ip.loadbalancer_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "loadbalancer_dns_ipv6" {
  count   = var.server_count["loadbalancer"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.loadbalancer[count.index].name
  value   = "${hcloud_primary_ip.loadbalancer_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "loadbalancer_rdns_ipv4" {
  count         = var.server_count["loadbalancer"]
  primary_ip_id = hcloud_primary_ip.loadbalancer_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.loadbalancer_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.loadbalancer[count.index].name
}
resource "hcloud_rdns" "loadbalancer_rdns_ipv6" {
  count         = var.server_count["loadbalancer"]
  primary_ip_id = hcloud_primary_ip.loadbalancer_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.loadbalancer_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.loadbalancer[count.index].name
}

####
## Floating IP
####

## DNS

resource "cloudflare_record" "floating-loadbalancer_dns_ipv4" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "loadbalancing-ha"
  value   = hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "floating-loadbalancer_dns_ipv6" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "loadbalancing-ha"
  value   = "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "web-floating-loadbalancer_dns_ipv4" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "web-ha"
  value   = hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "web-floating-loadbalancer_dns_ipv6" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "web-ha"
  value   = "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "storage-floating-loadbalancer_dns_ipv4" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "storage-ha"
  value   = hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "storage-floating-loadbalancer_dns_ipv6" {
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = "storage-ha"
  value   = "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "floating-loadbalancer_rdns_ipv4" {
  floating_ip_id = hcloud_floating_ip.loadbalancer_floating_v4[0].id
  ip_address     = hcloud_floating_ip.loadbalancer_floating_v4[0].ip_address
  dns_ptr        = "loadbalancing-ha.sirjavik.de"
}
resource "hcloud_rdns" "floating-loadbalancer_rdns_ipv6" {
  floating_ip_id = hcloud_floating_ip.loadbalancer_floating_v6[0].id
  ip_address     = "${hcloud_floating_ip.loadbalancer_floating_v6[0].ip_address}1"
  dns_ptr        = "loadbalancing-ha.sirjavik.de"
}
