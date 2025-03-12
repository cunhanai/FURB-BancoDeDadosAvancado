SELECT c.nm_cliente, a.nm_animal
FROM cliente c, animal a -- produto cartesiano
WHERE a.cd_cliente = c.cd_cliente

-- ou

EXPLAIN
SELECT c.nm_cliente, a.nm_animal
FROM cliente c JOIN animal a
	ON (c.cd_cliente = a.cd_cliente)