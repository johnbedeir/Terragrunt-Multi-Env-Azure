data "azuread_service_principal" "aks" {
  client_id = azurerm_kubernetes_cluster.aks.kubelet_identity[0].client_id
}

resource "azurerm_role_assignment" "aks_contributor" {
  scope                = azurerm_resource_group.aks.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}


resource "azurerm_resource_group" "aks" {
  name     = "${var.name_prefix}-${var.environment}-rg"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.environment}-${var.name_prefix}-aks"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "${var.environment}-${var.name_prefix}-dns"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
    vnet_subnet_id = azurerm_subnet.private_subnet.id
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "calico"
    service_cidr       = var.aks_service_cidr
    dns_service_ip     = var.aks_dns_service_ip
    outbound_type     = "loadBalancer"
  }
}

resource "random_shuffle" "availability_zones" {
  input = ["1", "2", "3"]
  result_count = 1
}

resource "azurerm_kubernetes_cluster_node_pool" "primary_nodes" {
  name                = "${substr(var.environment, 0, 3)}np"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size             = "Standard_DS2_v2"
  node_count          = 3
  vnet_subnet_id      = azurerm_subnet.private_subnet.id

  enable_auto_scaling = true
  min_count           = 3
  max_count           = 5
}

resource "helm_release" "cluster_autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.19.0"

  namespace = "kube-system"

  set {
    name  = "cloud-provider"
    value = "azure"
  }

  set {
    name  = "azure-client-id"
    value = var.client_id
  }

  set {
    name  = "azure-client-secret"
    value = var.client_secret
  }

  set {
    name  = "azureResourceGroup"
    value = azurerm_resource_group.aks.name
  }

  set {
    name  = "azure-vm-type"
    value = "AKS"
  }

  set {
    name  = "azure-subscription-id"
    value = var.subscription_id
  }

  set {
    name  = "azure-tenant-id"
    value = var.tenant_id
  }

  set {
    name  = "azure-cluster-name"
    value = azurerm_kubernetes_cluster.aks.name
  }

  set {
    name  = "cloud-config"
    value = "/etc/kubernetes/azure.json"
  }
}

