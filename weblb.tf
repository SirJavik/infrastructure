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
## Loadbalancer
####

resource "hcloud_load_balancer" "loadbalancer" {
  count             = var.server_count["weblb"]
  delete_protection = false

  name = format("%s-%s.%s",
    "weblb${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de"
  )

  load_balancer_type = "lb11"
  location           = (count.index % 2 == 0 ? "fsn1" : "nbg1")

  labels = {
    service   = "loadbalancer"
    terraform = true
  }
}

####
## Network
####

resource "hcloud_load_balancer_network" "loadbalancer_network" {
  count = var.server_count["weblb"]

  load_balancer_id = hcloud_load_balancer.loadbalancer[count.index].id
  network_id       = hcloud_network.javikweb_network.id
  ip               = "10.10.40.${count.index + 1}"
}

####
## Targets
####

resource "hcloud_load_balancer_target" "loadbalancer_target_webserver" {
  count = var.server_count["weblb"]

  type           = "label_selector"
  label_selector = "service=webserver"

  load_balancer_id = hcloud_load_balancer.loadbalancer[count.index].id
  use_private_ip   = true

  depends_on = [
    hcloud_load_balancer_network.loadbalancer_network
  ]
}

####
## Services
####

resource "hcloud_load_balancer_service" "loadbalancer_service_http" {
  count = var.server_count["weblb"]

  load_balancer_id = hcloud_load_balancer.loadbalancer[count.index].id
  protocol         = "https"

  http {
    sticky_sessions = true
    cookie_name     = "EXAMPLE_STICKY"
    certificates = [
      for certificate in hcloud_uploaded_certificate.domain_certificate : certificate.id
    ]
  }

  #health_check {
  #  protocol = "http"
  #  port     = 443
  #  interval = 10
  #  timeout  = 5
  #
  #  http {
  #    domain       = "example.com"
  #    path         = "/healthz"
  #    response     = "OK"
  #    tls          = true
  #    status_codes = ["200"]
  #  }
  #}
}
