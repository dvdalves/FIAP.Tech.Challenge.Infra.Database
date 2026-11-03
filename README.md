# FIAP Tech Challenge — Infraestrutura do Banco de Dados

[![CI/CD Pipeline](https://github.com/dvdalves/FIAP.Tech.Challenge.Infra.Database/actions/workflows/ci-cd.yml/badge.svg)](https://github.com/dvdalves/FIAP.Tech.Challenge.Infra.Database/actions/workflows/ci-cd.yml)

Repositório Terraform responsável pelo provisionamento do PostgreSQL gerenciado no Azure, pelo armazenamento seguro das credenciais e pelos scripts SQL do banco do SIAES.

## Sumário

1. [Responsabilidade](#1-responsabilidade)
2. [Tecnologias](#2-tecnologias)
3. [Banco de Dados](#3-banco-de-dados)
4. [Como Provisionar](#4-como-provisionar)
5. [Scripts SQL](#5-scripts-sql)
6. [CI/CD](#6-cicd)

## 1. Responsabilidade

- Provisionar o Azure Database for PostgreSQL.
- Configurar rede privada e regras de acesso ao banco.
- Armazenar credenciais e connection strings no Azure Key Vault.
- Versionar scripts de schema e seed.

## 2. Tecnologias

- Terraform `>= 1.5.0`.
- Azure Database for PostgreSQL Flexible Server.
- Azure Key Vault.
- Azure VNet e subnets privadas.
- PostgreSQL SQL.
- GitHub Actions.

## 3. Banco de Dados

O modelo relacional contém clientes, veículos, serviços, peças, ordens de serviço e seus itens. O schema e os dados iniciais estão em [`sql/`](sql/).

O acesso público deve permanecer desabilitado. Aplicações autorizadas acessam o banco pela rede privada e obtêm credenciais por identidade gerenciada ou secret configurado no ambiente.

## 4. Como Provisionar

### Pré-requisitos

- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads).
- [Azure CLI](https://learn.microsoft.com/cli/azure/) autenticado com `az login`.
- Permissões Azure para criar e alterar os recursos.

### Execução

```bash
cp terraform.tfvars.example terraform.tfvars
```

Preencha o arquivo local com os valores do ambiente. Não publique `terraform.tfvars`, arquivos de estado ou credenciais.

```bash
terraform init
terraform fmt -check
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

## 5. Scripts SQL

Os scripts estão em [`sql/`](sql/):

- `01_schema.sql`: criação do schema.
- `02_seed.sql`: carga inicial de dados.

Em ambientes provisionados, execute os scripts apenas quando o fluxo de implantação não utilizar as migrations da aplicação. O banco usado pela API principal é atualizado automaticamente pelo EF Core durante a inicialização.

## 6. CI/CD

O workflow [`.github/workflows/ci-cd.yml`](.github/workflows/ci-cd.yml) executa formatação, validação e planejamento do Terraform. O deploy utiliza credenciais configuradas como secrets do GitHub e não valores versionados.
