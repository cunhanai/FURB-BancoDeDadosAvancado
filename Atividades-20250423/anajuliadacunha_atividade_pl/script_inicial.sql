-- SCRIPTS DLL/DML para apoio.
-- Created by Vertabelo (http://vertabelo.com)
-- tables
-- Table: cliente
CREATE TABLE
    cliente (
        cd_cliente INT NOT NULL,
        nm_cliente VARCHAR(50) NOT NULL,
        ds_logradouro VARCHAR(50) NOT NULL,
        ds_complemento VARCHAR(30) NOT NULL,
        nm_bairro VARCHAR(30) NOT NULL,
        nr_cep CHAR(8) NOT NULL,
        nr_telefone VARCHAR(15) NOT NULL,
        ds_email VARCHAR(50) NOT NULL,
        vl_limite_credito DECIMAL(8, 2) NOT NULL,
        CONSTRAINT cliente_pk PRIMARY KEY (cd_cliente)
    );


-- Table: condicao_pagamento
CREATE TABLE
    condicao_pagamento (
        cd_condicao_pagto INT NOT NULL,
        ds_condicao_pagto VARCHAR(50) NOT NULL,
        vl_expressao VARCHAR(30) NOT NULL,
        CONSTRAINT condicao_pagamento_pk PRIMARY KEY (cd_condicao_pagto)
    );


-- Table: nota_fiscal_saida
CREATE TABLE
    nota_fiscal_saida (
        nr_nf_saida INT NOT NULL,
        dt_emissao DATE NOT NULL,
        vl_total DECIMAL(8, 2) NOT NULL,
        nr_pedido_compra INT NOT NULL,
        cd_cliente INT NOT NULL,
        CONSTRAINT nota_fiscal_saida_pk PRIMARY KEY (nr_nf_saida)
    );


-- Table: pedido_compra
CREATE TABLE
    pedido_compra (
        nr_pedido_compra INT NOT NULL,
        dt_emissao DATE NOT NULL,
        vl_total DECIMAL(8, 2) NOT NULL,
        cd_cliente INT NOT NULL,
        cd_condicao_pagto INT NOT NULL,
        CONSTRAINT pedido_compra_pk PRIMARY KEY (nr_pedido_compra)
    );


-- Table: titulo_receber
CREATE TABLE
    titulo_receber (
        nr_titulo INT AUTO_INCREMENT NOT NULL,
        nr_parcela INT NOT NULL,
        dt_emissao DATE NOT NULL,
        dt_vencimento DATE NOT NULL,
        dt_pagamento DATE NOT NULL,
        vl_titulo DECIMAL(8, 2) NOT NULL,
        vl_multa DECIMAL(8, 2) NOT NULL,
        vl_juros DECIMAL(8, 2) NOT NULL,
        nr_nf_saida INT NOT NULL,
        cd_cliente INT NOT NULL,
        CONSTRAINT titulo_receber_pk PRIMARY KEY (nr_titulo)
    );


-- foreign keys
-- Reference: nota_fiscal_saida_cliente (table: nota_fiscal_saida)
ALTER TABLE nota_fiscal_saida
ADD CONSTRAINT nota_fiscal_saida_cliente FOREIGN KEY (cd_cliente) REFERENCES cliente (cd_cliente);


-- Reference: nota_fiscal_saida_pedido_compra (table: nota_fiscal_saida)
ALTER TABLE nota_fiscal_saida
ADD CONSTRAINT nota_fiscal_saida_pedido_compra FOREIGN KEY (nr_pedido_compra) REFERENCES pedido_compra (nr_pedido_compra);


-- Reference: pedido_compra_cliente (table: pedido_compra)
ALTER TABLE pedido_compra
ADD CONSTRAINT pedido_compra_cliente FOREIGN KEY (cd_cliente) REFERENCES cliente (cd_cliente);


-- Reference: pedido_compra_condicao_pagamento (table: pedido_compra)
ALTER TABLE pedido_compra
ADD CONSTRAINT pedido_compra_condicao_pagamento FOREIGN KEY (cd_condicao_pagto) REFERENCES condicao_pagamento (cd_condicao_pagto);


-- Reference: titulo_receber_cliente (table: titulo_receber)
ALTER TABLE titulo_receber
ADD CONSTRAINT titulo_receber_cliente FOREIGN KEY (cd_cliente) REFERENCES cliente (cd_cliente);


-- Reference: titulo_receber_nota_fiscal_saida (table: titulo_receber)
ALTER TABLE titulo_receber
ADD CONSTRAINT titulo_receber_nota_fiscal_saida FOREIGN KEY (nr_nf_saida) REFERENCES nota_fiscal_saida (nr_nf_saida);


-- povoamento de parte das estruturas
-- A seguir sugestão os valores adicionados na tabela "condicao_pagamento". Se julgar mais adequado outro formato (vl_expressao), sem problemas.
INSERT INTO
    condicao_pagamento (cd_condicao_pagto, ds_condicao_pagto, vl_expressao)
VALUES
    (1, 'À Vista', '0'),
    (2, '2x (30/60)', '30,60'),
    (3, '3x (30/60/90)', '30,60,90'),
    (4, 'Entrada + 2x (0/30/60)', '0,30,60');


INSERT INTO
    cliente (
        cd_cliente,
        nm_cliente,
        ds_logradouro,
        ds_complemento,
        nm_bairro,
        nr_cep,
        nr_telefone,
        ds_email,
        vl_limite_credito
    )
VALUES
    (
        1,
        'Carlos Alberto',
        'Rua das Flores',
        'Apto 101',
        'Jardins',
        '01234000',
        '(11)99999-1111',
        'carlos@email.com',
        5000.00
    ),
    (
        2,
        'Fernanda Lima',
        'Av. Paulista',
        'Sala 202',
        'Centro',
        '01311000',
        '(11)98888-2222',
        'fernanda@email.com',
        8000.00
    ),
    (
        3,
        'Juliana Mendes',
        'Rua Bela Vista',
        'Casa',
        'Morumbi',
        '05632000',
        '(11)97777-3333',
        'juliana@email.com',
        3000.00
    );