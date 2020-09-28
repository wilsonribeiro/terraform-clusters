terraform {
  required_version = ">= 0.12"
  required_providers {
    google = "~> 2.0"
  }
}

provider "google" {
    project   = var.project_id 
}

# Create the GKE service account 
module "gke_service_account" {
  source                       = "./modules/service_account"
  service_account_id           = "${var.name_prefix}-gke-sa"
  service_account_display_name = "The GKE service account"
  service_account_roles        = var.gke_service_account_roles
}

# Create the Kubeflow service account 
module "kubeflow_service_account" {
  source                       = "./modules/service_account"
  service_account_id           = "${var.name_prefix}-sa"
  service_account_display_name = "The Kubeflow service account"
  service_account_roles        = var.kubeflow_service_account_roles
}

# Create the VPC for the Kubeflow Cluster
module "kubeflow_gke_vpc" {
  source                 = "./modules/vpc"
  region                 = var.region
  network_name           = "${var.name_prefix}-network"
  subnet_name            = "${var.name_prefix}-subnetwork"
}

# Create the Kubeflow GKE cluster
module "kubeflow_gke_cluster" {
  source                 = "./modules/gke"
  name                   = "${var.name_prefix}"
  location               = var.zone != "" ? var.zone : var.region
  description            = "Kubeflow GKE cluster"
  sa_full_id             = module.gke_service_account.service_account.email
  network                = module.kubeflow_gke_vpc.network_name
  subnetwork             = module.kubeflow_gke_vpc.subnet_name
  node_count             = var.cluster_node_count
  node_type              = var.cluster_node_type
}

# Create the MySQL instance for ML Metadata
resource "random_id" "id" {
  byte_length = 4
}

module "metadata_mysql" {
  source  = "./modules/mysql"
  region  = var.region
  name    = "${var.name_prefix}-metadata-${random_id.id.hex}"
}

# Create Cloud Storage bucket for artifact storage
resource "google_storage_bucket" "artifact_store" {
  name = "${var.name_prefix}-artifact-store"
}