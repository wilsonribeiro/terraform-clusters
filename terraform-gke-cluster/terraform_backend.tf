terraform {
  backend "gcs" {
    bucket = "nuveo-staging-tf-state"
    prefix = "nuveo-vault-cluster/backlog-nuveo-vault-cluster-state"
  }
}