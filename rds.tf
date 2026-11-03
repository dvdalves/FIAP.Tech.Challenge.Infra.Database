resource "azurerm_postgresql_flexible_server" "postgres" {
  name                          = var.db_identifier
  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  version                       = var.engine_version
  delegated_subnet_id           = azurerm_subnet.postgres.id
  private_dns_zone_id           = azurerm_private_dns_zone.postgres.id
  administrator_login           = var.db_username
  administrator_password        = local.effective_db_password
  zone                          = "1"
  sku_name                      = var.db_instance_class
  storage_mb                    = var.allocated_storage * 1024
  storage_tier                  = "P4"
  backup_retention_days         = var.backup_retention_period
  geo_redundant_backup_enabled  = var.multi_az
  auto_grow_enabled             = true
  public_network_access_enabled = false
  dynamic "high_availability" {
    for_each = var.multi_az ? [1] : []

    content {
      mode                      = "ZoneRedundant"
      standby_availability_zone = "2"
    }
  }

  depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
}

resource "azurerm_postgresql_flexible_server_database" "oficina" {
  name      = var.db_name
  server_id = azurerm_postgresql_flexible_server.postgres.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}
