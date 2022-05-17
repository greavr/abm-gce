# ----------------------------------------------------------------------------------------------------------------------
# Connect Agent SA
# ----------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "connect-agent" {
    account_id   = "connect-agent-svc-account"
    display_name = "connect-agent-svc-account"
    project = var.project_id
}

resource "google_project_iam_member" "connect-agent-roles" {
    for_each = toset(var.connect-agent)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.connect-agent.email}"

    depends_on = [
        google_service_account.connect-agent
    ]
}

resource "google_service_account_key" "connect-agent-key" {
  service_account_id = google_service_account.connect-agent.name

  depends_on = [
        google_service_account.connect-agent
    ]
}

resource "google_secret_manager_secret" "connect-agent-key" {
  provider = google-beta
  
  secret_id = "connect-agent-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "connect-agent-key" {
  secret = google_secret_manager_secret.connect-agent-key.id
  secret_data = google_service_account_key.connect-agent-key.private_key

  depends_on = [
    google_service_account_key.connect-agent-key,
    google_secret_manager_secret.connect-agent-key
  ]
}


# ----------------------------------------------------------------------------------------------------------------------
# Connect Register SA
# ----------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "connect-register" {
    account_id   = "connect-register-svc-account"
    display_name = "connect-register-svc-account"
    project = var.project_id
}

resource "google_project_iam_member" "connect-register-roles" {
    for_each = toset(var.connect-register)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.connect-register.email}"

    depends_on = [
        google_service_account.connect-register
    ]
}

resource "google_service_account_key" "connect-register-key" {
  service_account_id = google_service_account.connect-register.name


  depends_on = [
        google_service_account.connect-register
    ]
}

resource "google_secret_manager_secret" "connect-register-key" {
  provider = google-beta
  
  secret_id = "connect-register-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "connect-register-key" {
  secret = google_secret_manager_secret.connect-register-key.id
  secret_data = google_service_account_key.connect-register-key.private_key

  depends_on = [
    google_service_account_key.connect-register-key,
    google_secret_manager_secret.connect-register-key
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Logging SA
# ----------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "logging-sa" {
    account_id   = "logging-monitoring-svc-account"
    display_name = "logging-monitoring-svc-account"
    project = var.project_id
}

resource "google_project_iam_member" "logging-sa-roles" {
    for_each = toset(var.logging-sa)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.logging-sa.email}"

    depends_on = [
        google_service_account.logging-sa
    ]
}

resource "google_service_account_key" "logging-sa-key" {
  service_account_id = google_service_account.logging-sa.name


  depends_on = [
        google_service_account.logging-sa
    ]
}

resource "google_secret_manager_secret" "logging-sa-key" {
  provider = google-beta
  
  secret_id = "logging-sa-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "logging-sa-key" {
  secret = google_secret_manager_secret.logging-sa-key.id
  secret_data = google_service_account_key.logging-sa-key.private_key

  depends_on = [
    google_service_account_key.logging-sa-key,
    google_secret_manager_secret.logging-sa-key
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Storage SA
# ----------------------------------------------------------------------------------------------------------------------

resource "google_service_account" "storage-sa" {
    account_id   = "storage-agent-svc-account"
    display_name = "storage-agent-svc-account"
    project = var.project_id
}

resource "google_project_iam_member" "storage-sa-roles" {
    for_each = toset(var.storage-sa)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.storage-sa.email}"

    depends_on = [
        google_service_account.storage-sa
    ]
}

resource "google_service_account_key" "storage-sa-key" {
  service_account_id = google_service_account.storage-sa.name


  depends_on = [
        google_service_account.storage-sa
    ]
}

resource "google_secret_manager_secret" "storage-sa-key" {
  provider = google-beta
  
  secret_id = "storage-sa-key"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "storage-sa-key" {
  secret = google_secret_manager_secret.storage-sa-key.id
  secret_data = google_service_account_key.storage-sa-key.private_key

  depends_on = [
    google_service_account_key.storage-sa-key,
    google_secret_manager_secret.storage-sa-key
  ]
}