# ----------------------------------------------------------------------------------------------------------------------
# Master Nodes
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_instance" "masters" {
    count = var.master-node-count
    name  = "abm-master-${count.index}"
    hostname = "abm-master-${count.index}.${var.project_id}"
    machine_type = var.node-spec
    zone         = var.zone

    tags = ["abm","abm-master"]

    boot_disk {
        initialize_params {
            image = var.node-os
            size = 60
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

}


# ----------------------------------------------------------------------------------------------------------------------
# Worker Nodes
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_instance" "workers" {
    count = var.worker-node-count
    name  = "abm-worker-${count.index}"
    hostname = "abm-worker-${count.index}.${var.project_id}"
    machine_type = var.node-spec
    zone         = var.zone

    tags = ["abm","abm-worker"]

    boot_disk {
        initialize_params {
            image = "ubuntu-os-cloud/ubuntu-minimal-2204-lts"
            size = 60
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

}

# ----------------------------------------------------------------------------------------------------------------------
# IAP Firewall Rule
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_firewall" "iap" {
  name    = "allow-iap-ssh"
  network = var.network


  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
}
