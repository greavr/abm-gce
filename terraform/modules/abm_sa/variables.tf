variable "project_id" {}

variable "connect-agent" {
  default = [
      "gkehub.connect"
  ]
}

variable "connect-register" {
  default = [
      "gkehub.admin"
  ]
}

variable "logging-sa" {
  default = [
      "logging.logWriter",
      "monitoring.metricWriter",
      "stackdriver.resourceMetadata.writer",
      "opsconfigmonitoring.resourceMetadata.writer",
      "monitoring.dashboardEditor"
  ]
}

variable "storage-sa" {
  default = [
      "storage.admin"
  ]
}