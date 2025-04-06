SELECT
	logr.nm_logradouro_comp,
	loca.nm_localidade_comp,
	logr.nr_cep
FROM
	logradouro logr,
	localidade loca
WHERE
	logr.cd_localidade=loca.cd_localidade
	AND loca.nm_localidade='Blumenau';

----------------------------------------
EXPLAIN
SELECT
	logr.nm_logradouro_comp,
	loca.nm_localidade_comp,
	logr.nr_cep
FROM
	logradouro logr,
	localidade loca
WHERE
	logr.cd_localidade=loca.cd_localidade
	AND loca.nm_localidade='Blumenau';

----------------------------------------
SELECT
	loca.nm_localidade,
	COUNT(logr.nr_cep) AS nro_ceps
FROM
	logradouro logr,
	localidade loca
WHERE
	logr.cd_localidade=loca.cd_localidade
GROUP BY
	loca.nm_localidade
ORDER BY
	2 DESC,
	1
	----------------------------------------
SHOW INDEX
FROM
	localidade;

----------------------------------------
-- criação do índice localidade fk em logradouro
CREATE INDEX idx_logradouro_localidade ON logradouro (cd_localidade);

CREATE INDEX idx_localidade_nome ON localidade (nm_localidade);

DROP INDEX logradouro_localidade_fk ON logradouro
----------------------------------------
CREATE INDEX idx_logradouro_cep ON logradouro (nr_cep);

----------------------------------------
DESC localidade;

----------------------------------------
SELECT
	loc.nm_localidade AS distrito,
	dist.nm_localidade AS municipio,
	loc.nm_localidade_comp AS completo
FROM
	localidade loc,
	localidade dist
WHERE
	loc.cd_localidade_sub=dist.cd_localidade
	AND loc.sg_uf='SC'
	AND loc.fl_tipo_localidade='D';

----------------------------------------
SELECT
	loc.nm_localidade AS distrito,
	dist.nm_localidade AS municipio,
	loc.nm_localidade_comp AS completo
FROM
	localidade loc
	JOIN localidade dist ON loc.cd_localidade_sub=dist.cd_localidade
WHERE
	loc.sg_uf='SC'
	AND loc.fl_tipo_localidade='D';

----------------------------------------
-- iniciamos identificando as diferentes escolaridades utilizada em pessoa
SELECT DISTINCT
	escolaridade
FROM
	pessoa
ORDER BY
	1;

-- criamos uma tabela para estas informações
CREATE TABLE
	escolaridade (
		id_escolaridade INT AUTO_INCREMENT,
		nm_escolaridade VARCHAR(50),
		PRIMARY KEY (id_escolaridade)
	);

-- povoando a tabela com as informações apuradas
INSERT INTO
	escolaridade (nm_escolaridade)
SELECT DISTINCT
	escolaridade
FROM
	pessoa;

-- confirmando os dados na tabela escolaridade
SELECT
	*
FROM
	escolaridade;

-- alterando informações em pessoa para o dado de escolaridade
UPDATE pessoa p
SET
	escolaridade=(
		SELECT
			e.id_escolaridade
		FROM
			escolaridade e
		WHERE
			p.escolaridade=e.nm_escolaridade
	);

-- confirmando as alteracoes
SELECT
	*
FROM
	pessoa;

-- dropando o index
DROP INDEX idx_pessoa_fulltext2 ON pessoa;

-- alterando o tipo de dados da coluna escolaridade de pessoa
ALTER TABLE pessoa
MODIFY COLUMN escolaridade INT;

-- adicionando FK em pessoa a partir da PK de escolaridade
ALTER TABLE pessoa
ADD CONSTRAINT pessoa_escolaridade_fk FOREIGN KEY (escolaridade) REFERENCES escolaridade (id_escolariadade);

-- confirmando as alterações
DESC pessoa