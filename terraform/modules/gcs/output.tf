output "gcs_bucket_name" {
    value = google_storage_bucket.bucket.name
}

output "abm-template-file" {
    value = "gs://${google_storage_bucket.bucket.name}/abm-gce.yaml"  
}