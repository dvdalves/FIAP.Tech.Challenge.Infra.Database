# ==============================================================================
# RESOLUÇÃO DINÂMICA DE REDE & SECURITY GROUP DO RDS
# ==============================================================================

data "aws_vpc" "default" {
  count   = var.vpc_id == "" ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = length(var.private_subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id]
  }
}

locals {
  vpc_id     = var.vpc_id != "" ? var.vpc_id : data.aws_vpc.default[0].id
  subnet_ids = length(var.private_subnet_ids) > 0 ? var.private_subnet_ids : data.aws_subnets.default[0].ids
}

# DB Subnet Group isolado para o RDS
resource "aws_db_subnet_group" "rds" {
  name        = "${var.db_identifier}-subnet-group"
  description = "Subnet group privado para a instancia RDS PostgreSQL do SIAES"
  subnet_ids  = local.subnet_ids

  tags = {
    Name = "${var.db_identifier}-subnet-group"
  }
}

# Security Group com acesso restrito a partir da rede da aplicação (Kubernetes / Lambda)
resource "aws_security_group" "rds_postgres" {
  name        = "${var.db_identifier}-sg"
  description = "Security Group restrito para acesso ao banco PostgreSQL na porta 5432"
  vpc_id      = local.vpc_id

  ingress {
    description = "Acesso PostgreSQL a partir do bloco CIDR da aplicacao"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    description = "Saida irrestrita para comunicacao de monitoramento e patches"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.db_identifier}-sg"
  }
}
