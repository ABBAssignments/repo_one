# service_principal.tf

# Create an Azure AD Service Principal for AKS
resource "azurerm_ad_application" "aks_app" {
  display_name = "${var.resource_group_name}-aks-app"
  homepage     = "http://${var.resource_group_name}.com"
}

resource "azurerm_ad_service_principal" "aks_sp" {
  application_id = azurerm_ad_application.aks_app.application_id
}
