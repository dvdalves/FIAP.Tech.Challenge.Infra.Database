# ==============================================================================
# SECRETS MANAGEMENT - AWS SECRETS MANAGER & SSM PARAMETER STORE
# ==============================================================================

# Geração automática de senha forte e segura caso não seja informada explicitamente
resource "random_password" "db_password" {
  length           = 24
  special          = false
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

locals {
  effective_db_password = var.db_password != "" ? var.db_password : random_password.db_password.result
}

# AWS Secrets Manager Secret para armazenar as credenciais completas
resource "aws_secretsmanager_secret" "db_credentials" {
  name                    = "oficina/${var.environment}/database/credentials"
  description             = "Credenciais de acesso master ao PostgreSQL RDS da Oficina Mecanica"
  recovery_window_in_days = 0

  tags = {
    Name = "${var.db_identifier}-credentials"
  }
}

resource "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    engine            = "postgres"
    host              = aws_db_instance.postgres.address
    port              = aws_db_instance.postgres.port
    database          = var.db_name
    username          = var.db_username
    password          = local.effective_db_password
    connection_string = "Host=${aws_db_instance.postgres.address};Port=${aws_db_instance.postgres.port};Database=${var.db_name};Username=${var.db_username};Password=${local.effective_db_password};"
  })
}

# SSM Parameter Store para facilitar a injeção em ConfigMaps / Secrets no Kubernetes
resource "aws_ssm_parameter" "db_connection_string" {
  name        = "/oficina/${var.environment}/database/connection_string"
  description = "Connection string oficial para a API e Lambda"
  type        = "SecureString"
  value       = "Host=${aws_db_instance.postgres.address};Port=${aws_db_instance.postgres.port};Database=${var.db_name};Username=${var.db_username};Password=${local.effective_db_password};"

  tags = {
    Name = "${var.db_identifier}-conn-str"
  }
}
