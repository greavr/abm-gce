# ----------------------------------------------------------------------------------------------------------------------
# ABM Workstation
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_instance" "workstation" {
    name  = "abm-workstation"
    hostname  = "abm-workstation.${var.project_id}"
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

    metadata = {
        master-node-ips = join(",",var.master-node-ips),
        worker-node-ips = join(",",var.worker-node-ips)
    }
       
}