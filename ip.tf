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

