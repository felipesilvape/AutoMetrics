INSERT INTO motorista (nome, idade, cnh, cat_cnh) VALUES
('Carlos Eduardo Mendes', 34, '12345678901', 'B'),
('Marcos Vinicius Souza', 42, '98765432100', 'D'),
('Roberto Carlos Silva', 29, '45678912300', 'C'),
('Juliana Barbosa Lima', 38, '78912345600', 'D'),
('Fernando Dias Rocha', 51, '32165498700', 'E');

INSERT INTO veiculo (placa_veiculo, chassi, modelo, ano, quilometragem, status) VALUES
('BRA2E19', '9BD12345678901234', 'Chevrolet S10 Cabine Dupla 2.8', 2022, 91200, 'EM_VIAGEM'),
('FXT8A42', '9BD98765432109876', 'Fiat Fiorino Endurance 1.4', 2023, 44500, 'DISPONIVEL'),
('GHP5D88', '8AC45678901234567', 'Mercedes-Benz Sprinter 416', 2021, 142000, 'MANUTENCAO'),
('RJK3B11', '9BD32165498765432', 'Chevrolet Montana Premier 1.2', 2024, 18300, 'DISPONIVEL'),
('LOG9F00', '9BD65498732145678', 'Fiat Ducato Maxi Cargo 2.2', 2025, 4200, 'DISPONIVEL');

INSERT INTO manutencao (id_veiculo, data_hora, valor, descricao, odometro_manut, tipo_manut) VALUES
-- Veículo 1 (S10): Última preventiva foi aos 80.000 km (hoje está com 91.200 km -> PASSOU DE 10.000 KM!)
(1, CURRENT_DATE - INTERVAL '65 days', 1150.00, 'Revisão Preventiva de 80.000 km: Óleo, filtros e pastilhas', 80000, 'PREVENTIVA'),
(1, CURRENT_DATE - INTERVAL '30 days', 780.00, 'Troca de pastilhas de freio dianteiras e fluido', 85500, 'CORRETIVA'),

-- Veículo 2 (Fiorino): Revisão em dia aos 40.000 km (hoje com 44.500 km -> OK)
(2, CURRENT_DATE - INTERVAL '40 days', 650.00, 'Revisão Preventiva de 40.000 km: Óleo 5W30 e velas', 40000, 'PREVENTIVA'),

-- Veículo 3 (Sprinter): O buraco sem fundo de dinheiro da frota (altos custos corretivos)
(3, CURRENT_DATE - INTERVAL '90 days', 1800.00, 'Revisão Preventiva de 130.000 km completa', 130000, 'PREVENTIVA'),
(3, CURRENT_DATE - INTERVAL '45 days', 7900.00, 'Troca de embreagem e reparo emergencial da turbina', 138000, 'CORRETIVA'),
(3, CURRENT_DATE - INTERVAL '3 days', 3400.00, 'Substituição de bomba de alta pressão e bicos injetores', 142000, 'CORRETIVA'),

-- Veículo 4 (Montana): Revisão inicial de 10.000 km
(4, CURRENT_DATE - INTERVAL '75 days', 850.00, 'Revisão Preventiva de 10.000 km concessionária', 10000, 'PREVENTIVA');

-- (Nota: O Veículo 5 - Ducato com 4.200 km - não tem nenhuma manutenção cadastrada por ser zero km!)

-- 4. Inserção de Leituras de Telemetria (Últimas viagens registradas)
INSERT INTO telemetria (id_veiculo, id_motorista, data_hora, odometro, nivel_comb) VALUES
-- Viagens da S10 (Placa BRA2E19)
(1, 1, CURRENT_DATE - INTERVAL '5 days', 90400, 'CHEIO'),
(1, 1, CURRENT_DATE - INTERVAL '3 days', 90850, 'MEDIO'),
(1, 2, CURRENT_DATE - INTERVAL '1 day', 91200, 'RESERVA'),

-- Viagens da Fiorino (Placa FXT8A42)
(2, 3, CURRENT_DATE - INTERVAL '4 days', 44100, 'CHEIO'),
(2, 3, CURRENT_DATE - INTERVAL '2 days', 44350, 'MEDIO'),
(2, 4, CURRENT_DATE - INTERVAL '1 day', 44500, 'BAIXO'),

-- Última leitura da Sprinter antes de quebrar e entrar na oficina
(3, 2, CURRENT_DATE - INTERVAL '3 days', 142000, 'RESERVA'),

-- Viagens da Montana (Placa RJK3B11)
(4, 5, CURRENT_DATE - INTERVAL '6 days', 17900, 'CHEIO'),
(4, 5, CURRENT_DATE - INTERVAL '2 days', 18300, 'MEDIO'),

-- Viagens da Ducato Nova (Placa LOG9F00)
(5, 4, CURRENT_DATE - INTERVAL '8 days', 3800, 'CHEIO'),
(5, 1, CURRENT_DATE - INTERVAL '1 day', 4200, 'CHEIO');