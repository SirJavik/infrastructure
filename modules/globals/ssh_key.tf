######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: ssh_key.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

resource "tls_private_key" "ed25519-key" {
  algorithm = "ED25519"
}

resource "hcloud_ssh_key" "terraform" {
  name       = (var.environment == "live" ? "Terraform SSH Key" : format("[%s] %s", title(var.environment), "Terraform SSH Key"))
  public_key = tls_private_key.ed25519-key.public_key_openssh

  labels = {
    "environment" = var.environment,
    "managed_by"  = "terraform"
  }
}

data "hcloud_ssh_keys" "keys_by_selector" {
  with_selector = "use_in_terraform=true"
}
