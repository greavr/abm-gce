# ----------------------------------------------------------------------------------------------------------------------
# Variables
# ----------------------------------------------------------------------------------------------------------------------

# GCP Project Name
variable "project_id" {
    type = string
}

variable "vpc-name" {
    type = string
    description = "Custom VPC Name"
    default = "anthos-bare-metal"
}

# List of regions (support for multi-region deployment)
variable "regions" { 
    type = list(object({
        region = string
        cidr = string
        management-cidr = string
        })
    )
    default = [{
            region = "us-west1"
            cidr = "10.0.0.0/20"
            management-cidr = "192.168.10.0/28"
        },]
}

# Service to enable
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "compute.googleapis.com",
        "iap.googleapis.com",
        "cloudbuild.googleapis.com",
        "composer.googleapis.com",
        "anthos.googleapis.com",
        "anthosaudit.googleapis.com",
        "anthosgke.googleapis.com",
        "cloudresourcemanager.googleapis.com",
        "container.googleapis.com",
        "gkeconnect.googleapis.com",
        "gkehub.googleapis.com",
        "iam.googleapis.com",
        "logging.googleapis.com",
        "monitoring.googleapis.com",
        "opsconfigmonitoring.googleapis.com",
        "serviceusage.googleapis.com",
        "stackdriver.googleapis.com"
    ]
}

# Master Node Count
variable "master-node-count" {
    description = "# of Kubernetes master nodes"
    type = number
    default = 1
}

# Worker Node Cout
variable "worker-node-count" {
    description = "# of Kubernetes worker nodes"
    type = number
    default = 3
}

# Instance Type
variable "gce-instance-type" {
  description = "GCE Instance Spec"
  type = string
  default = "n2-standard-2"
}

# Instance OS
variable "gce-instance-os" {
    description = "GCE Instance OS"
    type = string
    default = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
  
}