######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
######################################

####
## Storage Server
####

resource "hcloud_volume" "storage" {
  count = var.server_count["storageserver"]
  name = format("%s-%s.%s-%s",
    "storage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "StorageVolume"
  )
  size      = 40
  server_id = hcloud_server.storageserver[count.index].id
}
