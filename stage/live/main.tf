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
# Last Modified: 2024-04-27
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

  targets_use_private_ip = true

  depends_on = [
    module.globals,
    module.network,
    module.webstorage
  ]
}

module "webstorage" {
  source        = "../../modules/services/vserver"
  service_count = 3
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids

  labels = {
    "loadbalancer" = "lb",
    "managed_by"   = "terraform"
  }

  volumes = {
    "wwwdata" = {
      size = 10
    },
    "mysqldata" = {
      size = 10
    }
  }

  depends_on = [
    module.globals,
    module.network,
  ]
}

module "mail" {
  source        = "../../modules/services/vserver" #
  name_prefix   = "mail"
  service_count = 1
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids
  subnet        = "10.0.40.0/24"

  labels = {
    "loadbalancer" = "maillb",
    "managed_by"   = "terraform"
  }

  volumes = {
    "maildata" = {
      size = 10
    }
  }

  depends_on = [
    module.globals,
    module.network,
  ]
}

module "icinga" {
  source        = "../../modules/services/vserver"
  name_prefix   = "icinga"
  service_count = 2
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids
  subnet        = "10.0.30.0/24"

  labels = {
    "managed_by" = "terraform"
  }

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

module "dns" {
  source = "../../modules/dns"

  servers = merge(
    module.loadbalancer.server,
    module.webstorage.server,
    module.icinga.server,
    module.mail.server
  )

  domains    = module.globals.domains
  subdomains = module.globals.subdomains

  loadbalancer = {
    for server in module.loadbalancer.server : server.name => {
      ipv4 = server.ipv4
      ipv6 = server.ipv6
    }
  }

  atproto = {
    "javik.rocks" = "did=did:plc:qe3p2rk7bswukxiwxbrjzwxn"
  }

  depends_on = [
    module.globals,
    module.webstorage,
    module.loadbalancer,
    module.icinga,
    module.mail
  ]
}
