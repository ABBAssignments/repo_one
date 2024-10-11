# outputs.tf

output "aks_cluster_name" {
  description = "The name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.name
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.log_analytics.id
}

output "aks_resource_group" {
  description = "The name of the resource group for AKS"
  value       = azurerm_resource_group.aks_rg.name
}

output "aks_cluster_id" {
  description = "The ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.aks_cluster.id
}
