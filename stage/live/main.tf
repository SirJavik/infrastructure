######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: main.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version

terraform {
  required_providers {

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.43"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.0"
    }
  }

  backend "http" {
  }
}

provider "hcloud" {
  # Maybe needed later
}

provider "cloudflare" {
  # Maybe needed later
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

module "globals" {
  source      = "../../modules/globals"
  environment = "live"
}

module "network" {
  source      = "../../modules/network"
  environment = module.globals.environment
}

module "loadbalancer" {
  source        = "../../modules/services/loadbalancer"
  type          = "lb11"
  service_count = 1
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id

  targets = [ 
    for server in module.webstorage.server : server.id
   ]

  depends_on = [
    module.globals,
    module.network,
    module.webstorage
  ]
}

module "webstorage" {
  source        = "../../modules/services/webstorage"
  service_count = 3
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids

  depends_on = [
    module.globals,
    module.network,
  ]
}
