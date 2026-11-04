resource "random_password" "db_password" {
  length           = 24
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  effective_db_password = var.db_password != "" ? var.db_password : random_password.db_password.result
  connection_string     = "Host=${azurerm_postgresql_flexible_server.postgres.fqdn};Port=5432;Database=${var.db_name};Username=${var.db_username};Password=${local.effective_db_password};Ssl Mode=Require;"
}

resource "azurerm_key_vault" "main" {
  name                       = "${var.db_identifier}-kv"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  purge_protection_enabled   = var.deletion_protection
  soft_delete_retention_days = 7

  access_policy {
    tenant_id          = data.azurerm_client_config.current.tenant_id
    object_id          = data.azurerm_client_config.current.object_id
    secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "database-connection-string"
  value        = local.connection_string
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  value        = local.effective_db_password
  key_vault_id = azurerm_key_vault.main.id
}
