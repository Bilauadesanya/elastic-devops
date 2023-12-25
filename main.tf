
resource "azurerm_resource_group" "azure_k8s" {
  name     = local.common_name
  location = var.location
  tags     = var.tags
}

resource "random_id" "azure_random" {
  byte_length = 8
}
resource "azurerm_log_analytics_workspace" "azure_workspace" {

  location            = var.location
  name                = "k8s-workspace-${random_id.azure_random.hex}"
  resource_group_name = azurerm_resource_group.azure_k8s.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}
resource "azurerm_log_analytics_solution" "Azure_solution" {
  solution_name         = "ContainerInsights"
  location              = azurerm_resource_group.azure_k8s.location
  resource_group_name   = azurerm_resource_group.azure_k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.azure_workspace.id
  workspace_name        = azurerm_log_analytics_workspace.azure_workspace.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_virtual_network" "vnet" {
  address_space       = [element(var.address_space, 0)]
  location            = var.location
  name                = "${local.common_name}-vnet"
  resource_group_name = azurerm_resource_group.azure_k8s.name
}
resource "azurerm_subnet" "subnet" {
  address_prefixes     = [element(var.address_space,1)]
  name                 = "${local.common_name}-subnet"
  resource_group_name  = azurerm_resource_group.azure_k8s.name
  virtual_network_name = azurerm_virtual_network.vnet.name
}

resource "azurerm_public_ip" "public_ip" {
  allocation_method   = "Static"
  location            = var.location
  name                = "${local.common_name}-public_ip"
  resource_group_name = azurerm_resource_group.azure_k8s.name
  sku = var.publicip_sku[1]
}



resource "azurerm_kubernetes_cluster" "k8s_cluster" {
  location            = var.location
  name                = "${local.common_name}-k8s_cluster"
  resource_group_name = azurerm_resource_group.azure_k8s.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = "1.26"

  default_node_pool {
    name              = var.agent_pool[0]
    vm_size           = var.agent_pool[1]
    node_count        = 2

  }

  service_principal {
    client_id     = var.clientid
    client_secret = var.clientsecret
  }




  lifecycle {
      ignore_changes = [
        windows_profile, default_node_pool
      ]
    }


}


resource "azurerm_network_profile" "network8s" {
  name                = "${local.common_name}-network8s"
  location            = var.location
  resource_group_name = azurerm_resource_group.azure_k8s.name

  container_network_interface {
    name = "${local.common_name}-nic"

    ip_configuration {
      name      = "${local.common_name}-ipconfig"
      subnet_id = azurerm_subnet.subnet.id
    }
  }
}
#resource "helm_release" "my-kubernetes-dashboard" {
#
#  name = "${local.common_name}-kubernetes_dashboard"
#
#  repository = "https://kubernetes.github.io/dashboard/"
#  chart      = "kubernetes-dashboard"
#  namespace  = "kube-dashboard"
#
#
#  set {
#    name  = "metricsScraper.enabled"
#    value = "true"
#  }
#}