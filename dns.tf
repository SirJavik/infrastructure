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
## Ansible
####

## DNS

resource "cloudflare_record" "ansible_dns_ipv4" {
  count   = var.server_count["ansible"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.ansible[count.index].name
  value   = hcloud_primary_ip.ansible_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "ansible_dns_ipv6" {
  count   = var.server_count["ansible"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.ansible[count.index].name
  value   = "${hcloud_primary_ip.ansible_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "ansible_rdns_ipv4" {
  count         = var.server_count["ansible"]
  primary_ip_id = hcloud_primary_ip.ansible_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.ansible_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.ansible[count.index].name
}
resource "hcloud_rdns" "ansible_rdns_ipv6" {
  count         = var.server_count["ansible"]
  primary_ip_id = hcloud_primary_ip.ansible_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.ansible_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.ansible[count.index].name
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
## Loadbalancer
####

## DNS

resource "cloudflare_record" "loadbalancer_dns_ipv4" {
  count   = var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_load_balancer.loadbalancer[count.index].name
  value   = hcloud_load_balancer.loadbalancer[count.index].ipv4
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "loadbalancer_dns_ipv6" {
  count   = var.server_count["weblb"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_load_balancer.loadbalancer[count.index].name
  value   = hcloud_load_balancer.loadbalancer[count.index].ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "loadbalancer_rdns_ipv4" {
  count            = var.server_count["weblb"]
  load_balancer_id = hcloud_load_balancer.loadbalancer[count.index].id
  ip_address       = hcloud_load_balancer.loadbalancer[count.index].ipv4
  dns_ptr          = hcloud_load_balancer.loadbalancer[count.index].name
}

resource "hcloud_rdns" "loadbalancer_rdns_ipv6" {
  count            = var.server_count["weblb"]
  load_balancer_id = hcloud_load_balancer.loadbalancer[count.index].id
  ip_address       = hcloud_load_balancer.loadbalancer[count.index].ipv6
  dns_ptr          = hcloud_load_balancer.loadbalancer[count.index].name
}

########################################################
####                 !!ATTENTION!!                  ####
#### DIRTY FIX                                      ####
#### SHOULD BE REPLACED WITH OWN DNS RESOLVER LATER ####
########################################################

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
## Storage Server
####

## DNS

resource "cloudflare_record" "storageserver_dns_ipv4" {
  count   = var.server_count["storageserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.storageserver[count.index].name
  value   = hcloud_primary_ip.storageserver_primary_ipv4[count.index].ip_address
  type    = "A"
  ttl     = var.cloudflare_default_ttl
}

resource "cloudflare_record" "storageserver_dns_ipv6" {
  count   = var.server_count["storageserver"]
  zone_id = data.cloudflare_zone.domain_zone["sirjavik.de"].id
  name    = hcloud_server.storageserver[count.index].name
  value   = "${hcloud_primary_ip.storageserver_primary_ipv6[count.index].ip_address}1"
  type    = "AAAA"
  ttl     = var.cloudflare_default_ttl
}

## rDNS

resource "hcloud_rdns" "storageerver_rdns_ipv4" {
  count         = var.server_count["storageserver"]
  primary_ip_id = hcloud_primary_ip.storageserver_primary_ipv4[count.index].id
  ip_address    = hcloud_primary_ip.storageserver_primary_ipv4[count.index].ip_address
  dns_ptr       = hcloud_server.storageserver[count.index].name
}

resource "hcloud_rdns" "storageserver_rdns_ipv6" {
  count         = var.server_count["storageserver"]
  primary_ip_id = hcloud_primary_ip.storageserver_primary_ipv6[count.index].id
  ip_address    = hcloud_primary_ip.storageserver_primary_ipv6[count.index].ip_address
  dns_ptr       = hcloud_server.storageserver[count.index].name
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
