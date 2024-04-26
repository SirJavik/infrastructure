######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: services.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version 

resource "terraform_data" "loadbalancer_services" {
  count = length(var.services) * length(local.server)

  triggers_replace = {
    service_name             = "${local.services_list[count.index % length(local.services_list)].name}"
    service_listen_port      = "${local.services_list[count.index % length(local.services_list)].listen_port}"
    service_destination_port = "${local.services_list[count.index % length(local.services_list)].destination_port}"
    service_protocol         = "${local.services_list[count.index % length(local.services_list)].protocol}"

    service_hc_protocol = try("${local.services_list[count.index % length(local.services_list)].health_check.protocol}", "tcp")
    service_hc_port     = try("${local.services_list[count.index % length(local.services_list)].health_check.port}", 80)
    service_hc_interval = try("${local.services_list[count.index % length(local.services_list)].health_check.interval}", 20)
    service_hc_timeout  = try("${local.services_list[count.index % length(local.services_list)].health_check.timeout}", 10)

    lb_name = "${local.server_list[count.index % length(local.server_list)].name}"
    lb_id   = "${local.server_list[count.index % length(local.server_list)].id}"
  }
}

resource "hcloud_load_balancer_service" "service" {
  count = length(terraform_data.loadbalancer_services)

  load_balancer_id = terraform_data.loadbalancer_services[count.index % length(local.server_list)].triggers_replace.lb_id
  protocol         = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_protocol
  listen_port      = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_listen_port
  destination_port = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_destination_port

  health_check {
    protocol = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_hc_protocol
    port     = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_hc_port
    timeout  = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_hc_timeout
    interval = terraform_data.loadbalancer_services[count.index % length(local.services_list)].triggers_replace.service_hc_interval
  }
}
