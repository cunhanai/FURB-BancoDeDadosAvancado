-- NÃO PERMITE CHAVES
-- NÃO PERMITE VALORES NULOS

-- serve para tirar os dados da tabela e colocar dentro de um excel

-- Arquivos
-- .frm - cabeçalho/definição da tabela
-- .CSV - dados
-- .csm - metadados

CREATE TABLE pessoa_csv
(
	cd_pessoa INT NOT NULL,
	nm_pessoa VARCHAR(50) NOT NULL,
	dt_nascimento DATE NOT NULL
) ENGINE = csv;

INSERT INTO pessoa_csv
	VALUES (1, 'pessoa 1', '2000-01-01'); -- permite eu inserir várias vezes o mesmo registro

SELECT * FROM pessoa_csv;