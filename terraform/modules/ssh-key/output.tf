output "public-key" {
  value = tls_private_key.abm-key.public_key_openssh
}

output "secret-name" {
  value = google_secret_manager_secret.abm-private-key.secret_id
}