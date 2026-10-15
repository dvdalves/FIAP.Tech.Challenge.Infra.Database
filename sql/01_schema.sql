-- ==============================================================================
-- SCHEMA DEFINITION - BANCO DE DADOS RELACIONAL SIAES (POSTGRESQL 16)
-- Tech Challenge SOAT FIAP - Fase 3
-- ==============================================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- 1. TABELA DE CLIENTES
CREATE TABLE IF NOT EXISTS "Clientes" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "Nome" VARCHAR(100) NOT NULL,
    "Cpf" VARCHAR(11) NOT NULL,
    "Email" VARCHAR(150) NOT NULL,
    "Telefone" VARCHAR(20) NOT NULL,
    "CriadoEm" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Índice único para otimizar busca por CPF na autenticação via Lambda
CREATE UNIQUE INDEX IF NOT EXISTS "IX_Clientes_Cpf" ON "Clientes" ("Cpf");

-- 2. TABELA DE VEÍCULOS
CREATE TABLE IF NOT EXISTS "Veiculos" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "Placa" VARCHAR(10) NOT NULL,
    "Modelo" VARCHAR(100) NOT NULL,
    "Marca" VARCHAR(50) NOT NULL,
    "Ano" INTEGER NOT NULL,
    "ClienteId" UUID NOT NULL,
    "CriadoEm" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    CONSTRAINT "FK_Veiculos_Clientes" FOREIGN KEY ("ClienteId")
        REFERENCES "Clientes" ("Id") ON DELETE CASCADE
);

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Veiculos_Placa" ON "Veiculos" ("Placa");
CREATE INDEX IF NOT EXISTS "IX_Veiculos_ClienteId" ON "Veiculos" ("ClienteId");

-- 3. CATÁLOGO DE SERVIÇOS (MÃO DE OBRA TABELADA)
CREATE TABLE IF NOT EXISTS "Servicos" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "Codigo" VARCHAR(20) NOT NULL,
    "Descricao" VARCHAR(200) NOT NULL,
    "ValorMaoDeObra" NUMERIC(10,2) NOT NULL,
    "TempoEstimadoMinutos" INTEGER NOT NULL DEFAULT 60,
    CONSTRAINT "CK_Servicos_ValorPositivo" CHECK ("ValorMaoDeObra" >= 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Servicos_Codigo" ON "Servicos" ("Codigo");

-- 4. ESTOQUE DE PEÇAS & INSUMOS
CREATE TABLE IF NOT EXISTS "Pecas" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "Codigo" VARCHAR(20) NOT NULL,
    "Descricao" VARCHAR(200) NOT NULL,
    "PrecoUnitario" NUMERIC(10,2) NOT NULL,
    "QuantidadeEstoque" INTEGER NOT NULL DEFAULT 0,
    "EstoqueMinimo" INTEGER NOT NULL DEFAULT 5,
    CONSTRAINT "CK_Pecas_PrecoPositivo" CHECK ("PrecoUnitario" >= 0),
    CONSTRAINT "CK_Pecas_EstoqueNaoNegativo" CHECK ("QuantidadeEstoque" >= 0)
);

CREATE UNIQUE INDEX IF NOT EXISTS "IX_Pecas_Codigo" ON "Pecas" ("Codigo");

-- 5. ORDENS DE SERVIÇO (AGREGADO PRINCIPAL)
CREATE TABLE IF NOT EXISTS "OrdensServico" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "Numero" BIGSERIAL UNIQUE,
    "Status" VARCHAR(50) NOT NULL,
    "DataAbertura" TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    "DataDiagnostico" TIMESTAMP WITH TIME ZONE NULL,
    "DataFinalizacao" TIMESTAMP WITH TIME ZONE NULL,
    "DataEntrega" TIMESTAMP WITH TIME ZONE NULL,
    "ValorTotal" NUMERIC(12,2) NOT NULL DEFAULT 0.00,
    "ClienteId" UUID NOT NULL,
    "VeiculoId" UUID NOT NULL,
    "Observacoes" TEXT NULL,
    CONSTRAINT "FK_OrdensServico_Clientes" FOREIGN KEY ("ClienteId")
        REFERENCES "Clientes" ("Id"),
    CONSTRAINT "FK_OrdensServico_Veiculos" FOREIGN KEY ("VeiculoId")
        REFERENCES "Veiculos" ("Id")
);

CREATE INDEX IF NOT EXISTS "IX_OrdensServico_ClienteId" ON "OrdensServico" ("ClienteId");
CREATE INDEX IF NOT EXISTS "IX_OrdensServico_Status" ON "OrdensServico" ("Status");
CREATE INDEX IF NOT EXISTS "IX_OrdensServico_DataAbertura" ON "OrdensServico" ("DataAbertura");

-- 6. ITENS DA ORDEM DE SERVIÇO (PEÇAS E SERVIÇOS COMPONENTES)
CREATE TABLE IF NOT EXISTS "ItensOrdemServico" (
    "Id" UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    "OrdemServicoId" UUID NOT NULL,
    "TipoItem" VARCHAR(20) NOT NULL,
    "ServicoId" UUID NULL,
    "PecaId" UUID NULL,
    "Quantidade" INTEGER NOT NULL DEFAULT 1,
    "ValorUnitario" NUMERIC(10,2) NOT NULL,
    "Subtotal" NUMERIC(10,2) NOT NULL,
    CONSTRAINT "FK_ItensOrdemServico_OrdemServico" FOREIGN KEY ("OrdemServicoId")
        REFERENCES "OrdensServico" ("Id") ON DELETE CASCADE,
    CONSTRAINT "FK_ItensOrdemServico_Servico" FOREIGN KEY ("ServicoId")
        REFERENCES "Servicos" ("Id"),
    CONSTRAINT "FK_ItensOrdemServico_Peca" FOREIGN KEY ("PecaId")
        REFERENCES "Pecas" ("Id"),
    CONSTRAINT "CK_Itens_QuantidadePositiva" CHECK ("Quantidade" > 0)
);

CREATE INDEX IF NOT EXISTS "IX_ItensOrdemServico_OrdemServicoId" ON "ItensOrdemServico" ("OrdemServicoId");
