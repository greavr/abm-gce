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
  firewall-ports-tcp = var.abm-firewall-ports-tcp
  firewall-ports-udp = var.abm-firewall-ports-udp
  
  depends_on = [
    google_project_service.enable-services,
    module.org_policy
  ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Generate SSH Key
# ----------------------------------------------------------------------------------------------------------------------
module "ssh-key" {
    source = "./modules/ssh-key"

    depends_on = [
        google_project_service.enable-services,
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# Generate SAs
# ----------------------------------------------------------------------------------------------------------------------
module "abm-sa" {
    source = "./modules/abm_sa"
    project_id = var.project_id

    depends_on = [
        google_project_service.enable-services,
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
    public-key = module.ssh-key.public-key
    vx-ip-master = 3
    vx-ip-worker = 4


    depends_on = [
      module.vpc,
      module.ssh-key
    ]
}

# ----------------------------------------------------------------------------------------------------------------------
# GCS For template files
# ----------------------------------------------------------------------------------------------------------------------

module "gcs" {
  source = "./modules/gcs"

  project_id = var.project_id
  gcs-bucket-name = var.gcs-bucket-name


  depends_on = [
    google_project_service.enable-services
  ]
  
}

# ----------------------------------------------------------------------------------------------------------------------
# Build Workstation
# ----------------------------------------------------------------------------------------------------------------------
module "amb-workstation" {
    source = "./modules/abm_workstation"

    zone = "${module.vpc.primary_region}-a"
    node-spec = var.gce-instance-type
    network = module.vpc.vpc_id
    master-node-ips = module.nodes.master-ips
    worker-node-ips = module.nodes.worker-ips
    node-os = var.gce-instance-os
    subnetwork = module.vpc.primary_region
    project_id = var.project_id
    private-key = module.ssh-key.secret-name
    public-key = module.ssh-key.public-key
    sa-key-list = module.abm-sa.secrets-list
    template-path = module.gcs.abm-template-file
    vx-ip = 2

    depends_on = [
      module.nodes,
      module.gcs,
      module.abm-sa
    ]
}