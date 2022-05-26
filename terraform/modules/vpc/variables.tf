# GCP Project Name
variable "project_id" {}

variable "vpc-name" {}

variable "firewall-ports-tcp" {}
variable "firewall-ports-udp" {}

# List of regions (support for multi-region deployment)
variable "regions" { 
    type = list(object({
        region = string
        cidr = string
        })
    )
}