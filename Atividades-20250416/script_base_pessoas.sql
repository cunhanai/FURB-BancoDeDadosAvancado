-- clonando a tabela pessoa com 1000 linhas para fazer testes com os dados
CREATE TABLE
    pessoa2 AS
SELECT
    *
FROM
    pessoa
WHERE
    id<=1000;


SELECT
    *
FROM
    pessoa2;
    
    
------------------------------

CREATE TABLE alimento
(
	id MEDIUMINT PRIMARY KEY ,
	nome VARCHAR(50) NOT NULL
);

CREATE TABLE pessoa_alimento
(
	id MEDIUMINT PRIMARY KEY,
	id_alimento MEDIUMINT NOT NULL ,
	id_pessoa MEDIUMINT NOT NULL,
	
	CONSTRAINT fk_pessoa_alimento_alimento FOREIGN KEY id_alimento REFERENCES alimento(id),
    
   CONSTRAINT fk_pessoa_alimento_pessoa FOREIGN KEY id_pessoa REFERENCES pessoa2(id)
);


------------------------------


delimiter $$
CREATE OR REPLACE function fc_separa_texto_com_virgula (p_texto TEXT)
	RETURNS TEXT
BEGIN
	DECLARE v_saida TEXT DEFAULT '';
	DECLARE v_item TEXT;
	DECLARE v_restante TEXT;
	DECLARE v_pos INT;
	
	SET v_restante = p_texto;
	
	while CHAR_LENGTH(TRIM(v_restante)) > 0 do
		SET v_pos = INSTR(v_restante, ',');
		
		if v_pos > 0 then
			SET v_item = TRIM(SUBSTRING(v_restante, 1, v_pos - 1));
			SET v_restante = SUBSTRING(v_restante, v_pos + 1);
		ELSE 
			SET v_item = TRIM(v_restante);
			SET v_restante = '';
		END if;
		
		SET v_saida = CONCAT(v_saida, v_item, '\n');
	END while;
	
	RETURN v_saida;

END $$


SELECT fc_separa_texto_com_virgula('tortas, massar, cereais, frutos do mar') AS resultado;