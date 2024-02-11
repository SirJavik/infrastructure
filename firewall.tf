######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################  

# Allows just pings and ssh
resource "hcloud_firewall" "default_firewall" {
  name = "default-firewall"

  labels = {
    service   = "firewall"
    serviceOf = "default"
    terraform = true
  }
  rule {
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "Ping"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "SSH"
  }
}

resource "hcloud_firewall" "webserver_firewall" {
  name = "webserver-firewall"

  labels = {
    service   = "firewall"
    serviceOf = "webserver"
    terraform = true
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "HTTPS"
  }
}

resource "hcloud_firewall" "mailserver_firewall" {
  name = "mailserver-firewall"

  labels = {
    service   = "firewall"
    serviceOf = "mailserver"
    terraform = true
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "80"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "HTTP"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "443"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "HTTPS"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "110"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "POP"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "995"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "POPS"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "143"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "IMAP"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "993"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "IMAPS"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "25"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "SMTP"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "465"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "SMTPS"
  }

  rule {
    direction = "in"
    protocol  = "tcp"
    port      = "587"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
    description = "StartTLS"
  }
}
