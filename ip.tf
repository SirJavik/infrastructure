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
## Ansible Bastion
####

resource "hcloud_primary_ip" "ansible_primary_ipv4" {
  count = var.server_count["ansible"]

  name = format("%s-%s.%s-%s",
    "ansible${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "ansible_primary_ipv6" {
  count = var.server_count["ansible"]

  name = format("%s-%s.%s-%s",
    "ansible${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

####
## Mailserver
####

resource "hcloud_primary_ip" "mailserver_primary_ipv4" {
  count = var.server_count["mailserver"]

  name = format("%s-%s.%s-%s",
    "mail${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "mailserver_primary_ipv6" {
  count = var.server_count["mailserver"]

  name = format("%s-%s.%s-%s",
    "mail${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

####
## Webserver
####

resource "hcloud_primary_ip" "webserver_primary_ipv4" {
  count = var.server_count["webserver"]

  name = format("%s-%s.%s-%s",
    "web${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "webserver_primary_ipv6" {
  count = var.server_count["webserver"]

  name = format("%s-%s.%s-%s",
    "web${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

####
## Storageserver
####

resource "hcloud_primary_ip" "storageserver_primary_ipv4" {
  count = var.server_count["storageserver"]

  name = format("%s-%s.%s-%s",
    "storage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "storageserver_primary_ipv6" {
  count = var.server_count["storageserver"]

  name = format("%s-%s.%s-%s",
    "storage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

####
## Icinga
####

resource "hcloud_primary_ip" "icinga_primary_ipv4" {
  count = var.server_count["icinga"]

  name = format("%s-%s.%s-%s",
    "icinga${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "icinga_primary_ipv6" {
  count = var.server_count["icinga"]

  name = format("%s-%s.%s-%s",
    "icinga${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

####
## Loadbalancer
####

resource "hcloud_primary_ip" "loadbalancer_primary_ipv4" {
  count = var.server_count["loadbalancer"]

  name = format("%s-%s.%s-%s",
    "loadbalancer${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv4"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv4",
    terraform = true
  }
}

resource "hcloud_primary_ip" "loadbalancer_primary_ipv6" {
  count = var.server_count["loadbalancer"]

  name = format("%s-%s.%s-%s",
    "loadbalancer${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "ipv6"
  )

  datacenter    = (count.index % 2 == 0 ? "fsn1-dc14" : "nbg1-dc3")
  type          = "ipv6"
  assignee_type = "server"
  auto_delete   = false
  labels = {
    service   = "ipv6",
    terraform = true
  }
}

resource "hcloud_floating_ip" "loadbalancer_floating_v4" {
  count = (var.server_count["loadbalancer"] > 1 ? 1 : 0)
  type  = "ipv4"
  name = format("%s-%s.%s-%s",
    "loadbalancer${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "floating-ipv4"
  )
  home_location = (count.index % 2 == 0 ? "fsn1" : "nbg1")
  description   = "Loadbalancer Floating IPv4"
  labels = {
    service   = "ipv4",
    floating  = true
    terraform = true
  }
}

resource "hcloud_floating_ip" "loadbalancer_floating_v6" {
  count = (var.server_count["loadbalancer"] > 1 ? 1 : 0)
  type  = "ipv6"
  name = format("%s-%s.%s-%s",
    "loadbalancer${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "floating-ipv6"
  )
  home_location = (count.index % 2 == 0 ? "fsn1" : "nbg1")
  description   = "Loadbalancer Floating IPv6"
  labels = {
    service   = "ipv6",
    floating  = true
    terraform = true
  }
}
