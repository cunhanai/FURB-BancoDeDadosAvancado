-- criação de uma tabela para registro de logs
CREATE TABLE
    registro_logs (
        usuario VARCHAR(50),
        tabela VARCHAR(50),
        campo VARCHAR(50),
        operacao CHAR(1),
        valor_antigo VARCHAR(100),
        valor_novo VARCHAR(100),
        data_alteracao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

-----------------------------------------
-- criando um gatilho para registro de inserção de cliente
delimiter $$ -- setta o terminado do bloco de definição do gatilho
CREATE
OR
REPLACE
    TRIGGER tg_cliente_insert AFTER
INSERT
    ON cliente FOR EACH ROW
BEGIN
-- insere na tabela de registro_logs
INSERT INTO
    registro_logs (usuario, tabela, campo, operacao, valor_novo)
VALUES
    (USER (), 'cliente', 'nome', 'i', NEW.nm_cliente);

-- NEW é a estrutura que mantem os dados do registro inserido
END $$
-----------------------------------------
SELECT
    tgs.TRIGGER_NAME,
    tgs.EVENT_OBJECT_TABLE,
    tgs.EVENT_MANIPULATION,
    tgs.ACTION_TIMING,
    tgs.ACTION_STATEMENT
FROM
    information_schema.`TRIGGERS` tgs
WHERE
    tgs.TRIGGER_SCHEMA='base_testes_pl';

-----------------------------------------
-- testando o gatilho criado
INSERT INTO
    cliente (nm_cliente, dt_nascimento)
VALUES
    ('Daniel I. Neves', CURDATE());

--------------------------------------------
delimiter $$ CREATE
OR
REPLACE
    TRIGGER tg_cliente_insert AFTER
UPDATE ON cliente FOR EACH ROW
BEGIN IF NEW.nm_cliente<>OLD.nm_cliente THEN
INSERT INTO
    registro_logs (
        usuario,
        tabela,
        campo,
        operacao,
        valor_antigo,
        valor_novo
    )
VALUES
    (
        USER (),
        'cliente',
        'nome',
        'i',
        OLD.nm_cliente,
        NEW.nm_cliente
    );

END IF;

END $$
--------------------------------------------
UPDATE cliente
SET
    nm_cliente='Daniel Iensen Neves'
WHERE
    cd_cliente=1;

SELECT
    *
FROM
    cliente;

SELECT
    *
FROM
    registro_logs;

---------------------------------------------
SELECT
    *
FROM
    pessoa;

CREATE TABLE
    atividade (
        id_atividade INTEGER AUTO_INCREMENT PRIMARY KEY,
        atividade VARCHAR(100)
    );

INSERT INTO
    atividade (atividade)
SELECT DISTINCT
    atividade
FROM
    pessoa;

delimiter $$ CREATE
OR
REPLACE
    TRIGGER tg_atividade_update AFTER
UPDATE ON atividade FOR EACH ROW
BEGIN
UPDATE pessoa p
SET
    p.atividade=NEW.atividade
WHERE
    p.atividade=OLD.atividade;

END $$
----------------------------------------------
delimiter $$ CREATE
OR
REPLACE
    TRIGGER tg_atividade_delete BEFORE DELETE ON atividade FOR EACH ROW
BEGIN DECLARE v_qtde_pessoa INTEGER DEFAULT 0;

SELECT
    COUNT(*) INTO v_qtde_pessoa
FROM
    pessoa;

IF v_qtde_pessoa>0 THEN
SIGNAL SQLSTATE '45000'
SET
    MESSAGE_TEXT='Há pessoa(s) vinculadas! Não é possível excluir.';

END IF;

END $$
----------------------------------------------
delimiter $$ CREATE
OR
REPLACE
    TRIGGER tg_itemnotafiscal_insert BEFORE
INSERT
    ON itemnotafiscal FOR EACH ROW
BEGIN DECLARE valor DECIMAL(8, 2) DEFAULT 0.0;

SELECT
    m.vl_venda INTO valor
FROM
    medicamento m
WHERE
    m.cd_medicamento=NEW.cd_medicamento;

-- atualizando estoque
UPDATE medicamento m
SET
    m.qt_estoque=m.qt_estoque-NEW.qt_vendida
WHERE
    m.cd_medicamento=NEW.cd_medicamento;

-- atualizando o valor total da nota viscal
SET
    NEW.vl_venda=v_valor_medicamento;

UPDATE notafiscal nf
SET
    nf.vl_total=nf.vl_total+(NEW.vl_venda*NEW.qt_vendida)
WHERE
    nf.nr_notafiscal=NEW.nr_notafiscal;

END $$
-----------------------------------------------