variable "location" {
  type        = string
  description = "location of the RG"
  default     = "eastus"
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
  default = "7e6b1379-e664-45d7-be0d-120ce3eab0df"
}
variable "clientsecret" {
  default = "JSm8Q~iCFwlAGazpfquZAeuuWfz4obY.RoYmYcMq"
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