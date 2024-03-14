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

resource "hcloud_network_subnet" "javikweb_network_ansible_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.10.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_webserver_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.20.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_mailserver_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.30.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_loadbalancer_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.40.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_storageserver_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.50.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_icinga_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.60.0/24"
}

resource "hcloud_network_subnet" "javikweb_network_storagelb_subnet" {
  network_id   = hcloud_network.javikweb_network.id
  type         = "cloud"
  network_zone = "eu-central"
  ip_range     = "10.10.70.0/24"
}
