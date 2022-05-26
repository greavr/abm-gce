variable "node-spec" {}
variable "zone" {}
variable "network" {}
variable "node-os" {}
variable "project_id" {}
variable "subnetwork" {}
variable "master-node-ips" {}
variable "worker-node-ips" {}
variable "private-key" {}
variable "public-key" {}
variable "sa-key-list" {}
variable "template-path" {}
variable "vx-ip" {}

variable "gce-roles" {
    default = [
        "gkehub.connect",
        "gkehub.admin",
        "logging.logWriter",
        "monitoring.metricWriter",
        "monitoring.dashboardEditor",
        "stackdriver.resourceMetadata.writer",
        "opsconfigmonitoring.resourceMetadata.writer",
        "multiclusterservicediscovery.serviceAgent",
        "multiclusterservicediscovery.serviceAgent",
        "secretmanager.secretAccessor",
        "editor"
    ]
  
}