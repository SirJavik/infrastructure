######################################
#           _             _ _        #
#          | |           (_) |       #
#          | | __ ___   ___| | __    #
#      _   | |/ _` \ \ / / | |/ /    #
#     | |__| | (_| |\ V /| |   <     #
#      \____/ \__,_| \_/ |_|_|\_\    #
#                                    #
###################################### 

data "gitlab_current_user" "me" {}

resource "gitlab_personal_access_token" "example" {
  user_id    = data.gitlab_current_user.me.id
  name       = "Example personal access token"
  expires_at = "2024-03-14"

  scopes = ["api"]
}

output "gitlab_user_id" {
  value = data.gitlab_current_user.me.id
}

output "personal_token" {
  value = gitlab_personal_access_token.example.id
}
