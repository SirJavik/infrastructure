######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: providers.tf
# Description: Terraform providers
# Version: 1.5.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-08-03
# Last Modified: 2024-08-03
# Changelog: 
# 1.0.0 - Initial version

######################################
#             Providers              #
######################################

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

######################################
#         Terraform Backend          #
######################################

terraform {
  backend "http" {
  }
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "> 1.47.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "> 4.37.0"
    }
  }
}
