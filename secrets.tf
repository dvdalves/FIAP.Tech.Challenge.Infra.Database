resource "random_password" "db_password" {
  length           = 24
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  effective_db_password = var.db_password != "" ? var.db_password : random_password.db_password.result
  connection_string = format(
    "Host=%s;Port=5432;Database=%s;Username=%s;Password=%s;Ssl Mode=Require;",
    azurerm_postgresql_flexible_server.postgres.fqdn,
    var.db_name,
    var.db_username,
    local.effective_db_password
  )
}

resource "azurerm_key_vault" "main" {
  name                       = "${var.db_identifier}-kv"
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false
  purge_protection_enabled   = var.deletion_protection
  soft_delete_retention_days = 7

}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault_access_policy" "terraform" {
  key_vault_id       = azurerm_key_vault.main.id
  tenant_id          = data.azurerm_client_config.current.tenant_id
  object_id          = data.azurerm_client_config.current.object_id
  secret_permissions = ["Get", "List", "Set", "Delete", "Recover", "Restore"]
}

resource "azurerm_key_vault_secret" "db_connection_string" {
  name         = "database-connection-string"
  value        = local.connection_string
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_key_vault_access_policy.terraform]
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "database-password"
  value        = local.effective_db_password
  key_vault_id = azurerm_key_vault.main.id
  depends_on   = [azurerm_key_vault_access_policy.terraform]
}
