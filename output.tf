output "id" {
  value     = azurerm_kubernetes_cluster.k8s_cluster.id
  sensitive = true
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s_cluster.kube_config_raw

  sensitive = true
}