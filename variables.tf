variable "location" {
  type        = string
  description = "location of the RG"
  default     = "east-us"
}

variable "address_space" {
  default = ["10.1.0.0/16", "10.1.0.0/24", "10.1.0.0/32"]
}
locals {
  common_name = "azure-k8s"
}
variable "dns_prefix" {
  default = "azurek8sdemo"
}

variable "agent_pool" {
  default = ["defaultpool", "standard_D2s_v3"]
}

variable "clientid" {
  default = ""
}
variable "clientsecret" {
  default = ""
}

variable "tags" {
  default = {
    terraform = "yes"
    resource  = "AKS"
    purpose   = "test"

  }
}
variable "network_profile" {
  default = ["azure", "kubenet", "standard"]
}