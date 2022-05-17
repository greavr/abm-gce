# ----------------------------------------------------------------------------------------------------------------------
# Configure Providers
# ----------------------------------------------------------------------------------------------------------------------
provider "google" {
  region        = var.regions[0].region
  project       = var.project_id
}

provider "google-beta" {
  region        = var.regions[0].region
  project       = var.project_id
}

# ----------------------------------------------------------------------------------------------------------------------
# DATA
# ----------------------------------------------------------------------------------------------------------------------
data "google_project" "project" {}

# ----------------------------------------------------------------------------------------------------------------------
# ORG Policies
# ----------------------------------------------------------------------------------------------------------------------
module "org_policy" {
  source  = "./modules/org_policy"

  project_id = var.project_id
}

# ----------------------------------------------------------------------------------------------------------------------
# Enable APIs
# ----------------------------------------------------------------------------------------------------------------------
resource "google_project_service" "enable-services" {
  for_each = toset(var.services_to_enable)

  project = var.project_id
  service = each.value
  disable_on_destroy = false
}

# ----------------------------------------------------------------------------------------------------------------------
# Configure VPC
# ----------------------------------------------------------------------------------------------------------------------
module "vpc" {
  source  = "./modules/vpc"
  project_id = var.project_id
  regions = var.regions
  vpc-name = var.vpc-name
  
  depends_on = [
    google_project_service.enable-services,
    module.org_policy
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Nodes
# ----------------------------------------------------------------------------------------------------------------------
module "nodes" {
    source = "./modules/nodes"

    zone = "${module.vpc.primary_region}-a"
    node-spec = var.gce-instance-type
    master-node-count = var.master-node-count
    worker-node-count = var.worker-node-count
    node-os = var.gce-instance-os
    network = module.vpc.vpc_id
    subnetwork = module.vpc.primary_region
    project_id = var.project_id

    depends_on = [
      module.vpc
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Workstation
# ----------------------------------------------------------------------------------------------------------------------
module "master-nodes" {
    source = "./modules/abm_workstation"

    zone = "${module.vpc.primary_region}-a"
    node-spec = var.gce-instance-type
    network = module.vpc.vpc_id
    master-node-ips = module.nodes.master-ips
    worker-node-ips = module.nodes.worker-ips
    node-os = var.gce-instance-os
    subnetwork = module.vpc.primary_region
    project_id = var.project_id
    
    depends_on = [
      module.nodes
    ]
}