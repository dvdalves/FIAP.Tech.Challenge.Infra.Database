variable "aws_region" {
  description = "Região da AWS para provisionamento do banco de dados RDS"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Ambiente de execução (ex: homolog, production)"
  type        = string
  default     = "production"
}

variable "db_identifier" {
  description = "Identificador único da instância RDS PostgreSQL"
  type        = string
  default     = "oficina-postgres-db"
}

variable "db_name" {
  description = "Nome do banco de dados inicial a ser criado"
  type        = string
  default     = "oficina_db"
}

variable "db_username" {
  description = "Nome do usuário administrador master do banco"
  type        = string
  default     = "oficina_admin"
}

variable "db_password" {
  description = "Senha master do banco (se vazia, gerada aleatoriamente via Secrets Manager)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_instance_class" {
  description = "Classe de instância do AWS RDS"
  type        = string
  default     = "db.t4g.micro"
}

variable "allocated_storage" {
  description = "Armazenamento alocado inicial em GiB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Limite superior para armazenamento elástico autoescalável em GiB"
  type        = number
  default     = 50
}

variable "engine_version" {
  description = "Versão do PostgreSQL no RDS"
  type        = string
  default     = "16.3"
}

variable "vpc_id" {
  description = "ID da VPC onde o banco será alocado (se vazio, usa a VPC padrão)"
  type        = string
  default     = ""
}

variable "private_subnet_ids" {
  description = "Lista de IDs de subnets privadas para o DB Subnet Group (se vazia, busca as subnets da VPC)"
  type        = list(string)
  default     = []
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC permitido para tráfego na porta 5432"
  type        = string
  default     = "10.0.0.0/16"
}

variable "backup_retention_period" {
  description = "Período de retenção de backups automatizados em dias"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Habilitar alta disponibilidade Multi-AZ com réplica síncrona de failover"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Habilitar proteção contra deleção acidental da instância RDS"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Pular snapshot final na destruição (true para ambientes de teste e validação)"
  type        = bool
  default     = true
}

variable "enable_performance_insights" {
  description = "Habilitar Performance Insights para análise de queries lentas e gargalos"
  type        = bool
  default     = true
}
