variable "azure_region" {
  description = "Região do Azure para provisionamento do PostgreSQL"
  type        = string
  default     = "Brazil South"
}

variable "resource_group_name" {
  description = "Resource Group do banco"
  type        = string
  default     = "fiap-tech-challenge-db-rg"
}

variable "environment" {
  description = "Ambiente de execução (ex: homolog, production)"
  type        = string
  default     = "production"
}

variable "db_identifier" {
  description = "Nome único do Azure Database for PostgreSQL"
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
  description = "Senha master do banco (se vazia, gerada aleatoriamente e armazenada no Key Vault)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_instance_class" {
  description = "SKU do Azure Database for PostgreSQL"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "allocated_storage" {
  description = "Armazenamento alocado inicial em GiB"
  type        = number
  default     = 32
}

variable "max_allocated_storage" {
  description = "Limite superior de armazenamento autoexpansível em GiB"
  type        = number
  default     = 50
}

variable "engine_version" {
  description = "Versão do PostgreSQL no Azure"
  type        = string
  default     = "16"
}

variable "vnet_name" {
  description = "Nome da VNet privada do banco"
  type        = string
  default     = "fiap-db-vnet"
}

variable "vnet_address_space" {
  description = "Espaço CIDR da VNet"
  type        = list(string)
  default     = ["10.1.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "CIDR da subnet delegada ao PostgreSQL"
  type        = string
  default     = "10.1.1.0/24"
}

variable "backup_retention_period" {
  description = "Período de retenção de backups automatizados em dias"
  type        = number
  default     = 7
}

variable "multi_az" {
  description = "Habilitar alta disponibilidade zone-redundant"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Habilitar proteção contra deleção acidental"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Mantido por compatibilidade; Azure usa retenção de backup"
  type        = bool
  default     = true
}

variable "enable_performance_insights" {
  description = "Habilitar métricas e diagnósticos do Azure Monitor"
  type        = bool
  default     = true
}
