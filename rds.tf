# ==============================================================================
# AWS RDS POSTGRESQL (BANCO DE DADOS RELACIONAL GERENCIADO)
# ==============================================================================

resource "aws_db_parameter_group" "postgres" {
  name        = "${var.db_identifier}-pg16-params"
  family      = "postgres16"
  description = "Parametros customizados para PostgreSQL 16 com logs de performance"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_lock_waits"
    value = "1"
  }

  # Registrar queries que demorem mais de 500ms para diagnostico de performance
  parameter {
    name  = "log_min_duration_statement"
    value = "500"
  }

  tags = {
    Name = "${var.db_identifier}-pg16-params"
  }
}

resource "aws_db_instance" "postgres" {
  identifier                   = var.db_identifier
  engine                       = "postgres"
  engine_version               = var.engine_version
  instance_class               = var.db_instance_class
  allocated_storage            = var.allocated_storage
  max_allocated_storage        = var.max_allocated_storage
  storage_type                 = "gp3"
  db_name                      = var.db_name
  username                     = var.db_username
  password                     = local.effective_db_password
  db_subnet_group_name         = aws_db_subnet_group.rds.name
  vpc_security_group_ids       = [aws_security_group.rds_postgres.id]
  parameter_group_name         = aws_db_parameter_group.postgres.name
  publicly_accessible          = false
  multi_az                     = var.multi_az
  backup_retention_period      = var.backup_retention_period
  backup_window                = "03:00-04:00"
  maintenance_window           = "Sun:04:30-Sun:05:30"
  auto_minor_version_upgrade   = true
  deletion_protection          = var.deletion_protection
  skip_final_snapshot          = var.skip_final_snapshot
  performance_insights_enabled = var.enable_performance_insights

  tags = {
    Name = var.db_identifier
  }
}
