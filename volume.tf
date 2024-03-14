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

resource "hcloud_volume" "storageserver_webdata" {
  count             = var.server_count["storageserver"]
  delete_protection = true
  name = format("%s-%s.%s-%s",
    "storage${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "WebdataVolume"
  )
  location = (count.index % 2 == 0 ? "fsn1" : "nbg1")
  size     = 20
  format   = "ext4"
}

resource "hcloud_volume_attachment" "storageserver_mount_webdata" {
  count     = var.server_count["storageserver"]
  volume_id = hcloud_volume.storageserver_webdata[count.index].id
  server_id = hcloud_server.storageserver[count.index].id
  automount = false
}

resource "hcloud_volume" "storageserver_database" {
  count             = var.server_count["storageserver"]
  delete_protection = true
  name = format("%s-%s.%s-%s",
    "storageserver${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "DatabaseVolume"
  )
  location = (count.index % 2 == 0 ? "fsn1" : "nbg1")
  size     = 10
  format   = "ext4"
}

resource "hcloud_volume_attachment" "storageserver_mount_database" {
  count     = var.server_count["storageserver"]
  volume_id = hcloud_volume.storageserver_database[count.index].id
  server_id = hcloud_server.storageserver[count.index].id
  automount = false
}

####
## Webserver
####

resource "hcloud_volume" "webserver_database" {
  count             = var.server_count["webserver"]
  delete_protection = true
  name = format("%s-%s.%s-%s",
    "web${count.index + 1}",
    (count.index % 2 == 0 ? "fsn1" : "nbg1"),
    "infra.sirjavik.de",
    "DatabaseVolume"
  )
  location = (count.index % 2 == 0 ? "fsn1" : "nbg1")
  size     = 10
  format   = "ext4"
}

resource "hcloud_volume_attachment" "webserver_mount_database" {
  count     = var.server_count["webserver"]
  volume_id = hcloud_volume.webserver_database[count.index].id
  server_id = hcloud_server.webserver[count.index].id
  automount = false
}
