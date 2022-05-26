# ----------------------------------------------------------------------------------------------------------------------
# Firewall Rules
# ----------------------------------------------------------------------------------------------------------------------
resource "google_compute_firewall" "abm-rules" {

    name = "allow-abm-talk"
    network = var.vpc-name

    allow {
        protocol = "all"
    }

    source_tags = ["abm"]
    target_tags = ["abm"]

    depends_on = [google_compute_subnetwork.subnets]
}