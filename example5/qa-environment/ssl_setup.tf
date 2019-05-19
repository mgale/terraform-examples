resource "tls_private_key" "ssl_key" {
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "ssl_cert" {
  key_algorithm   = "RSA"
  private_key_pem = "${tls_private_key.ssl_key.private_key_pem}"

  subject {
    common_name  = "djangoexample.com"
    organization = "ACME djangoexamples, Inc"
  }

  validity_period_hours = 2160

  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "aws_acm_certificate" "ssl_cert" {
  private_key      = "${tls_private_key.ssl_key.private_key_pem}"
  certificate_body = "${tls_self_signed_cert.ssl_cert.cert_pem}"
}
