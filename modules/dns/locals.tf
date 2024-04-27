######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: locals.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-26
# Last Modified: 2024-04-27
# Changelog: 
# 1.0 - Initial version

locals {
  server_domains = toset(distinct([
    for domain in terraform_data.domain_parts : domain.triggers_replace.domain_with_tld
  ]))

  loadbalancer_list = [
    for key,value in var.loadbalancer : key
  ]
}
