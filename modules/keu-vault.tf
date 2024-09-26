data "azurerm_client_config" "current" {}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "azurerm_key_vault" "key_vault" {
  name                        = "${var.environment}-${var.name_prefix}-kv"
  location                    = azurerm_resource_group.aks.location
  resource_group_name         = azurerm_resource_group.aks.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge",
    ]
  }

  tags = {
    environment = var.environment
  }
}

resource "azurerm_key_vault_secret" "db_username" {
  name         = "${var.environment}-${var.name_prefix}-db-username"
  value        = var.db_username
  key_vault_id = azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "${var.environment}-${var.name_prefix}-db-password"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.key_vault.id
}