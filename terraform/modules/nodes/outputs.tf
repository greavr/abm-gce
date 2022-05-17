output "master-ips" {
    value = [
        for gce in google_compute_instance.masters: 
            gce.network_interface.0.network_ip
    ]
}

output "worker-ips" {
    value = [
        for gce in google_compute_instance.workers:
            gce.network_interface.0.network_ip
    ]
}