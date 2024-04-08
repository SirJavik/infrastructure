######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# This file contains the variable declarations for the JavikWeb infrastructure.

# The `server_count` variable is a map that specifies the number of servers for each component.
variable "server_count" {
  type      = map(number)
  sensitive = false

  default = {
    "wireguard"    = 1
    "webserver"    = 3
    "mailserver"   = 1
    "loadbalancer" = 2
    "icinga"       = 1
  }
}

# The `javikweb_network_ip_range` variable specifies the IP range for the JavikWeb network.
variable "javikweb_network_ip_range" {
  type      = string
  sensitive = false

  default = "10.10.0.0/16"
}

# The `domains` variable is a list of domain names used in the JavikWeb infrastructure.
variable "domains" {
  type      = list(string)
  sensitive = false

  default = [
    "sirjavik.de",
    "javik.net",
    "benjamin-schneider.com",
    "volunteer.rocks",
    "javik.rocks",
    "mondbasis24.de",
    "undeadbrains.de",
    "volunteering.solutions",
    "volunteers.events"
  ]
}

# The `subdomains` variable is a list of subdomain names used in the JavikWeb infrastructure.
# It represents the subdomains that will be associated with various services and websites.
# The list contains string values representing the subdomain names.
# The default value of the variable is a list of example subdomain names.
variable "subdomains" {
  type      = list(string)
  sensitive = false

  default = [
    "grafana.sirjavik.de",
    "status.sirjavik.de",
    "pma.sirjavik.de",
    "git.sirjavik.de",
    "phpmyadmin.sirjavik.de",
    "www.javik.net",
    "www.benjamin-schneider.com",
    "www.javik.rocks",
    "www.mondbasis24.de",
    "www.undeadbrains.de",
    "www.volunteering.solutions",
    "www.volunteers.events"
  ]
}

# The `gameservers` variable is a list of game server domain names used in the JavikWeb infrastructure.
variable "gameservers" {
  type      = list(string)
  sensitive = false

  default = [
    "test.minecraft.games.sirjavik.de",
    "minecraft.games.sirjavik.de",
    "satisfactory.games.sirjavik.de",
  ]
}

# The `cloudflare_mail` variable specifies the email address associated with Cloudflare.
/**
 * This variable represents the email address associated with the Cloudflare account.
 * It is used for configuring Cloudflare settings in the infrastructure.
 *
 * Type: string
 * Sensitive: false
 * Default: "bschneider97@t-online.de"
 */
variable "cloudflare_mail" {
  type      = string
  sensitive = false

  default = "bschneider97@t-online.de"
}

# The `cloudflare_default_ttl` variable specifies the default TTL (Time to Live) value for Cloudflare.
# This value determines how long Cloudflare will cache a resource before checking for updates from the origin server.
# The TTL is specified in seconds.
variable "cloudflare_default_ttl" {
  type      = number
  sensitive = false
  default   = 3600
}

# This variable represents the Time-to-Live (TTL) value for Cloudflare proxied records.
# It specifies the duration (in seconds) for which Cloudflare will cache the response from the origin server.
# The default value is 1 second.
variable "cloudflare_proxied_ttl" {
  type      = number
  sensitive = false
  default   = 1
}
