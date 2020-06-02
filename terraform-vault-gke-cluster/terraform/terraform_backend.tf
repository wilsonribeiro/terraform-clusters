terraform {
  backend "gcs" {
    bucket = "nuveo-shared-terraform-state"
    prefix = "nuveo-vault-cluster/backlog-nuveo-vault-cluster-state"
  }
}