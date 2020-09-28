output "cluster_endpoint" {
  value = module.kubeflow_gke_cluster.cluster_endpoint
}
  
output "mysql_instance_name" {
  value = module.metadata_mysql.mysql_instance.name
}
