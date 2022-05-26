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
        })
    )
    default = [{
            region = "us-central1"
            cidr = "10.0.0.0/24"
        },]
}

# Service to enable
variable "services_to_enable" {
    description = "List of GCP Services to enable"
    type    = list(string)
    default =  [
        "compute.googleapis.com",
        "iap.googleapis.com",
        "secretmanager.googleapis.com",
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
        "stackdriver.googleapis.com",
        "servicemanagement.googleapis.com",
        "servicecontrol.googleapis.com",
        "storage.googleapis.com"
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
  default = "n1-standard-8"
}

# Instance OS
variable "gce-instance-os" {
    description = "GCE Instance OS"
    type = string
    default = "ubuntu-os-cloud/ubuntu-minimal-2004-lts"
  
}

# Storage Bucket
variable "gcs-bucket-name" {
    default = "abm-config"
    description = "Bucket used to store kubectl config and abm template"
    type = string
    }

# Firewall rules
variable "abm-firewall-ports-tcp" {
    description = "Ports required for abm"
    type = list(string)
    default = [ 
        "6444",
        "10250",
        "2379-2380",
        "10250-10252",
        "10256",
        "4240",
        "30000-32767",
        "7946",
        "443",
        "22"
        ]
  
}

variable "abm-firewall-ports-udp" {
    description = "Ports required for abm"
    type = list(string)
    default = [ 
        "6081",
        "7946"
        ]
  
}