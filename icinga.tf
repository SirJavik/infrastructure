######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: icinga.tf
# Description: Icinga configuration 
# Version: 1.0.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-08-03
# Last Modified: 2024-08-03
# Changelog: 
# 1.0.0 - Initial version

module "icinga" {
  source      = "gitlab.com/Javik/terraform-hcloud-modules/vserver"
  version     = "> 1.0.0"
  name_prefix = "icinga"

  service_count = 1
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids
  subnet        = "10.0.30.0/24"

  additional_names = {
    "icinga.sirjavik.de" = {
      override = false
      proxy    = false
    },

    "icingaweb.sirjavik.de" = {
      override = false
      proxy    = false
    }
  }

  labels = {
    "managed_by"   = "terraform",
    "service_type" = "icinga"
    "ha"           = false,
    "ha_group"     = "icinga"
    "ha_type"      = "none"
  }

  firewall_rules = [
    {
      direction   = "in"
      protocol    = "udp"
      port        = "51820-51830"
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
    }
  ]

  cloudflare_zones = module.globals.cloudflare_zones
  volumes = {
    "mysqldata" = {
      size = 10
    }
  }

  depends_on = [
    module.globals,
    module.network,
  ]
}
