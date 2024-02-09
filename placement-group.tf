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
## Placement Groups
####

resource "hcloud_placement_group" "falkenstein-placement" {
  name = "falkenstein-placement"
  type = "spread"
  labels = {
    location = "Falkenstein"
  }
}

resource "hcloud_placement_group" "nuernberg-placement" {
  name = "nuernberg-placement"
  type = "spread"
  labels = {
    location = "Nuernberg"
  }
}
