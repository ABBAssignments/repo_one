# monitoring.tf

# Azure Monitor for AKS
resource "azurerm_log_analytics_workspace" "log_analytics" {
  name                = "${var.resource_group_name}-log"
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  sku                 = "PerGB2018"
}

resource "azurerm_monitor_diagnostic_setting" "aks_monitoring" {
  name                         = "aksmonitor"
  target_resource_id           = azurerm_kubernetes_cluster.aks_cluster.id
  log_analytics_workspace_id   = azurerm_log_analytics_workspace.log_analytics.id

  logs {
    category = "kube-apiserver"
    enabled  = true
  }

  logs {
    category = "kube-controller-manager"
    enabled  = true
  }

  logs {
    category = "kube-scheduler"
    enabled  = true
  }

  logs {
    category = "kube-audit"
    enabled  = true
  }
}
