INSERT INTO pessoa_1 VALUES 
(2, 'pessoa 2', '2000-01-01'),
(3, 'pessoa 3', '2011-01-01')

----------------------------------------

SELECT * FROM pessoa_1
UNION
SELECT * FROM pessoa_2;

-- compara o que é igual e une os dois

----------------------------------------

EXPLAIN
SELECT * FROM pessoa_1
UNION
SELECT * FROM pessoa_2

----------------------------------------

SELECT * FROM pessoa_1
UNION ALL
SELECT * FROM pessoa_2

-- não compara nada, apenas lista tudo das duas tabelas, mesmo que seja igual

----------------------------------------

SELECT * FROM pessoa_1
INTERSECT
SELECT * FROM pessoa_2

-- lista apenas o que é comum às duas tabelas

----------------------------------------

SELECT * FROM pessoa_1
EXCEPT
SELECT * FROM pessoa_2

-- lista apenas o que é diferente entre as duas tabelas

----------------------------------------