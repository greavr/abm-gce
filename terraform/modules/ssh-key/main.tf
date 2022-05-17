# ----------------------------------------------------------------------------------------------------------------------
# Create SSH KEY
# ----------------------------------------------------------------------------------------------------------------------
resource "tls_private_key" "abm-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_secret_manager_secret" "abm-private-key" {
  provider = google-beta
  
  secret_id = "abm-private-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "abm-private-key" {
  secret = google_secret_manager_secret.abm-private-key.id
  secret_data = tls_private_key.abm-key.private_key_openssh

  depends_on = [
    tls_private_key.abm-key,
    google_secret_manager_secret.abm-private-key
  ]
}
