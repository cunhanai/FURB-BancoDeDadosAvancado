-- Principais características do MEMORY
-- Tudo o que existe fica na memória
-- Não é persistido, então desligando, os dados são perdidos
-- HEAP é a mesma coisa que MEMORY

-- Arquivos
-- .frm - cabeçalho/definição da tabela

CREATE TABLE pessoa_memory
(
	cd_pessoa INT PRIMARY KEY,
	nm_pessoa VARCHAR(50),
	dt_nascimento DATE
) ENGINE = memory;

INSERT INTO pessoa_memory
	VALUES (1, 'pessoa 1', '2000-01-01');

SELECT * FROM pessoa_memory;

--------------------------------------------------------------

CREATE TABLE projeto_memory
(
	cd_projeto INT PRIMARY KEY,
	nm_projeto CHAR(100),
	cd_responsavel INT REFERENCES pessoa_memory(cd_pessoa)
) ENGINE = memory;

INSERT INTO projeto_memory VALUES (1, 'projeto 1', 1);
-- permite adicionar mesmo que não exista, só não faz um link
-- não executa a regra de verificação para não cadastrar um responsável que não existe
-- semanticamente a FK não existe
INSERT INTO projeto_memory VALUES (2, 'projeto 2', 2); 

SELECT * FROM projeto_memory

--------------------------------------------------------------

-- recupera dados das tabelas criadas
SELECT 
	tabs.TABLE_SCHEMA, 
	tabs.TABLE_NAME, 
	tabs.`ENGINE`, 
	tabs.`ROW_FORMAT`
FROM information_schema.`TABLES` tabs
WHERE tabs.TABLE_SCHEMA = 'base_aula20250226' -- minha base de dados tem um nome diferente da do professor

--------------------------------------------------------------

-- recupera a definição da tabela

-- menos dados
DESC pessoa_memory

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
WHERE cols.`TABLE_NAME` = 'pessoa_memory';

--------------------------------------------------------------


-- recupera as constraints (restrições)

SELECT
	cons.`CONSTRAINT_SCHEMA`,
	cons.`TABLE_NAME`,
	cons.`CONSTRAINT_NAME`,
	cons.CONSTRAINT_TYPE
FROM information_schema.TABLE_CONSTRAINTS cons
WHERE cons.`CONSTRAINT_SCHEMA` = 'base_aula20250226'

-- não aparece a FK aqui como constraint
