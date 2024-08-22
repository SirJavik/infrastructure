######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: puppet.tf
# Description: Puppet server configuration
# Version: 1.0.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-08-20
# Last Modified: 2024-08-20
# Changelog: 
# 1.0.0 - Initial version

module "puppet" {
  source        = "gitlab.com/Javik/terraform-hcloud-modules/vserver"
  version       = "> 1.0.0"
  service_count = 1

  name_prefix = "puppet"
  domain      = module.globals.domain
  type        = "cx22"
  environment = module.globals.environment
  network_id  = module.network.network.id
  ssh_key_ids = module.globals.ssh_key_ids
  subnet      = "10.0.70.0/24"

  additional_names = {
    "puppet.sirjavik.de" = {
      proxy = false
    },
    "puppet.infra.sirjavik.de" = {
      proxy = false
    },
  }

  labels = {
    "managed_by"   = "terraform",
    "service_type" = "puppet",
    "ha"           = false,
    "ha_group"     = "puppet"
  }

  firewall_rules = [
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
  ]

  cloudflare_zones = module.globals.cloudflare_zones

  depends_on = [
    module.globals,
    module.network,
  ]
}
