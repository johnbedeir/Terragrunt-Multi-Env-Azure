variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for the name of resources"
  type        = string
  default     = "cluster-1"
}

variable "environment" {
  description = "Environment name (e.g., dev, staging, prod)"
  type        = string
}

variable "location" {
  description = "Azure region to deploy the resources"
  type        = string
}

variable "client_id" {
  description = "The Azure Client Id"
  type        = string
}

variable "client_secret" {
  description = "The Azure Client Secret"
  type        = string
}

variable "db_username" {
  description = "The Azure SQL Server Username"
  type        = string
}

variable "database_name" {
  description = "The Azure SQL Server Username"
  type        = string
  default     = "todo_db"
}

variable "vpc_address_space" {
  description = "Azure VPC"
  type        = list(string)
}

variable "public_subnet" {
  description = "Azure public subnet"
  type        = list(string)
}

variable "private_subnet" {
  description = "Azure private subnet"
  type        = list(string)
}

variable "destination_address_prefix" {
  description = "Azure destination_address_prefix"
  type        = string
}

variable "aks_service_cidr" {
  description = "Azure AKS Service Cidr"
  type        = string
}

variable "aks_dns_service_ip" {
  description = "Azure AKS DNS Service IP"
  type        = string
}

variable "dns_servers" {
  description = "Azure DNS Servers"
  type        = list(string)
}