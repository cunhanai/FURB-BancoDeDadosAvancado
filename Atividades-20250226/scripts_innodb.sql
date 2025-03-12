
-- é o padrão dos dias atuais

-- Arquivos
-- db.opt - dados
-- .frm - cabeçalho/definição da tabela
-- .ibd - 

CREATE TABLE pessoa_innodb
(
	cd_pessoa INT PRIMARY KEY,
	nm_pessoa VARCHAR(50),
	dt_nascimento DATE
) ENGINE = INNODB;

INSERT INTO pessoa_innodb
	VALUES (1, 'pessoa 1', '2000-01-01');

SELECT * FROM pessoa_innodb;

--------------------------------------------------------------

CREATE TABLE projeto_innodb
(
	cd_projeto INT PRIMARY KEY,
	nm_projeto CHAR(100),
	cd_responsavel INT REFERENCES pessoa_innodb(cd_pessoa)
) ENGINE = innodb;

INSERT INTO projeto_innodb VALUES (1, 'projeto 1', 1);
-- não permite adicionar, mesmo não existindo a referência
INSERT INTO projeto_innodb VALUES (2, 'projeto 2', 2); 

SELECT * FROM projeto_innodb

--------------------------------------------------------------

-- recupera dados das tabelas criadas
SELECT 
	tabs.TABLE_SCHEMA, 
	tabs.TABLE_NAME, 
	tabs.`ENGINE`, 
	tabs.`ROW_FORMAT`
FROM information_schema.`TABLES` tabs
WHERE tabs.TABLE_SCHEMA = 'base_aula20250226' -- minha base de dados tem um nome diferente da do professor

-- no innodb sempre será um tipo dinâmico

--------------------------------------------------------------

-- recupera a definição da tabela

-- menos dados
DESC pessoa_innodb

-- mais dados
SELECT
	cols.TABLE_SCHEMA, 
	cols.`TABLE_NAME`,
	cols.`COLUMN_NAME`,
	cols.ORDINAL_POSITION,
	cols.COLUMN_DEFAULT,
	cols.IS_NULLABLE,
	cols.DATA_TYPE,
	cols.COLUMN_KEY
FROM information_schema.`COLUMNS` cols
WHERE cols.`TABLE_NAME` = 'pessoa_innodb';

--------------------------------------------------------------

-- recupera as constraints (restrições)

SELECT
	cons.`CONSTRAINT_SCHEMA`,
	cons.`TABLE_NAME`,
	cons.`CONSTRAINT_NAME`,
	cons.CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS cons
WHERE cons.`CONSTRAINT_SCHEMA` = 'base_aula20250226'

-- aparece a FK aqui como constraint
