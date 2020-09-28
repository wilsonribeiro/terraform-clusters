variable "project_id" {
    description = "The GCP project ID"
    type        = string
}

variable "region" {
    description = "The region for the Kubeflow infrastructure"
    type        = string
}

variable "zone" {
    description = "The zone for the GKE cluster. If not the regional cluster will be created"
    type        = string
    default     = ""
}

variable "name_prefix" {
    description = "The name prefix for the resources"
    type        = string
}

variable "cluster_node_count" {
    description = "The cluster's node count"
    default     = 1
}

variable "cluster_node_type" {
    description = "The cluster's node type"
    default     = "e2-standard-8"
}

variable "gke_service_account_roles" {
  description = "The roles to assign to the GKE service account"
  default = [
    "logging.logWriter",
    "monitoring.metricWriter", 
    "monitoring.viewer", 
    "stackdriver.resourceMetadata.writer",
    "storage.objectViewer" 
    ] 
}

variable "kubeflow_service_account_roles" {
  default = [    
    "storage.admin", 
    "bigquery.admin", 
    "automl.admin", 
    "automl.predictor",
    "ml.admin",
    "dataflow.admin",
    "cloudsql.admin"
  ]
}