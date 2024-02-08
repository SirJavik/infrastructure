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
## Let's Encrypt Account
####

resource "tls_private_key" "le_account_privatekey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "acme_registration" "le_account_registration" {
  account_key_pem = tls_private_key.le_account_privatekey.private_key_pem
  email_address   = "certs@sirjavik.de"
}

####
## Certificates
####

resource "null_resource" "domains" {
  for_each = toset(var.domains)

  triggers = {
    domain = each.value
  }
}

## Private Key

resource "tls_private_key" "domains_privatekey" {
  for_each = null_resource.domains

  algorithm = "RSA"
  rsa_bits  = 4096
}

## Requests

resource "tls_cert_request" "domains_cert_request" {
  for_each = null_resource.domains

  private_key_pem = tls_private_key.domains_privatekey[each.key].private_key_pem
  dns_names       = ["${each.key}", "*.${each.key}"]

  subject {
    common_name = each.key
  }
}

## Certificate

resource "acme_certificate" "domains_certificate" {
  for_each = null_resource.domains

  account_key_pem         = acme_registration.le_account_registration.account_key_pem
  certificate_request_pem = tls_cert_request.domains_cert_request[each.key].cert_request_pem

  dns_challenge {
    provider = "cloudflare"

    config = {
      CLOUDFLARE_PROPAGATION_TIMEOUT = 60
    }
  }
}

resource "hcloud_uploaded_certificate" "domain_certificate" {
  for_each = null_resource.domains

  name = "${each.key}-Certificate"

  private_key = tls_private_key.domains_privatekey[each.key].private_key_pem
  certificate = "${acme_certificate.domains_certificate[each.key].certificate_pem}${acme_certificate.domains_certificate[each.key].issuer_pem}"

  labels = {
    terraform = true
    domain    = each.key
  }
}
