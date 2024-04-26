######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

# Filename: variables.tf
# Description: 
# Version: 1.0
# Author: Benjamin Schneider <ich@benjamin-schneider.com>
# Date: 2024-04-25
# Last Modified: 2024-04-25
# Changelog: 
# 1.0 - Initial version

variable "type" {
  description = "The type of the load balancer"
  type        = string
  default     = "lb11"
}

variable "service_count" {
  description = "The number of load balancers to create"
  type        = number
  default     = 2
}

variable "environment" {
  description = "The environment of the load balancer"
  type        = string
}

variable "domain" {
  description = "The domain of the load balancer"
  type        = string
}

variable "locations" {
  description = "The locations of the load balancer"
  type        = list(string)
  default     = ["fsn1", "nbg1"]
}

variable "network_id" {
  description = "The network ID of the load balancer"
  type        = number
}

variable "targets_label_selector" {
  description = "The label selector of the load balancer"
  type        = string
  default     = "loadbalancer=lb"
}

variable "targets_use_private_ip" {
  description = "Use private IP for targets"
  type        = bool
  default     = false
}

variable "services" {
  description = "The services of the load balancer"
  type = map(object({
    name             = string
    listen_port      = number
    destination_port = number
    protocol         = string
    proxyprotocol    = optional(bool)

    health_check = optional(object({
      protocol = string
      port     = number
      interval = number
      timeout  = number

      http = optional(object({
        domain       = optional(string)
        path         = optional(string)
        response     = optional(string)
        tls          = optional(bool)
        status_codes = optional(list(string))
      }))
    }))

    http = optional(object({
      sticky_sessions = optional(bool)
      cookie_name     = optional(string)
      cookie_lifetime = optional(number)
      certificates    = optional(list(number))
      redirect_http   = optional(bool)
    }))

  }))

  default = {
    http = {
      name             = "http"
      listen_port      = 80
      destination_port = 80
      protocol         = "http"
      proxyprotocol    = true

      health_check = {
        protocol = "http"
        port     = 80
        interval = 5
        timeout  = 2

        http = {
          domain       = "example.com"
          path         = "/"
          response     = "OK"
          tls          = true
          status_codes = ["200"]
        }
      }

      http = {
        sticky_sessions = true
        cookie_name     = "session"
        cookie_lifetime = 3600
      }
    }

    https = {
      name             = "https"
      listen_port      = 443
      destination_port = 443
      protocol         = "tcp"

      health_check = {
        protocol = "tcp"
        port     = 443
        interval = 5
        timeout  = 2
      }
    }

    mysql = {
      name             = "mysql"
      listen_port      = 3306
      destination_port = 3306
      protocol         = "tcp"

      health_check = {
        protocol = "tcp"
        port     = 3306
        interval = 10
        timeout  = 5
      }
    }
  }
}

variable "subnet" {
  description = "The subnet of the load balancer"
  type        = string
  default     = "10.0.10.0/24"
}
