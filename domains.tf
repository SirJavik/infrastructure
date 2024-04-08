######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

/**
 * Creates a Cloudflare DNS record for each domain specified in the `var.domains` list.
 *
 * This resource creates an "A" record pointing to the IPv4 address of the local load balancer.
 * The record is proxied through Cloudflare and has a TTL (Time to Live) value specified by `var.cloudflare_proxied_ttl`.
 *
 * @resource cloudflare_record.domain_dns_ipv4
 * @param {string[]} var.domains - The list of domain names for which DNS records will be created.
 * @param {string} local.loadbalancer_ipv4 - The IPv4 address of the local load balancer.
 * @param {number} var.cloudflare_proxied_ttl - The TTL (Time to Live) value for the DNS records.
 */
resource "cloudflare_record" "domain_dns_ipv4" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "volunteer.rocks" ? "demo.${var.domains[count.index]}" : "${var.domains[count.index]}")
  value   = local.loadbalancer_ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * Creates a Cloudflare DNS record for each domain in the `var.domains` list.
 *
 * This resource creates an AAAA record for each domain, pointing to the IPv6 address of the local load balancer.
 * The record is proxied through Cloudflare and has a TTL (Time to Live) value specified by `var.cloudflare_proxied_ttl`.
 *
 * @resource cloudflare_record.domain_dns_ipv6
 * @param count - The number of domains in the `var.domains` list.
 * @param zone_id - The ID of the Cloudflare zone where the DNS record will be created.
 * @param name - The name of the DNS record. If the domain is "volunteer.rocks", the name will be "demo.volunteer.rocks". Otherwise, it will be the same as the domain.
 * @param value - The IPv6 address of the local load balancer.
 * @param type - The type of DNS record, which is "AAAA" for an IPv6 address.
 * @param ttl - The TTL (Time to Live) value for the DNS record.
 * @param proxied - Whether the DNS record is proxied through Cloudflare.
 */
resource "cloudflare_record" "domain_dns_ipv6" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "volunteer.rocks" ? "demo.${var.domains[count.index]}" : "${var.domains[count.index]}")
  value   = local.loadbalancer_ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * Creates a Cloudflare DNS record for wildcard domain with IPv4 address.
 *
 * This resource creates a Cloudflare DNS record for a wildcard domain with an IPv4 address. It uses the Cloudflare provider to manage the DNS record.
 *
 * Arguments:
 * - `count` (number): The number of wildcard domain DNS records to create. It is determined by the length of the `domains` variable.
 * - `zone_id` (string): The ID of the Cloudflare zone where the DNS record will be created. It is obtained from the `data.cloudflare_zone` data source using the `domain_zone` attribute.
 * - `name` (string): The name of the DNS record. It is determined based on the value of the `domains` variable. If the domain is "volunteer.rocks", the name will be "*.demo.volunteer.rocks". Otherwise, the name will be "*.<domain>".
 * - `value` (string): The IPv4 address to associate with the DNS record. It is obtained from the `local.loadbalancer_ipv4` local value.
 * - `type` (string): The type of the DNS record. In this case, it is set to "A" for an IPv4 address.
 * - `ttl` (number): The time-to-live (TTL) value for the DNS record. It is obtained from the `var.cloudflare_proxied_ttl` variable.
 * - `proxied` (bool): Indicates whether the DNS record should be proxied through Cloudflare's network. It is set to `true` to enable proxying.
 */
resource "cloudflare_record" "wildcard_domain_dns_ipv4" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "volunteer.rocks" ? "*.demo.${var.domains[count.index]}" : "*.${var.domains[count.index]}")
  value   = local.loadbalancer_ipv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * Creates a Cloudflare DNS record for wildcard domain with IPv6 address.
 *
 * This resource creates a Cloudflare DNS record for a wildcard domain with an IPv6 address.
 * It uses the `cloudflare_record` resource type to define the record.
 *
 * Arguments:
 * - `count`: The number of times to create the DNS record. It is based on the length of the `var.domains` list.
 * - `zone_id`: The ID of the Cloudflare zone where the DNS record will be created. It is obtained from the `data.cloudflare_zone` data source.
 * - `name`: The name of the DNS record. It is determined based on the value of `var.domains` and whether it matches "volunteer.rocks".
 * - `value`: The IPv6 address to associate with the DNS record. It is obtained from the `local.loadbalancer_ipv6` local value.
 * - `type`: The type of the DNS record. In this case, it is set to "AAAA" to indicate an IPv6 address.
 * - `ttl`: The time-to-live (TTL) value for the DNS record. It is obtained from the `var.cloudflare_proxied_ttl` variable.
 * - `proxied`: A boolean flag indicating whether the DNS record should be proxied through Cloudflare's network. It is set to `true`.
 */
resource "cloudflare_record" "wildcard_domain_dns_ipv6" {
  count   = length(var.domains)
  zone_id = data.cloudflare_zone.domain_zone[var.domains[count.index % length(var.domains)]].id
  name    = (var.domains[count.index] == "volunteer.rocks" ? "*.demo.${var.domains[count.index]}" : "*.${var.domains[count.index]}")
  value   = local.loadbalancer_ipv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * This resource block represents a Terraform data source that retrieves information about subdomains.
 * It uses the `count` parameter to create multiple instances of the data source based on the length of the `var.subdomains` list.
 * The `triggers_replace` block defines the triggers for the data source, including the domain, subdomain, and load balancer IP addresses.
 * 
 * Example usage:
 * 
 * resource "terraform_data" "subdomains" {
 *   count = length(var.subdomains)
 * 
 *   triggers_replace = {
 *     domain    = join(".", slice(split(".", var.subdomains[count.index]), length(split(".", var.subdomains[count.index])) - 2, length(split(".", var.subdomains[count.index]))))
 *     subdomain = join(".", slice(split(".", var.subdomains[count.index]), 0, length(split(".", var.subdomains[count.index])) - 2))
 *     lbv4      = local.loadbalancer_ipv4
 *     lbv6      = local.loadbalancer_ipv6
 *   }
 * }
 */
resource "terraform_data" "subdomains" {
  count = length(var.subdomains)

  triggers_replace = {
    domain    = join(".", slice(split(".", var.subdomains[count.index]), length(split(".", var.subdomains[count.index])) - 2, length(split(".", var.subdomains[count.index]))))
    subdomain = join(".", slice(split(".", var.subdomains[count.index]), 0, length(split(".", var.subdomains[count.index])) - 2))
    lbv4      = local.loadbalancer_ipv4
    lbv6      = local.loadbalancer_ipv6
  }
}

/**
 * Creates a Cloudflare DNS record for each subdomain specified in the `terraform_data.subdomains` list.
 *
 * This resource creates an "A" record with the specified subdomain and domain, pointing to the IPv4 address
 * specified in `terraform_data.subdomains[count.index].triggers_replace.lbv4`.
 *
 * The `zone_id` is obtained from the `data.cloudflare_zone.domain_zone` data source, using the domain name
 * specified in `terraform_data.subdomains[count.index].triggers_replace.domain`.
 *
 * The `ttl` (Time To Live) for the DNS record is set to the value specified in `var.cloudflare_proxied_ttl`.
 *
 * The `proxied` attribute is set to `true`, enabling Cloudflare's proxy service for the DNS record.
 */
resource "cloudflare_record" "subdomains_domain_dns_ipv4" {
  count   = length(terraform_data.subdomains)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.subdomains[count.index].triggers_replace.domain].id
  name    = "${terraform_data.subdomains[count.index].triggers_replace.subdomain}.${terraform_data.subdomains[count.index].triggers_replace.domain}"
  value   = terraform_data.subdomains[count.index].triggers_replace.lbv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * Creates a Cloudflare DNS record for each subdomain with an IPv6 address.
 *
 * This resource block creates a Cloudflare DNS record for each subdomain specified in the `terraform_data.subdomains` list.
 * The `count` parameter is used to iterate over each subdomain in the list.
 * The `zone_id` parameter is set to the ID of the Cloudflare zone where the DNS record will be created.
 * The `name` parameter is set to the full subdomain name, including the subdomain and domain name.
 * The `value` parameter is set to the IPv6 address of the subdomain.
 * The `type` parameter is set to "AAAA" to indicate an IPv6 address.
 * The `ttl` parameter is set to the value of the `var.cloudflare_proxied_ttl` variable.
 * The `proxied` parameter is set to true to enable Cloudflare proxying for the DNS record.
 */
resource "cloudflare_record" "subdomains_domain_dns_ipv6" {
  count   = length(terraform_data.subdomains)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.subdomains[count.index].triggers_replace.domain].id
  name    = "${terraform_data.subdomains[count.index].triggers_replace.subdomain}.${terraform_data.subdomains[count.index].triggers_replace.domain}"
  value   = terraform_data.subdomains[count.index].triggers_replace.lbv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = true
}

/**
 * This resource block represents a Terraform data source named "gameservers".
 * It retrieves information about game servers based on the provided input variables.
 *
 * The `count` argument is set to the length of the `var.gameservers` list, which determines the number of instances of this data source to create.
 *
 * The `triggers_replace` block contains several triggers that determine when the data source should be reloaded. These triggers include:
 *   - `domain`: The domain name extracted from the `var.gameservers` list.
 *   - `subdomain`: The subdomain name extracted from the `var.gameservers` list.
 *   - `lbv4`: The IPv4 address of a local load balancer.
 *   - `lbv6`: The IPv6 address of a local load balancer.
 *
 * Note: This code snippet assumes the presence of input variables `var.gameservers` and `local.loadbalancer_ipv4` and `local.loadbalancer_ipv6`.
 */
resource "terraform_data" "gameservers" {
  count = length(var.gameservers)

  triggers_replace = {
    domain    = join(".", slice(split(".", var.gameservers[count.index]), length(split(".", var.gameservers[count.index])) - 2, length(split(".", var.gameservers[count.index]))))
    subdomain = join(".", slice(split(".", var.gameservers[count.index]), 0, length(split(".", var.gameservers[count.index])) - 2))
    lbv4      = local.loadbalancer_ipv4
    lbv6      = local.loadbalancer_ipv6
  }
}

/**
 * Creates a Cloudflare DNS record for the game servers domain.
 *
 * This resource creates an A record in the Cloudflare DNS zone for the game servers domain.
 * The count parameter allows creating multiple DNS records based on the length of the `terraform_data.gameservers` list.
 *
 * @resource {cloudflare_record} gameservers_domain_dns_ipv4
 * @param {number} count - The number of game servers to create DNS records for.
 * @param {string} zone_id - The ID of the Cloudflare DNS zone.
 * @param {string} name - The fully qualified domain name (FQDN) for the DNS record.
 * @param {string} value - The IP address value for the DNS record.
 * @param {string} type - The type of DNS record (A record in this case).
 * @param {number} ttl - The time-to-live (TTL) value for the DNS record.
 * @param {boolean} proxied - Whether the DNS record is proxied through Cloudflare.
 */
resource "cloudflare_record" "gameservers_domain_dns_ipv4" {
  count   = length(terraform_data.gameservers)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.gameservers[count.index].triggers_replace.domain].id
  name    = "${terraform_data.gameservers[count.index].triggers_replace.subdomain}.${terraform_data.gameservers[count.index].triggers_replace.domain}"
  value   = terraform_data.gameservers[count.index].triggers_replace.lbv4
  type    = "A"
  ttl     = var.cloudflare_proxied_ttl
  proxied = false
}

/**
 * Creates a Cloudflare DNS record for the gameservers domain with an IPv6 address.
 *
 * This resource creates a Cloudflare DNS record for the gameservers domain using the provided IPv6 address.
 * The count parameter is used to create multiple DNS records based on the length of the `terraform_data.gameservers` list.
 *
 * @resource {cloudflare_record} gameservers_domain_dns_ipv6
 * @param {number} count - The number of DNS records to create.
 * @param {string} zone_id - The ID of the Cloudflare zone where the DNS record will be created.
 * @param {string} name - The fully qualified domain name (FQDN) for the DNS record.
 * @param {string} value - The IPv6 address for the DNS record.
 * @param {string} type - The type of DNS record (AAAA for IPv6).
 * @param {number} ttl - The time-to-live (TTL) value for the DNS record.
 * @param {boolean} proxied - Specifies whether the DNS record is proxied through Cloudflare.
 */
resource "cloudflare_record" "gameservers_domain_dns_ipv6" {
  count   = length(terraform_data.gameservers)
  zone_id = data.cloudflare_zone.domain_zone[terraform_data.gameservers[count.index].triggers_replace.domain].id
  name    = "${terraform_data.gameservers[count.index].triggers_replace.subdomain}.${terraform_data.gameservers[count.index].triggers_replace.domain}"
  value   = terraform_data.gameservers[count.index].triggers_replace.lbv6
  type    = "AAAA"
  ttl     = var.cloudflare_proxied_ttl
  proxied = false
}
