######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

variable "server_count" {
  type      = map(number)
  sensitive = false

  default = {
    "ansible"    = 1
    "webserver"  = 2
    "mailserver" = 1
  }
}