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

resource "hcloud_load_balancer_service" "service" {
  count = length(var.services) * length(local.server)

  load_balancer_id = local.server_list[count.index % length(local.server_list)].id
  protocol         = local.services_list[count.index % length(local.services_list)].protocol
  listen_port      = local.services_list[count.index % length(local.services_list)].listen_port
  destination_port = local.services_list[count.index % length(local.services_list)].destination_port

  dynamic "health_check" {
    for_each = local.services_list[count.index % length(local.services_list)].health_check == null ? [] : [1]
    content {
      protocol = try("${local.services_list[count.index % length(local.services_list)].health_check.protocol}", "tcp")
      port     = try("${local.services_list[count.index % length(local.services_list)].health_check.port}", 80)
      timeout  = try("${local.services_list[count.index % length(local.services_list)].health_check.timeout}", 10)
      interval = try("${local.services_list[count.index % length(local.services_list)].health_check.interval}", 20)

      dynamic "http" {
        for_each = local.services_list[count.index % length(local.services_list)].health_check.http == null ? [] : [1]
        content {
          domain       = try("${local.services_list[count.index % length(local.services_list)].health_check.http.domain}", "")
          path         = try("${local.services_list[count.index % length(local.services_list)].health_check.http.path}", "/")
          response     = try("${local.services_list[count.index % length(local.services_list)].health_check.http.response}", "OK")
          tls          = try("${local.services_list[count.index % length(local.services_list)].health_check.http.tls}", false)
          status_codes = try("${local.services_list[count.index % length(local.services_list)].health_check.http.status_codes}", [200])
        }
      }
    }
  }

  dynamic "http" {
    for_each = local.services_list[count.index % length(local.services_list)].http == null ? [] : [1]
    content {
      sticky_sessions = try("${local.services_list[count.index % length(local.services_list)].http.sticky_sessions}", false)
      cookie_name     = try("${local.services_list[count.index % length(local.services_list)].http.cookie_name}", "default")
      cookie_lifetime = try("${local.services_list[count.index % length(local.services_list)].http.cookie_lifetime}", 30)
      certificates    = try("${local.services_list[count.index % length(local.services_list)].http.certificates}", [])
      redirect_http   = try("${local.services_list[count.index % length(local.services_list)].http.redirect_http}", false)
    }

  }
}
