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

module "opensearch" {
  source        = "gitlab.com/Javik/terraform-hcloud-modules/vserver"
  version       = "> 1.5.9"
  service_count = 1

  name_prefix = "opensearch"
  domain      = module.globals.domain
  type        = "cx32"
  environment = module.globals.environment
  network_id  = module.network.network.id
  ssh_key_ids = module.globals.ssh_key_ids
  subnet      = "10.0.10.0/24"
  backups     = false
  protected   = true

  labels = {
    "managed_by"   = "terraform",
    "service_type" = "opensearch",
    "ha"           = false,
    "ha_group"     = "opensearch"
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
      port        = "443"
      description = "HTTPS"
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
