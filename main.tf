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
# Version: 1.4.1
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-24
# Last Modified: 2024-07-21
# Changelog: 
# 1.4.1 - Set mailserver to cx32
# 1.4.0 - Add static cloudflare zones
# 1.3.0 - Add firewall
# 1.2.0 - Add dkim
# 1.1.0 - Support for floating ip multi dns
# 1.0.0 - Initial version

terraform {
  required_providers {

    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.47.0"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.37.0"
    }

    acme = {
      source  = "vancluever/acme"
      version = "~> 2.24.2"
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
  source      = "./modules/globals"
  environment = "live"
}

module "network" {
  source      = "./modules/network"
  environment = module.globals.environment
}

module "loadbalancer" {
  source        = "./modules/services/loadbalancer"
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

module "volunteersystem" {
  source        = "./modules/services/vserver"
  service_count = 1
  name_prefix   = "volunteersystem"
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids
  subnet        = "10.0.50.0/24"

  labels = {
    "managed_by" = "terraform"
  }

  additional_names = [ 
    "demo.volunteers.events",
    "demo.volunteer.rocks",
    "demo.volunteering.solutions",
   ]

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

module "webstorage" {
  source        = "./modules/services/vserver"
  service_count = 3
  domain        = module.globals.domain
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids

  labels = {
    "loadbalancer" = "lb",
    "managed_by"   = "terraform"
  }

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
  source        = "./modules/services/vserver"
  name_prefix   = "mail"
  service_count = 1
  domain        = module.globals.domain
  type          = "cx32"
  environment   = module.globals.environment
  network_id    = module.network.network.id
  ssh_key_ids   = module.globals.ssh_key_ids
  subnet        = "10.0.40.0/24"

  labels = {
    "loadbalancer" = "maillb",
    "managed_by"   = "terraform"
  }

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
  source        = "./modules/services/vserver"
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

  cloudflare_zones = module.globals.cloudflare_zones
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
  source = "./modules/dns"

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
    "benjamin-schneider.com" = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxylmImaxSK955VKgWOGByVZops0TVt7PdPeCRu4ZNSGIX68BbeWwkRJCt+qD6bf9pyVLjmeUKedJ46SbMCiySXUntRiZKpodTNOnEEhviYQ0s0ShrU3uXr295bMOsXEuQq5/xQbVYkHNM9vH86pYTNiQ9SkceHIsOF47GQdCeuTbVasqhfJ3CXXL48Vprwj9xXmBbJ9mgRgBENdjmOziHnJfFgV13sFYvMIQVUBuiml0fZlYdapwfqOPPwewoPkoYdU6vWU7Kwp02vyXpiLR9vSdn9x/DF/XnNl5QWHvsaofJgpSAKord9Y94NT9wFwkyyD7i4Zs+OmspFe6Lt2cawIDAQAB",
    "javik.net"              = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA0fK4+v6DgbWic1fgZeElmtz5xEm25VYyRrRrQnTGr+Ub4ONbtSGYeUaI88G8t5Lh+UyTBn61uXK9jmhgOMT4A+Ny85KkAGBR2MISuuUUD/9T+x/mTP9tkUqPjpxUpbzmxExHNjBALisohug4W4GH+DVbiu36NyzqHVr1QjCoorRTYoyXCs/7mcfHewHy6m03Xoj28aWunu9nX5FgH5HoND5nHLLlldoqnAnLAh9i4Y8pZHXbBiCPi5hS7GO/5hE2t5qVY01KDPIGLEHJopPLBSqnrdCAeL8hcYY0S7o36MmbKbReYPMMIzbHOErubcf9i0PNCU4lvPdiYIcJo2apVwIDAQAB",
    "sirjavik.de"            = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtUPg5Z3qInIAnTXT8ttLdWhh4bmjJPChPZnzrFu/psAbX/2eyihoBhaa6uq7Oc0SNUgofpROtc1SJCePJNYP32BRTTBQ6dLPsUDnEzbqMXZqqgY6t8jNkO7aRhw2qrOEaUNrrl65LWxeYBo4fN+2YS4p6ph1VLvKomO5BTgSc+vJ6TRXKksneTm9CDeFJEf0SiKptgmkh2a+Qw92FMaK8VfENF5HgWxNdI6XWND3mhY/l/4/djmw9CYGHa3R0iOvf2b3ZSqE4e+6kuVH0G9G5j6jt+dnC4efWegT0TTgnlLwzxvVkYD/GAWRvd2XV2Oa4q4DFY/vemyuKgT+vtNpRwIDAQAB",
    "volunteer.rocks"        = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqD67mY/6RPb3+9Fa/CjenrZdJBbgfrMUUE3eB1KAVGwl6sR0wP4odx0KceHwn6SaEIa26KKlE7SiX5XtUEB8zpmO8uhX+813u9fmzHu2c66FXFoMnELMrvKDv3CfbOMBnPWZ3Ar9mK7FfMs/IuKLbdI6BpCCRgsub3+9NzlegeopGs56uyQWtBWZhpceuLQVlWsqpFqmco0gBq3Inq36QlzKbud1bgBXFWSNw4xgrZPphnW6frRad2Inw0VKDz2Tu1Z+8BjnaKJh7VhMlMvBObAKMqWpY/+Xe7SdGlWIbWHNNM2Bx6ZVhUIG7qDGs7UUGf9thG1bQC7YoIHtDOAf4wIDAQAB",
    #"benny003.de"            = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAtkdEynpbRYBzhLS0lqM93GPHuOCR9xEaSjZ820K2XShyijIJJbKxRmaQRkskaLPPJuRghOSB7P0JptI35dnoQ6M5iHqdETL8GfwdPjLQUsNo6qGc71YveDJIAMS0q6zuYVCs2HpPyJFtfBmq1a3wCGVyK6BMlwBZHn4P5PWra8dgO2R+FKH9Giwshh1hLz0wCREY16F9lcWYydRlmEkQrFMuFs820i4uybwkva/Yijjg+nngaAIYhBSsw2yXM9FLQRFD1eaQhAy1fKNF+Yw9FSG9ok9rgvJe2+QzgTbjUHXrgYULWACsoh30GigPz2G0mSFw8nfVUXaAFJ0QHDi0awIDAQAB",
    "javik.rocks"            = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAyjsMrCkoRLdT/n5kYQ8gMZrGqUFTzzBEn0NqIODQh9+FKu6D+jmOw2At0PRvUJheLImRdwYiDYnH76qzmDUDQzhvV8YofRNu0wNdO17huNYkT/x/npon0XVMRtKVmF0pibX1Y21HNw9regHBFIw+t5mzbwmE6v61VzTknlBWe+znLAprAkdPiXsYQ0eVbEj8nb2g3d0VxoBYPd2nd45ckzcvuLqTDV9QuPQ5+/vG87iE3hbY8+OvDD0HT43fNVJ6oA0cIzrnHtXZnydalulsoq4hjN/uIrzsV9q/eCFg+7HBtYcq8Fq7ph+ZeMwFOL6hO26cFU9udwkKEwWsOmfl6QIDAQAB",
    "mondbasis24.de"         = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1HeiQR5bV5aI/Ca1GYMDFG5LYBjRLIjk0/BbCpLcHAqUAavfad3vMGDQGy04NahWBFMjiFsBry8ud2tbl4iV7RcRK7UZQHSFMl2GgYIkt9VsVrSfTGODwp+ORekPFwnPDxJ264kvKVXOdWT+lm1af03lIxutKsvpJ/W0rpixHMbSr40oaiqyL3piRFlcJBTwnR2ZlwypXTieYQPQvYxTzJKxdrh0d9SLDo+/YS4IPHSxxPx9uqR2jU6yVjR73gnPB7yaG0yuPuQDbyVB5c02K/79rurZavsU26RibBJY7zU8KZO+5Cc90s5DupXfsUHyAZS1SkXxGfWxddqw3I28XQIDAQAB",
    "volunteering.solutions" = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEApyZHxlnnob113yNTK69/TfsyoLc5st8FnSApUsV230zz2df0GTZd6CuUIDRU/l4dAsWmJj8p0QErU1WSHu9oExzqJDS3eWOEhTC1WgFau+6LE9mCLa3AvA36dqVkUVk8iu+Qu4opgKz6J5MHDBF4EGhyn+vRwuy682y6eIs1MqoNVowCAvjOw1CIuW2jnaQPfs7bCk1ELHVRbtQfP2DibSGhgYkkofE6wduspR/X80H8tmUcB7rivyzwTF4v/w0fuqtdKVxtcFNMhgllJSd2MssKvMvYeQ4usgW5+vnqCJ6hUaCKJnYhi6EWNS6Pa0+KTECeJ6gLuZC/W8v5u6jkDwIDAQAB",
    "volunteers.events"      = "v=DKIM1;k=rsa;t=s;s=email;p=MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAq6pVW02udgovc2+rO5ZB7t6Xc+U0q8VmcpSZk0ysDJTlmbboS4lZhM03oRvh33TVtFOxf0dQxNgBv70ApBujVJUvTUN6hggFtDlmRtadDpD9ELae8ApmhvektpMf/J8ElbucOIRGeY+FRF6Pxs7/m04xKE0tdRRp8/PoswaVkXfD2kt9qYUaVnVIyaTtFD6o8vWnn89V2J7Qi1Blu6+1xrubqL64OQNK5oniMuootH8EMRv5GTgNMO8UHFzj/ckXgre6dNf3DhLEgH8hvcox6VE7V4W2dUbDUNNWMThQ5TQD12AFaYv9J/Vhm8jzQFGplXOU1xpezENGL4wBGHefpQIDAQAB",
  }

  cloudflare_zones = module.globals.cloudflare_zones

  depends_on = [
    module.globals,
    module.webstorage,
    module.loadbalancer,
    module.icinga,
    module.mail
  ]
}
