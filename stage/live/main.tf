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
# Version: 1.3.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-07-20
# Changelog: 
# 1.3.0 - Add firewall
# 1.2.0 - Add dkim
# 1.1.0 - Support for floating ip multi dns
# 1.0.0 - Initial version

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

  firewall_name = "webstorage"
  firewall_rules = [
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

  firewall_name = "mail"
  firewall_rules = [
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
    }
  ]

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

  firewall_name = "icinga"
  firewall_rules = [
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

  volumes = {
    "mysqldata" = {
      size = 10
    }
  }

  floating_ips = {
    "icingaweb_v4" = {
      type = "ipv4"
      dns = [
        "icingaweb.sirjavik.de",
        "icinga.sirjavik.de",
        "monitoring.sirjavik.de"
      ]
      description = "Icinga Web"
      location    = "fsn1"
    },

    "icingaweb_v6" = {
      type = "ipv6"
      dns = [
        "icingaweb.sirjavik.de",
        "icinga.sirjavik.de",
        "monitoring.sirjavik.de"
      ]
      description = "Icinga Web"
      location    = "fsn1"
    }
  }

  depends_on = [
    module.globals,
    module.network,
  ]
}

module "dns" {
  source = "../../modules/dns"

  domains    = module.globals.domains
  subdomains = module.globals.subdomains

  loadbalancer = {
    for server in module.loadbalancer.server : server.name => {
      ipv4 = server.ipv4
      ipv6 = server.ipv6
    }
  }

  atproto = {
    "javik.rocks"     = "did=did:plc:qe3p2rk7bswukxiwxbrjzwxn",
    "dev.javik.rocks" = "did=did:plc:6ar6r5waxzs2xykii5gh6zbo",
    "javik.net"       = "did=did:plc:k3ltdspf7njfzg6um25uvvly"
  }

  dkim = {
    "benjamin-schneider.com" = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyHxG4Fux814i73UNv18IaWJQST8eYaUPefWi5wSw+5XMLv1T2Ue4bzTAqe2XB4EWIkJZGPYPwMfdwydgMzIjgi1Zt8lsWuqJA1s2zYNVk3hbBx5y4CC+JPvCL4D2FlTwspN/2gaDBsQfugAkPkOgp7F8MMidEF/77uXUYQ1+Iv39mCQj3Zw4tL/CJhUuVxHtOgARenUslK39U7dsiAdo5DNSCOMSu4tlkDMa9Fq9TEM0Dxo/Bj7R/hOcr1+uKrmAaHr2/E5zd4qrtYX0FhzerSIjuVInISpN3bER6RgQXIBAwHdqdW1cJNMHXehvd6NAPHZSuJ8VOcFKbOCYtRpXwQIDAQAB",
    "sirjavik.de"            = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqtHTTR8mom/IILxxLK+ES/ovE1uoa67Sq1Md70mBib/Sama1uAVua6GT3IG/cfElohGnLyPyo6UCWYrcUUxXYTS2qQ//PMcESKV2LDE4B2gIf5V9Aywsv18fGwWsFcMDYbSmF8tAa/rvV9nwDIyC+Q/3Q+dBzy6pmJ/bt8B3Nmjp89J3HPvsg6Fwh4yCYOZGCd2hkfvYf7/MLqntbp52Euh+vMu7RvWXYJLzMPVpQTFpyyVPulbG5Nb37JxFDgKQllsPsDS9o4yHkXpXaWeVgvanQ9t2QaQPCkY6tkVQ1DAFSRBYZtwqwZg2pt22lTk3Qg/NJsembfIxi9Dvg0SUtwIDAQAB",
    "undeadbrains.de"        = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxLEIaXlohNBPUZRWm4qrFGrH9hVFWz1Y7R8A5PjjhhbkUXKtpXD+77xLjw2RYztnCAQjLI1bLKH8DJ18Q6kW7jssru5pQ+7CpmlssPZbpoOzBGv3r4gDVh9nmA4qS70TW/w6pEGzpt7C9GaELxJACS8JWcVN21NKiJ/8JlvNBnfooj1mvn31cJ7VmKzLtk6PtE7Z175gi/13NciFe3YwRLNS0bvwiEtsOU9J/RaBcmMZNM4UQuvLACAlSpS2gb0V8AZ37V/l7QedE9mYM4YwhLjB5eLgQAwvXoBS8BeWyokvCfZLFOcRixFcMliTEku8gwmIDs5D/HUtqyHWM7tSOQIDAQAB",
    "javik.net"              = "v=DKIM1; k=rsa; p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwAoaC8C3MnQMF1b2GUwbrLtCxxRNtsdfYKsg3BXHtI8yFC//+k6ErWU8FITHxDh3+BIny4wJ2IVlscWvsZnJWM7q109cg2EjqFJ4M8s4SgFegMNIVtLnnvil62QNqTWjMRBCIqlYByWYxyhBXHh94r8ukxR5vOSHZ1TcDQ7ooYFERq/aAnbpz/Pyu8Pyy32a5T3MXNRPnXAtLDOBba7qTbYCz07hu89kyBExPUFXLdcfNUi0waQTKiNWXGFsQRJgMnW+nk0KWli63VWLw308WbwHaHYsCm8ZikBAIc1+a4T1mox1QrQiXA2RDh03jEjvw71X4BiW2JvpjV4qj5HkawIDAQAB"
  }

  depends_on = [
    module.globals,
    module.webstorage,
    module.loadbalancer,
    module.icinga,
    module.mail
  ]
}
