-- Exibindo índices da tabela pessoa

SHOW INDEXES FROM pessoa;

-- cria um índice FULLTEXT

CREATE FULLTEXT INDEX idx_pessoa_fulltext1 ON pessoa(alimentos, anotacoes);

----------------------------------------

SELECT *
FROM pessoa
WHERE id < 100;

----------------------------------------

EXPLAIN
SELECT 
	p.nome, 
	p.alimentos
FROM pessoa p
WHERE p.alimentos LIKE '%tortas%sobremesas%'

-----------------------------------------

EXPLAIN
SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE MATCH (alimentos, anotacoes)
	AGAINST ('tortas sobremesas');

-----------------------------------------

SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE MATCH (alimentos, anotacoes)
	AGAINST ('tortas sobremesas fusce');

-----------------------------------------

SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE MATCH (alimentos, anotacoes)
	AGAINST ('+tortas -sobremesas' IN BOOLEAN MODE);
	
-----------------------------------------

SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE MATCH (alimentos, anotacoes)
	AGAINST ('"luctus vulputate"' IN BOOLEAN MODE);
	
-----------------------------------------
	
SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE MATCH (alimentos, anotacoes)
	AGAINST ('+(luctus | vulputate) -amet -guisados +saladas' IN BOOLEAN MODE);
	
-----------------------------------------

SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE (anotacoes LIKE '%luctus%' OR anotacoes LIKE '%vulputate%') 
		AND alimentos NOT LIKE '%amet%' AND alimentos NOT LIKE '%guisados%' AND alimentos LIKE '%saladas%';

SELECT
	p.nome,
	p.alimentos,
	p.anotacoes
FROM pessoa p
WHERE (anotacoes LIKE '%luctus%' OR anotacoes LIKE '%vulputate%') 
		AND alimentos NOT LIKE '%amet%' AND alimentos NOT LIKE '%guisados%' AND alimentos LIKE '%saladas%'
		
-----------------------------------------
		
CREATE FULLTEXT INDEX idx_pessoa_fulltext2 ON pessoa(nome, escolaridade, atividade, email, logradouro, cep, cidade, regiao, pais, telefone, alimentos, anotacoes);

-----------------------------------------
