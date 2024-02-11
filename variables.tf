######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

variable "server_count" {
  type      = map(number)
  sensitive = false

  default = {
    "ansible"       = 1
    "webserver"     = 2
    "mailserver"    = 1
    "weblb"         = 1
    "storageserver" = 2
  }
}

variable "javikweb_network_ip_range" {
  type      = string
  sensitive = false

  default = "10.10.0.0/16"
}

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

variable "subdomains" {
  type      = list(string)
  sensitive = false

  default = [
    "grafana.sirjavik.de",
    "status.sirjavik.de",
    "pma.sirjavik.de",
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

variable "cloudflare_mail" {
  type      = string
  sensitive = false

  default = "bschneider97@t-online.de"
}

variable "cloudflare_default_ttl" {
  type      = number
  sensitive = false
  default   = 3600
}

variable "cloudflare_proxied_ttl" {
  type      = number
  sensitive = false
  default   = 1
}