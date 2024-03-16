######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

output "user_keys" {
  value = { for key in data.hcloud_ssh_keys.user_ssh_keys.ssh_keys : key.name => key.public_key }
}

output "server" {
  value = local.server
}