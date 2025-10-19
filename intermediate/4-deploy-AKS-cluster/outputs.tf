output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}
output "aks_kubeconfig" {
  description = "AKS cluster kubeconfig"
  value       = azurerm_kubernetes_cluster.aks_cluster.kube_admin_config_raw
  sensitive   = true
}
output "aks_api_endpoint" {
  description = "AKS API server endpoint"
  value       = azurerm_kubernetes_cluster.aks_cluster.fqdn
}
output "aks_identity_client_id" {
  description = "AKS client ID"
  value       = azurerm_kubernetes_cluster.aks_cluster.identity[0].principal_id
}
