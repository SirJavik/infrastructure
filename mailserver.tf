######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: mailserver.tf
# Description: Mailserver configuration
# Version: 1.0.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-08-03
# Last Modified: 2024-08-03
# Changelog: 
# 1.0.0 - Initial version

module "mail" {
  source        = "gitlab.com/Javik/terraform-hcloud-modules/vserver"
  version       = "> 1.0.0"
  service_count = 1

  name_prefix = "mail"
  domain      = module.globals.domain
  type        = "cx32"
  environment = module.globals.environment
  network_id  = module.network.network.id
  ssh_key_ids = module.globals.ssh_key_ids
  subnet      = "10.0.40.0/24"

  labels = {
    "managed_by"   = "terraform",
    "service_type" = "mail",
    "ha"           = false,
    "ha_group"     = "mail"
  }

  firewall_rules = [
    {
      direction   = "in"
      protocol    = "udp"
      port        = "51820"
      description = "WireGuard"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "icmp"
      description = "icmp"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "22"
      description = "SSH"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "4190"
      description = "Sieve"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "110"
      description = "POP3"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "995"
      description = "POP3S"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "143"
      description = "IMAP"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "993"
      description = "IMAPS"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "25"
      description = "SMTP"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "465"
      description = "SMTPS"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "587"
      description = "SMTP"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "80"
      description = "HTTP"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "tcp"
      port        = "443"
      description = "HTTPS"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    },
    {
      direction   = "in"
      protocol    = "udp"
      port        = "60000-61000"
      description = "Mosh"
      source_ips = [
        "0.0.0.0/0",
        "::/0"
      ]
    }
  ]

  cloudflare_zones = module.globals.cloudflare_zones

  depends_on = [
    module.globals,
    module.network,
  ]
}

module "mailng" {
  source        = "gitlab.com/Javik/terraform-hcloud-modules/vserver"
  version       = "> 1.0.0"
  service_count = 0

  name_prefix = "mailng"
  domain      = module.globals.domain
  type        = "cx32"
  environment = module.globals.environment
  network_id  = module.network.network.id
  ssh_key_ids = module.globals.ssh_key_ids
  subnet      = "10.0.60.0/24"

  labels = {
    "managed_by"   = "terraform",
    "service_type" = "mail",
    "ha"           = true,
    "ha_group"     = "mail"
    "ha_type"      = "floating"
  }

  floating_ips = {
    #    "mail_ipv4" = {
    #      type = "ipv4"
    #      dns = [
    #        "mail-ha.sirjavik.de",
    #        "mx.sirjavik.de",
    #      ]
    #      description = "Mail HA"
    #      location    = "fsn1"
    #      proxy       = false
    #    },

    #    "mail_ipv6" = {
    #      type = "ipv6"
    #      dns = [
    #        "mail-ha.sirjavik.de",
    #        "mx.sirjavik.de",
    #      ]
    #      description = "Mail HA"
    #      location    = "fsn1"
    #      proxy       = false
    #    }
  }

  firewall_rules = [
    #    {
    #      direction   = "in"
    #      protocol    = "icmp"
    #      description = "icmp"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "22"
    #      description = "SSH"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "4190"
    #      description = "Sieve"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "110"
    #      description = "POP3"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "995"
    #      description = "POP3S"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "143"
    #      description = "IMAP"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "993"
    #      description = "IMAPS"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "25"
    #      description = "SMTP"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "465"
    #      description = "SMTPS"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "587"
    #      description = "SMTP"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "80"
    #      description = "HTTP"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "tcp"
    #      port        = "443"
    #      description = "HTTPS"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    },
    #    {
    #      direction   = "in"
    #      protocol    = "udp"
    #      port        = "60000-61000"
    #      description = "Mosh"
    #      source_ips = [
    #        "0.0.0.0/0",
    #        "::/0"
    #      ]
    #    }
  ]

  cloudflare_zones = module.globals.cloudflare_zones

  volumes = {
    "dockerdata" = {
      size = 100
    }
  }

  depends_on = [
    module.globals,
    module.network,
  ]
}

output "volumes" {
  value = module.mailng.volumes
}

output "volume_list" {
  value = module.mailng.volumes_list
}

output "server_list" {
  value = module.mailng.server_list

}
