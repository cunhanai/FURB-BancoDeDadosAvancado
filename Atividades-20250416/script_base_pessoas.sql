-- clonando a tabela pessoa com 1000 linhas para fazer testes com os dados
CREATE OR REPLACE TABLE pessoa2 AS
	SELECT *
	FROM pessoa
	WHERE id<=1000;

ALTER TABLE pessoa2
ADD PRIMARY KEY (id);

SELECT * FROM pessoa2;

------------------------------
CREATE OR REPLACE TABLE alimento 
(
	id INT AUTO_INCREMENT PRIMARY KEY, 
	nome VARCHAR(50) NOT NULL
);

CREATE OR REPLACE TABLE pessoa_alimento
(
	id INT AUTO_INCREMENT PRIMARY KEY,
	id_alimento INT NOT NULL,
	id_pessoa MEDIUMINT(8) UNSIGNED NOT NULL DEFAULT '0'
);

ALTER TABLE pessoa_alimento
	ADD CONSTRAINT fk_pessoa_alimento_alimento
	FOREIGN KEY fk_pessoa_alimento_alimento(id_alimento)
	REFERENCES alimento(id)
	ON DELETE CASCADE;
	
ALTER TABLE pessoa_alimento
	ADD CONSTRAINT fk_pessoa_alimento_pessoa
	FOREIGN KEY fk_pessoa_alimento_pessoa(id_pessoa)
	REFERENCES pessoa2(id)
	ON DELETE CASCADE;
------------------------------


delimiter $$
CREATE OR REPLACE procedure sp_separa_alimento_nova_tabela ()
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

------------------------------

delimiter $$
CREATE OR REPLACE procedure sp_separa_alimento_nova_tabela()
BEGIN
	-- declarações da separacao e insercao do alimento
	DECLARE v_restante TEXT;
	DECLARE v_pos INT;
	DECLARE v_pessoa_alimentos TEXT;
	DECLARE v_id_pessoa INT;
	DECLARE v_id_alimento INT;
	DECLARE v_alimento TEXT;

	-- declarações cursor
	DECLARE v_controle INT DEFAULT 0;
	
	DECLARE cursor_pessoa CURSOR FOR 
		SELECT 
			p.id,
			p.alimentos
		FROM pessoa2 p;
		
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET v_controle=1;	
	
	OPEN cursor_pessoa;
	
	loop_pessoa: loop
		
		FETCH cursor_pessoa INTO v_id_pessoa, v_pessoa_alimentos;
	
		IF v_controle = 1 THEN 
			LEAVE loop_pessoa;
		END IF;
		
		SET v_restante = v_pessoa_alimentos;
		
		while CHAR_LENGTH(TRIM(v_restante)) > 0 do
			SET v_pos = INSTR(v_restante, ',');
		
			if v_pos > 0 then
				SET v_alimento = TRIM(SUBSTRING(v_restante, 1, v_pos - 1));
				SET v_restante = SUBSTRING(v_restante, v_pos + 1);
			ELSE 
				SET v_alimento = TRIM(v_restante);
				SET v_restante = '';
			END if;
	
			SELECT id FROM alimento WHERE nome LIKE v_alimento INTO v_id_alimento;
			
			if v_id_alimento IS NULL then
				INSERT INTO alimento (nome) VALUES (v_alimento);
				SELECT id FROM alimento WHERE nome LIKE v_alimento INTO v_id_alimento;
			END if;
			
			INSERT INTO pessoa_alimento (id_alimento, id_pessoa)
			VALUES (v_id_alimento, v_id_pessoa);
			
		END while;
	
	END loop;
	
	close cursor_pessoa;
END $$

CALL sp_separa_alimento_nova_tabela();