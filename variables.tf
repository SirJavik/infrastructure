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
    "ansible"    = 1
    "webserver"  = 2
    "mailserver" = 1
    "weblb"      = 1
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
    "volunteer.rocks"
  ]
}

variable "cloudflare_mail" {
  type      = string
  sensitive = false

  default = "bschneider97@t-online.de"
}
