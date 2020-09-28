# GCP infrastructure for a Kubeflow Pipelines deployment:

This is a Terraform module that manages provisioning and configuration of MVP GCP infrastructure to host a Kubeflow Pipelines deployment.

The module provisions:
- A VPC to host a Kubeflow GKE Cluster;
- A GKE cluster optimized for running Kubeflow Pipelines;
- A Cloud SQL managed MySQL instance to host Kubeflow and ML Metadata Databases;
- A Cloud Storage bucket to host an artifact repository;
- A service account and IAM roles to be used by GKE; 
- A service account and IAM roles to be used by Kubeflow Pipelines.

## Usage:

Basic usage is as follows. 

```
module "gcp-kubeflow-infrastructure" {
  name_prefix = "environment"
  project_id  = "project_id"
  region      = "us-central1"
  
```

The main module utilizes utilizes a set of standalone submodules:

- `modules/vpc` - The module creates an MVP VPC 
- `modules/gke` - The module creates an MVP GKE cluster
- `modules/service`- The module creates a service account and associated roles
- `modules/mysql` - The module creates an MVP instance of MySQL based Cloud SQL. For security reasons the instance is created without any users.

The submodules can be used directly if you require a different topology or naming than configured by the main module.

The module does not install Kubeflow Pipelines into the created GKE cluster. It is assumed that Kubeflow will be installed and configured by the downstream process.


## Inputs:

|Name|Description|Type|Default|Required|
|----|-----------|----|-------|--------|
|project_id|The project ID of a hosting project|string|n/a|yes|
|region|The region for the infrastructure|string|n/a|yes|
|zone|The zone for the GKE cluster. If not set the regional cluster will be created|string|""|no|
|name_prefix|The name prefix to be added to resource names|string|n\a|yes|
|cluster_node_count|The number of nodes in the default node pool. |string|`3`|no|
|cluster_node_type|The type of nodes in the default node pool.|string|`n1-standard-1`|no|
|gke_service_account_roles|The roles to assign to the GKE Service Account|list(string)|`["logging.logWriter", "monitoring.metricWriter", "monitoring.viewer", "stackdriver.resourceMetadata.writer", "storage.objectViewer" ]`|no|
|kubeflow_service_account_roles|The roles to assign to the Kubeflow Service Account|list(string)|`["storage.admin", "bigquery.admin",  "automl.admin", "automl.predictor", "ml.admin"]`|no|


## Outputs:

|Name|Description|
|----|-----------|
|cluster_endpoint|The endpoint of the host cluster|


## Requirements:

### Software:

- Terraform v0.12 or higher;
- Terraform Provider for GCP v2.0 or higher.

### Permissions:

A user or service account with the following permissions in the target project must be used to provision the resources in this module:
- `roles\editor`

### Enabled APIs:

The following cloud APIs must be enabled in the target project
- `compute.googleapis.com`
- `container.googleapis.com`
- `cloudresourcemanager.googleapis.com`
- `iam.googleapis.com`
