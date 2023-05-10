resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environment}-aks-cluster"
  location            = var.location
  resource_group_name = var.rg_name
  dns_prefix          = "${var.environment}-${var.dns_prefix}-cluster"

  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.vm_size  # "Standard_D2_v2" B4ms
  }

  identity {
    type = "SystemAssigned"
  }

  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.aks.id
  }

  tags = {
    Creator   = "Terraform"
    Environment = var.environment
  }
}

resource "azurerm_log_analytics_workspace" "aks" {
  name                = "${var.prefix}-law"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  sku                 = "PerGB2018"
}

resource "azurerm_log_analytics_solution" "aks" {
  solution_name         = "Containers"
  workspace_resource_id = azurerm_log_analytics_workspace.aks.id
  workspace_name        = azurerm_log_analytics_workspace.aks.name
  location              = azurerm_resource_group.aks.location
  resource_group_name   = azurerm_resource_group.aks.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/Containers"
  }
}

