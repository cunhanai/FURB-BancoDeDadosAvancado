CREATE OR REPLACE VIEW vw_cliente_animal
AS
	SELECT c.nm_cliente, a.nm_animal
	FROM animal a, cliente c
	WHERE a.cd_cliente = c.cd_cliente;
	
SELECT * FROM vw_cliente_animal;