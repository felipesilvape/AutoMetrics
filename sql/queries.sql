-- Veículos que nunca passaram por mecânica
SELECT
	v.id AS veiculo_,
	v.placa_veiculo AS placa,
	v.modelo,
	v.ano,
	v.quilometragem,
	v.status
FROM 
	veiculo v
LEFT JOIN
	manutencao m ON v.id = m.id_veiculo
WHERE
	m.id IS NULL
ORDER BY 
	v.quilometragem ASC;

-- Distribuição de volume e custos por tipo de manutenção
SELECT 
    tipo_manut AS tipo_manutencao,
    COUNT(id) AS quantidade_servicos,
    SUM(valor) AS custo_total,
    ROUND(AVG(valor), 2) AS custo_medio_por_servico
FROM 
    manutencao
GROUP BY 
    tipo_manut
ORDER BY 
    custo_total DESC;

-- Custo por Quilômetro Rodado (R$/km) da Frota
SELECT 
    v.placa_veiculo AS placa,
    v.modelo,
    v.quilometragem AS km_total_rodado,
    SUM(m.valor) AS gasto_total_oficina,
    ROUND(SUM(m.valor) / v.quilometragem, 2) AS custo_por_km
FROM 
    veiculo v
JOIN 
    manutencao m ON v.id = m.id_veiculo
GROUP BY 
    v.id, v.placa_veiculo, v.modelo, v.quilometragem
ORDER BY 
    custo_por_km DESC;

-- Produtividade e polivalência dos motoristas na frota
SELECT 
    mot.nome AS motorista,
    mot.cat_cnh AS categoria_cnh,
    COUNT(t.id) AS total_viagens_registradas,
    COUNT(DISTINCT t.id_veiculo) AS veiculos_distintos_conduzidos
FROM 
    motorista mot
JOIN 
    telemetria t ON mot.id = t.id_motorista
GROUP BY 
    mot.id, mot.nome, mot.cat_cnh
ORDER BY 
    total_viagens_registradas DESC;

-- Alerta e manutenção preventida (> 10.000 km)
SELECT 
    v.placa_veiculo AS placa,
    v.modelo,
    v.quilometragem AS km_atual,
    COALESCE(MAX(m.odometro_manut), 0) AS km_ultima_preventiva,
    v.quilometragem - COALESCE(MAX(m.odometro_manut), 0) AS km_desde_revisao,
    CASE 
        WHEN (v.quilometragem - COALESCE(MAX(m.odometro_manut), 0)) >= 10000 
        THEN 'BLOQUEAR: REVISAO URGENTE'
        ELSE 'REGULAR: EM DIA'
    END AS status_alerta
FROM 
    veiculo v
LEFT JOIN 
    manutencao m ON v.id = m.id_veiculo AND m.tipo_manut = 'PREVENTIVA'
GROUP BY 
    v.id, v.placa_veiculo, v.modelo, v.quilometragem
ORDER BY 
    km_desde_revisao DESC;

-- Último status operacional da frota (Painel de Telemetria em Tempo Real)
WITH UltimaLeitura AS (
    SELECT 
        t.id_veiculo,
        t.data_hora,
        t.odometro,
        t.nivel_comb,
        mot.nome AS ultimo_motorista,
        ROW_NUMBER() OVER (
            PARTITION BY t.id_veiculo 
            ORDER BY t.data_hora DESC
        ) AS ranking
    FROM 
        telemetria t
    JOIN 
        motorista mot ON t.id_motorista = mot.id
)
SELECT 
    v.placa_veiculo AS placa,
    v.modelo,
    v.status AS status_veiculo,
    ul.data_hora AS data_ultima_transmissao,
    ul.odometro AS odometro_atual,
    ul.nivel_comb AS nivel_combustivel,
    ul.ultimo_motorista
FROM 
    veiculo v
JOIN 
    UltimaLeitura ul ON v.id = ul.id_veiculo
WHERE 
    ul.ranking = 1
ORDER BY 
    ul.data_hora DESC;