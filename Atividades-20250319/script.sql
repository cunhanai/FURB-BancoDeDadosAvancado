SELECT 
	logr.nm_logradouro_comp, 
	loca.nm_localidade_comp,
	logr.nr_cep
FROM logradouro logr, localidade loca
WHERE logr.cd_localidade = loca.cd_localidade
	AND loca.nm_localidade = 'Blumenau';

----------------------------------------

EXPLAIN
SELECT 
	logr.nm_logradouro_comp, 
	loca.nm_localidade_comp,
	logr.nr_cep
FROM logradouro logr, localidade loca
WHERE logr.cd_localidade = loca.cd_localidade
	AND loca.nm_localidade = 'Blumenau';
	
----------------------------------------

SELECT
	loca.nm_localidade,
	COUNT(logr.nr_cep) AS nro_ceps
FROM logradouro logr, localidade loca
WHERE logr.cd_localidade = loca.cd_localidade
GROUP BY loca.nm_localidade
ORDER BY 2 DESC, 1

----------------------------------------

SHOW INDEX FROM localidade;

----------------------------------------

-- criação do índice localidade fk em logradouro
CREATE INDEX idx_logradouro_localidade
ON logradouro(cd_localidade);

CREATE INDEX idx_localidade_nome
ON localidade(nm_localidade);

DROP INDEX logradouro_localidade_fk ON logradouro

----------------------------------------

CREATE INDEX idx_logradouro_cep
ON logradouro(nr_cep);

----------------------------------------

DESC localidade;

----------------------------------------

SELECT 
	loc.nm_localidade AS distrito, 
	dist.nm_localidade AS municipio,
	loc.nm_localidade_comp AS completo
FROM localidade loc, localidade dist
WHERE loc.cd_localidade_sub = dist.cd_localidade
	AND loc.sg_uf = 'SC'
	AND loc.fl_tipo_localidade = 'D';

----------------------------------------

SELECT 
	loc.nm_localidade AS distrito, 
	dist.nm_localidade AS municipio,
	loc.nm_localidade_comp AS completo
FROM localidade loc
JOIN localidade dist ON loc.cd_localidade_sub = dist.cd_localidade
WHERE 
	loc.sg_uf = 'SC'
	AND loc.fl_tipo_localidade = 'D';

----------------------------------------
