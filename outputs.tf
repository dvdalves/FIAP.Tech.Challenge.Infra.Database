output "db_fqdn" {
  description = "Hostname privado do PostgreSQL"
  value       = azurerm_postgresql_flexible_server.postgres.fqdn
}

output "db_name" {
  description = "Nome do banco de dados"
  value       = var.db_name
}

output "db_username" {
  description = "Usuário administrador"
  value       = var.db_username
}

output "resource_group_name" {
  description = "Resource Group do banco"
  value       = azurerm_resource_group.main.name
}

output "key_vault_name" {
  description = "Key Vault com os segredos do banco"
  value       = azurerm_key_vault.main.name
}

output "connection_string" {
  description = "Connection string PostgreSQL para a API e autenticação"
  value       = local.connection_string
  sensitive   = true
}
