resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = var.db_identifier
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = var.engine_version
  administrator_login           = var.db_username
  administrator_password        = local.effective_db_password
  sku_name                      = var.db_instance_class
  storage_mb                    = var.allocated_storage * 1024
  storage_tier                  = "P4"
  backup_retention_days         = var.backup_retention_period
  geo_redundant_backup_enabled  = var.multi_az
  auto_grow_enabled             = true
  public_network_access_enabled = true
  dynamic "high_availability" {
    for_each = var.multi_az ? [1] : []

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = "2"
    }
  }
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "public_access" {
  name             = "allow-public-access"
  server_id        = azurerm_postgresql_flexible_server.postgres.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

resource "azurerm_postgresql_flexible_server_database" "oficina" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
