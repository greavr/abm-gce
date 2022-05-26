# ----------------------------------------------------------------------------------------------------------------------
# GCS Bucket
# ----------------------------------------------------------------------------------------------------------------------
resource "google_storage_bucket" "bucket" {
  name =  format("%s%s", var.project_id, var.gcs-bucket-name)
  uniform_bucket_level_access = true
}

resource "google_storage_bucket_object" "abm-template" {
  name   = "abm-gce.yaml"
  bucket = google_storage_bucket.bucket.name
  source = "${path.module}/files/abm-gce.yaml"
}