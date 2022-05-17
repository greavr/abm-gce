variable "master-node-count" {}
variable "worker-node-count" {}
variable "node-spec" {}
variable "zone" {}
variable "network" {}
variable "subnetwork" {}
variable "node-os" {}
variable "project_id" {}
variable "public-key" {}

variable "gce-roles" {
    default = [
        "logging.logWriter",
        "monitoring.metricWriter",
        "monitoring.dashboardEditor",
        "stackdriver.resourceMetadata.writer",
        "opsconfigmonitoring.resourceMetadata.writer",
        "multiclusterservicediscovery.serviceAgent",
        "multiclusterservicediscovery.serviceAgent"
    ]
  
}