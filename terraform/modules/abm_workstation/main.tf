# ----------------------------------------------------------------------------------------------------------------------
# ABM Workstation
# ----------------------------------------------------------------------------------------------------------------------
# GCE SA
resource "google_service_account" "abm-workstation-sa" {
    account_id   = "abm-workstation-sa"
    display_name = "abm-workstation-sa"
}

resource "google_project_iam_member" "service_account-roles" {
    for_each = toset(var.gce-roles)
    role    = "roles/${each.value}"
    member  = "serviceAccount:${google_service_account.abm-workstation-sa.email}"
    depends_on = [
        google_service_account.abm-workstation-sa
    ]
}

resource "google_compute_instance" "workstation" {
    name  = "abm-workstation"
    hostname  = "abm-workstation.${var.project_id}"
    machine_type = "n2-standard-4"
    zone         = var.zone
    can_ip_forward = true
    allow_stopping_for_update = true


    tags = ["abm","abm-worker"]

    boot_disk {
        initialize_params {
            image = var.node-os
            size = 160
        }
    }

    network_interface {
        network = var.network
        subnetwork = var.subnetwork
    }

    shielded_instance_config {
        enable_secure_boot = true
        enable_integrity_monitoring = true
    }

    metadata_startup_script = "${file("${path.module}/scripts/startup.sh")}"

    metadata = {
        master-node-ips = join(",",var.master-node-ips),
        worker-node-ips = join(",",var.worker-node-ips),
        abm-private-key = var.private-key,
        sa-key-list = join(",",var.sa-key-list)
        ssh-keys = "ubuntu:${var.public-key}"
        template-path = var.template-path
        vx-ip = var.vx-ip
    }

    service_account {
        # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
        email  = google_service_account.abm-workstation-sa.email
        scopes = ["cloud-platform"]
    }
    
    depends_on = [
        google_service_account.abm-workstation-sa
    ]
}