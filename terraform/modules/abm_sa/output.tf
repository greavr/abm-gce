output "secrets-list" {
    value = [
        google_secret_manager_secret.connect-agent-key.secret_id, 
        google_secret_manager_secret.connect-register-key.secret_id, 
        google_secret_manager_secret.logging-sa-key.secret_id,
        google_secret_manager_secret.storage-sa-key.secret_id,
        ]
}