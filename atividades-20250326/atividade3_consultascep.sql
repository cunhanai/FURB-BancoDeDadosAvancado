-- COLUNAS QUE SÃO FK
-- COLUNAS QUE SÃO USADAS FREQUENTEMENTE EM FILTROS

-- a) Listar todos os logradouros da cidade de "Blumenau", seus respectivos bairros e CEPs, 
-- ordenados alfabeticamente pelo nome do bairro, seguido pelo nome do logradouro;

SHOW INDEX FROM localidade;
CREATE INDEX idx_localidade_nome ON localidade(nm_localidade);

SHOW INDEX FROM logradouro;
CREATE INDEX idx_logradouro_bairro ON logradouro(cd_bairro_inicio);

EXPLAIN
SELECT
	logr.nm_logradouro_comp,
	bai.nm_bairro,
	loc.nm_localidade_comp,
	logr.sg_uf,
	logr.nr_cep
FROM 
	logradouro logr, 
	bairro bai, 
	localidade loc
WHERE 
	logr.cd_bairro_inicio = bai.cd_bairro
	AND logr.cd_localidade = loc.cd_localidade
	AND loc.nm_localidade = 'Blumenau'
ORDER BY 2, 1

----------------------------------------

-- b) Listar o nome dos distritos (fl_tipo_localidade= 'D') e do respectivo
-- município que cada distrito está associado. Considerar como filtro apenas 
-- a UF "SC" e ordenar pelo nome do município, seguido do distrito;

SHOW INDEX FROM localidade;

EXPLAIN
SELECT
	d.nm_localidade AS distrito,
	l.nm_localidade AS municipio,
	d.nm_localidade_comp AS "distrito (localidade)"	
FROM 
	localidade d, 
	localidade l
WHERE
	d.cd_localidade_sub = l.cd_localidade
	AND d.fl_tipo_localidade = 'D'
	AND d.sg_uf = 'SC'
ORDER BY 2, 1;

----------------------------------------

-- c) Listar o nome do(s) bairro(s) de "Florianópolis" com respectiva 
-- quantidade de CEPs associados. Ordenar pelo maior número de CEPs;

EXPLAIN

SELECT
	bai.nm_bairro,
	COUNT(logr.nr_cep) AS qtd_cep
FROM 
	bairro bai,
	logradouro logr,
	localidade loc
WHERE
	bai.cd_bairro = logr.cd_bairro_inicio
	AND logr.cd_localidade = loc.cd_localidade
	AND loc.nm_localidade = 'Florianópolis'
GROUP BY 1
ORDER BY 2 DESC;

----------------------------------------

-- d) Listar os nomes dos municípios do Brasil que possuem praça como
-- localidade. Listar também a UF e a quantidade de praças de cada município
-- listado. Ordenar pelo maior número de praças encontradas;

EXPLAIN
SELECT
	mun.nm_localidade AS municipio,
	mun.sg_uf AS UF,
	COUNT(pra.cd_localidade) qtd_pracas
FROM 
	localidade mun,
	localidade pra
WHERE
	pra.cd_localidade_sub = mun.cd_localidade
	AND pra.fl_tipo_localidade = 'P'
GROUP BY 1, 2
ORDER BY 3 DESC

----------------------------------------

-- e) Listar quais nomes de municípios são encontrados em mais de uma UF.
-- Listar também a quantidade de vezes em que o nome do município é
-- encontrado. Ordenar pelos municípios mais populares;

EXPLAIN 
SELECT
 	mun.nm_localidade,
 	COUNT(mun.sg_uf) AS qtd_uf
FROM 
 	localidade mun
WHERE
	mun.fl_tipo_localidade = 'M'
GROUP BY 1
HAVING qtd_uf > 1
ORDER BY 2 DESC;

----------------------------------------

-- f) Listar a quantidade total de municípios (fl_tipo_localidade= 'M') por
-- UF. Ordenar pelo maior número listado;

SELECT
 	mun.sg_uf,
 	COUNT(mun.nm_localidade) AS qtd_municipios
FROM 
 	localidade mun
WHERE
	mun.fl_tipo_localidade = 'M'
GROUP BY 1
ORDER BY 2 DESC;

----------------------------------------

-- g) Listar o nome do município, a UF e a quantidade de bairros que cada
-- município apresenta. Ordenar pelo maior número de bairros encontrado,
-- seguido pelo nome do município e UF;
 
EXPLAIN 
SELECT
	loc.nm_localidade, 
	loc.sg_uf,
	COUNT(DISTINCT logr.cd_bairro_inicio) qtd_bairros
FROM
	localidade loc,
	logradouro logr
WHERE 
	logr.cd_localidade = loc.cd_localidade
GROUP BY 1, 2
ORDER BY 3 DESC, 1 ASC, 2 ASC;

----------------------------------------

