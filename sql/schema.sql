DROP TABLE IF EXISTS telemetria;
DROP TABLE IF EXISTS manutencao;
DROP TABLE IF EXISTS veiculo;
DROP TABLE IF EXISTS motorista;

CREATE TABLE motorista (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(120) NOT NULL,
    idade INT NOT NULL CHECK (idade >= 18),
    cnh VARCHAR(11) UNIQUE NOT NULL,
    cat_cnh VARCHAR(2) NOT NULL
);

CREATE TABLE veiculo (
    id SERIAL PRIMARY KEY,
    placa_veiculo VARCHAR(7) UNIQUE NOT NULL,
    chassi VARCHAR(17) UNIQUE NOT NULL,
    modelo VARCHAR(60) NOT NULL,
    ano INT NOT NULL CHECK (ano >= 2000),
    quilometragem INT NOT NULL CHECK (quilometragem >= 0),
    status VARCHAR(20) NOT NULL CHECK (status IN ('DISPONIVEL', 'EM_VIAGEM', 'MANUTENCAO', 'INATIVO'))
);

CREATE TABLE telemetria (
    id SERIAL PRIMARY KEY,
    id_veiculo INT NOT NULL REFERENCES veiculo(id) ON DELETE CASCADE,
    id_motorista INT NOT NULL REFERENCES motorista(id) ON DELETE RESTRICT,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    odometro INT NOT NULL CHECK (odometro >= 0),
    nivel_comb VARCHAR(15) NOT NULL CHECK (nivel_comb IN ('CHEIO', 'MEDIO', 'BAIXO', 'RESERVA'))
);

CREATE TABLE manutencao (
    id SERIAL PRIMARY KEY,
    id_veiculo INT NOT NULL REFERENCES veiculo(id) ON DELETE CASCADE,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    valor NUMERIC(10, 2) NOT NULL CHECK (valor >= 0),
    descricao VARCHAR(250) NOT NULL,
    odometro_manut INT NOT NULL CHECK (odometro_manut >= 0),
    tipo_manut VARCHAR(15) NOT NULL CHECK (tipo_manut IN ('PREVENTIVA', 'CORRETIVA'))
);