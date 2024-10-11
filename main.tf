# main.tf

# Specify the provider
provider "azurerm" {
  features {}
}

# Define a resource group
resource "azurerm_resource_group" "aks_rg" {
  name     = var.resource_group_name
  location = var.location
}

# Define a virtual network
resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.resource_group_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.aks_rg.name
}

# Define a subnet for AKS
resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.resource_group_name}-subnet"
  resource_group_name  = azurerm_resource_group.aks_rg.name
  virtual_network_name = azurerm_virtual_network.aks_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Define Azure Kubernetes Service (AKS)
resource "azurerm_kubernetes_cluster" "aks_cluster" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.aks_rg.location
  resource_group_name = azurerm_resource_group.aks_rg.name
  dns_prefix          = "aks"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.aks_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
  }
}

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
