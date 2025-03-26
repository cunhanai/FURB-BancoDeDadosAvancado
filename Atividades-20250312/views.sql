CREATE OR REPLACE VIEW vw_cliente_animal AS
SELECT 
	c.nm_cliente,
	a.nm_animal
FROM animal a,
	cliente c
WHERE a.cd_cliente = c.cd_cliente;

-- ou
CREATE OR REPLACE VIEW vw_cliente_animal (cliente, animal) AS
SELECT 
	c.nm_cliente,
	a.nm_animal
FROM animal a,
	cliente c
WHERE a.cd_cliente = c.cd_cliente;

SELECT * FROM vw_cliente_animal;

----------------------------------------

-- buscar as informações sobre as views
-- não posso fazer updates em tabelas de metadados

SELECT vws.TABLE_SCHEMA,
		vws.`TABLE_NAME`,
		vws.VIEW_DEFINITION
	FROM information_schema.VIEWS vws
WHERE vws.TABLE_SCHEMA = 'bd_pet'

----------------------------------------

CREATE OR REPLACE VIEW vw_cliente_animal
AS
	SELECT 
		c.nm_cliente AS cliente, 
		a.nm_animal AS animal, 
		r.nm_raca AS raca
	FROM 
		animal a, 
		cliente c,
		raca r
	WHERE 
		a.cd_cliente = c.cd_cliente 
		AND a.cd_raca = r.cd_raca;

-- busca na view
SELECT 
	vw_ca.cliente, 
	vw_ca.animal,
	vw_ca.raca,
	e.nm_especie
FROM
	vw_cliente_animal vw_ca,
	raca r,
	especie e
WHERE
	vw_ca.raca = r.nm_raca
	AND r.cd_especie = e.cd_especie;

----------------------------------------

-- a) crie uma view para selecionar os nomes dos prestadores
-- 	e os serviços que eles prestam

CREATE OR REPLACE VIEW vw_prestador_servicos
	(prestador, servico)
AS
	SELECT
		p.nm_prestador,
		s.ds_servico
	FROM 
		prestador_servico p,
		servico s,
		servico_prestador sp
	WHERE sp.cd_prestador = p.cd_prestador
			AND sp.cd_servico = s.cd_servico;
			
SELECT * FROM vw_prestador_servicos
ORDER BY prestador;

