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
## JavikWeb
####

resource "hcloud_network" "javikweb_network" {
  name     = "JavikWeb-Network"
  ip_range = var.javikweb_network_ip_range

  labels = {
    service   = "javikweb_network",
    terraform = true
  }
}

resource "hcloud_network_subnet" "javikweb_network_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = var.javikweb_network_ip_range
}
