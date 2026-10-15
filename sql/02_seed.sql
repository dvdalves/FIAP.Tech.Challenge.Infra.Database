-- ==============================================================================
-- SEED DATA - DADOS INICIAIS DE TESTE E DEMONSTRAÇÃO (POSTGRESQL 16)
-- Tech Challenge SOAT FIAP - Fase 3
-- ==============================================================================

-- 1. CLIENTES (CPFs matematicamente válidos para teste com a Lambda de Autenticação)
INSERT INTO "Clientes" ("Id", "Nome", "Cpf", "Email", "Telefone") VALUES
('11111111-1111-1111-1111-111111111111', 'Carlos Alberto Silva (Teste)', '52998224725', 'carlos.silva@example.com', '11987654321'),
('22222222-2222-2222-2222-222222222222', 'Ana Beatriz Souza (Teste)', '12345678909', 'ana.souza@example.com', '11912345678'),
('33333333-3333-3333-3333-333333333333', 'Rodrigo Mendes Lima (Teste)', '26987158079', 'rodrigo.mendes@example.com', '11977778888')
ON CONFLICT ("Cpf") DO NOTHING;

-- 2. VEÍCULOS
INSERT INTO "Veiculos" ("Id", "Placa", "Modelo", "Marca", "Ano", "ClienteId") VALUES
('44444444-4444-4444-4444-444444444444', 'ABC1D23', 'Civic Touring 1.5 Turbo', 'Honda', 2021, '11111111-1111-1111-1111-111111111111'),
('55555555-5555-5555-5555-555555555555', 'XYZ9E87', 'Corolla Altis Hybrid', 'Toyota', 2022, '22222222-2222-2222-2222-222222222222'),
('66666666-6666-6666-6666-666666666666', 'BRA2E19', 'Compass Longitude 1.3 T270', 'Jeep', 2023, '33333333-3333-3333-3333-333333333333')
ON CONFLICT ("Placa") DO NOTHING;

-- 3. CATÁLOGO DE SERVIÇOS
INSERT INTO "Servicos" ("Id", "Codigo", "Descricao", "ValorMaoDeObra", "TempoEstimadoMinutos") VALUES
('77777777-7777-7777-7777-777777777771', 'SRV-001', 'Troca de Óleo e Filtro de Motor', 120.00, 45),
('77777777-7777-7777-7777-777777777772', 'SRV-002', 'Alinhamento e Balanceamento 3D', 180.00, 60),
('77777777-7777-7777-7777-777777777773', 'SRV-003', 'Substituição de Pastilhas de Freio Dianteiras', 150.00, 90),
('77777777-7777-7777-7777-777777777774', 'SRV-004', 'Diagnóstico Computadorizado com Scanner OBD-II', 200.00, 30),
('77777777-7777-7777-7777-777777777775', 'SRV-005', 'Revisão Geral Preventiva Periódica', 450.00, 180)
ON CONFLICT ("Codigo") DO NOTHING;

-- 4. CATÁLOGO E ESTOQUE DE PEÇAS
INSERT INTO "Pecas" ("Id", "Codigo", "Descricao", "PrecoUnitario", "QuantidadeEstoque", "EstoqueMinimo") VALUES
('88888888-8888-8888-8888-888888888881', 'PEC-001', 'Óleo Sintético 5W30 (Litro)', 55.00, 120, 20),
('88888888-8888-8888-8888-888888888882', 'PEC-002', 'Filtro de Óleo Blindado Fram', 42.50, 45, 10),
('88888888-8888-8888-8888-888888888883', 'PEC-003', 'Jogo de Pastilhas de Freio Cerâmica', 260.00, 25, 5),
('88888888-8888-8888-8888-888888888884', 'PEC-004', 'Filtro de Ar Condicionado / Cabine', 38.00, 30, 8),
('88888888-8888-8888-8888-888888888885', 'PEC-005', 'Fluido de Freio DOT 4 (500ml)', 32.00, 40, 10)
ON CONFLICT ("Codigo") DO NOTHING;

-- 5. ORDEM DE SERVIÇO DE EXEMPLO
INSERT INTO "OrdensServico" ("Id", "Status", "DataAbertura", "DataDiagnostico", "ValorTotal", "ClienteId", "VeiculoId", "Observacoes") VALUES
('99999999-9999-9999-9999-999999999999', 'Diagnostico', NOW(), NOW(), 489.50, '11111111-1111-1111-1111-111111111111', '44444444-4444-4444-4444-444444444444', 'Cliente relata ruído no pedal de freio dianteiro durante frenagens suaves.')
ON CONFLICT ("Id") DO NOTHING;

-- 6. ITENS DA ORDEM DE SERVIÇO
INSERT INTO "ItensOrdemServico" ("Id", "OrdemServicoId", "TipoItem", "ServicoId", "PecaId", "Quantidade", "ValorUnitario", "Subtotal") VALUES
(uuid_generate_v4(), '99999999-9999-9999-9999-999999999999', 'Servico', '77777777-7777-7777-7777-777777777773', NULL, 1, 150.00, 150.00),
(uuid_generate_v4(), '99999999-9999-9999-9999-999999999999', 'Peca', NULL, '88888888-8888-8888-8888-888888888883', 1, 260.00, 260.00),
(uuid_generate_v4(), '99999999-9999-9999-9999-999999999999', 'Peca', NULL, '88888888-8888-8888-8888-888888888885', 1, 32.00, 32.00),
(uuid_generate_v4(), '99999999-9999-9999-9999-999999999999', 'Peca', NULL, '88888888-8888-8888-8888-888888888882', 1, 47.50, 47.50)
ON CONFLICT ("Id") DO NOTHING;
