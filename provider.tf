provider "azurerm" {
  version = "3.78"
  features {}
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
