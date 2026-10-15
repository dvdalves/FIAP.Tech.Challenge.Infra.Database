output "db_endpoint" {
  description = "Endpoint completo (host:porta) da instância PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

output "db_address" {
  description = "Hostname de conexão do PostgreSQL"
  value       = aws_db_instance.postgres.address
}

output "db_port" {
  description = "Porta de conexão do PostgreSQL"
  value       = aws_db_instance.postgres.port
}

output "db_name" {
  description = "Nome do banco de dados relacional"
  value       = var.db_name
}

output "db_username" {
  description = "Usuário master do banco de dados"
  value       = var.db_username
}

output "db_security_group_id" {
  description = "ID do Security Group associado ao banco de dados"
  value       = aws_security_group.rds_postgres.id
}

output "db_subnet_group_name" {
  description = "Nome do DB Subnet Group"
  value       = aws_db_subnet_group.rds.name
}

output "db_secret_arn" {
  description = "ARN do segredo no AWS Secrets Manager contendo as credenciais do banco"
  value       = aws_secretsmanager_secret.db_credentials.arn
}

output "ssm_connection_string_name" {
  description = "Nome do parâmetro no SSM Parameter Store com o connection string"
  value       = aws_ssm_parameter.db_connection_string.name
}

output "connection_string" {
  description = "Connection string oficial formatada para o EF Core e Npgsql"
  value       = "Host=${aws_db_instance.postgres.address};Port=${aws_db_instance.postgres.port};Database=${var.db_name};Username=${var.db_username};Password=${local.effective_db_password};"
  sensitive   = true
}
