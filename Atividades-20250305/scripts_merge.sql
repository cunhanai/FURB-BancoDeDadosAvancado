CREATE TABLE
    pessoa_1 (
        cd_pessoa INT NOT NULL,
        nm_pessoa VARCHAR(50) NOT NULL,
        dt_nascimento DATE NOT NULL
    ) ENGINE = myisam;

INSERT INTO pessoa_1
VALUES
    (1, 'pessoa 1', '2000-01-01');

-- permite eu inserir várias vezes o mesmo registro
SELECT * FROM pessoa_1;

CREATE TABLE
    pessoa_2 (
        cd_pessoa INT NOT NULL,
        nm_pessoa VARCHAR(50) NOT NULL,
        dt_nascimento DATE NOT NULL
    ) ENGINE = myisam;

INSERT INTO pessoa_2
VALUES
    (2, 'pessoa 2', '2000-01-01');
    
INSERT INTO pessoa_2
VALUES
    (3, 'pessoa 3', '2000-01-01');

-- permite eu inserir várias vezes o mesmo registro
SELECT * FROM pessoa_2;

-- criando uma tabela que fisicamente não existe
-- pega dados das duas tabelas
CREATE OR REPLACE TABLE
    pessoa_merge (
        cd_pessoa INT NOT NULL,
        nm_pessoa VARCHAR(50) NOT NULL,
        dt_nascimento DATE NOT NULL
    ) ENGINE = MERGE
UNION
= (pessoa_1, pessoa_2)
INSERT_METHOD = LAST;

SELECT * FROM pessoa_merge;

INSERT INTO pessoa_merge
VALUES
    (4, 'pessoa 4', '2000-01-01');