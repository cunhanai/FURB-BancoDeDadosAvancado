-- a) criar um pedido na data atual passando como parâmetro: cliente, 
-- condição de pagamento e valor total;

ALTER TABLE pedido_compra
MODIFY COLUMN nr_pedido_compra INT AUTO_INCREMENT;

delimiter $$
CREATE OR REPLACE PROCEDURE sp_criar_pedido(	IN p_cliente INT,
															IN p_condicao_pagamento INT,
															IN p_valor_total DECIMAL(8,2))
BEGIN

	INSERT INTO pedido_compra (dt_emissao, vl_total, cd_cliente, cd_condicao_pagto)
	VALUES (CURDATE(), p_valor_total, p_cliente, p_condicao_pagamento);

END $$

CALL sp_criar_pedido(1, 2, 100.0);
CALL sp_criar_pedido(2, 1, 633.0);
CALL sp_criar_pedido(2, 1, 122.39);

------------------------------------------

-- b) obter o valor total de pedidos de compra por cliente, considerando como 
-- parâmetro o identificador do cliente;

delimiter $$
CREATE OR REPLACE FUNCTION fc_obter_valor_total_pedidor_por_cliente(p_cliente INT)
	RETURNS DECIMAL(8, 2)
BEGIN

	DECLARE v_valor_total DECIMAL(8,2);

	SELECT SUM(vl_total)
	FROM pedido_compra
	WHERE cd_cliente = p_cliente
	INTO v_valor_total;
	
	if v_valor_total IS NULL then
		SET v_valor_total = 0.0;
	END if;
		
	RETURN v_valor_total;

END $$

SELECT fc_obter_valor_total_pedidor_por_cliente(3);

------------------------------------------

-- c) a partir do número de uma nota fiscal passada como parâmetro, retorne o 
-- número de parcelas geradas para ela;

delimiter $$
CREATE OR REPLACE FUNCTION fc_conta_itens_texto_com_virgula(p_texto VARCHAR(30))
	RETURNS INT
BEGIN

	DECLARE v_saida INT DEFAULT 0;
	DECLARE v_item TEXT;
	DECLARE v_restante TEXT;
	DECLARE v_pos INT;
	
	SET v_restante = p_texto;
	
	while CHAR_LENGTH(TRIM(v_restante)) > 0 do
		SET v_pos = INSTR(v_restante, ',');
		
		if v_pos > 0 then
			SET v_restante = SUBSTRING(v_restante, v_pos + 1);
		ELSE 
			SET v_restante = '';
		END if;
		
		SET v_saida = v_saida + 1;
		
	END while;
	
	RETURN v_saida;

END $$

delimiter $$
CREATE OR REPLACE FUNCTION fc_obter_condicao_pagamento(p_nr_nota_fiscal INT)
	RETURNS VARCHAR(30)
BEGIN
	DECLARE v_condicao VARCHAR(30);

	SELECT cp.vl_expressao
	FROM condicao_pagamento cp
		INNER JOIN pedido_compra pc ON pc.cd_condicao_pagto = cp.cd_condicao_pagto
		INNER JOIN nota_fiscal_saida nf ON nf.nr_pedido_compra = pc.nr_pedido_compra
	WHERE nf.nr_nf_saida = p_nr_nota_fiscal
	INTO v_condicao;

	RETURN v_condicao;
END $$

delimiter $$
CREATE OR REPLACE FUNCTION fc_nr_parcelas_geradas(p_nr_nota_fiscal INT)
	RETURNS INT
BEGIN
	DECLARE v_condicao VARCHAR(30);
	DECLARE v_parcelas INT;
		
	SELECT fc_obter_condicao_pagamento(p_nr_nota_fiscal)
	INTO v_condicao;
	
	SELECT fc_conta_itens_texto_com_virgula(v_condicao)
	INTO v_parcelas;
	
	RETURN v_parcelas;

END $$

call sp_criar_pedido(1, 3, 100);
call sp_criar_pedido(1, 4, 100);

INSERT INTO nota_fiscal_saida VALUES (1, CURDATE(), 100.00, 1, 1);
INSERT INTO nota_fiscal_saida VALUES (2, CURDATE(), 100.00, 2, 2);
INSERT INTO nota_fiscal_saida VALUES (3, CURDATE(), 100.00, 4, 1);
INSERT INTO nota_fiscal_saida VALUES (4, CURDATE(), 100.00, 5, 1);

SELECT fc_nr_parcelas_geradas(1);
SELECT fc_nr_parcelas_geradas(2);
SELECT fc_nr_parcelas_geradas(3);
SELECT fc_nr_parcelas_geradas(4);

------------------------------------------

-- d) gerar as parcelas (titulo_receber) considerando os parâmetros passados: 
-- número da nota fiscal e a data base (utilizada como data de início para calcular 
-- os vencimentos das parcelas);

delimiter $$
CREATE OR REPLACE PROCEDURE sp_gerar_parcelas(	IN p_nf_nota_fiscal INT,
																IN p_data_base DATE)
BEGIN

	DECLARE v_total DECIMAL(8,2);
	DECLARE v_cliente INT;
	DECLARE v_parcela INT DEFAULT 0;
	DECLARE v_qtd_parcelas INT;
	DECLARE v_item TEXT;
	DECLARE v_restante TEXT;
	DECLARE v_pos INT;
	DECLARE v_condicao VARCHAR(30);
	DECLARE v_parcial DECIMAL(8,2);
	DECLARE v_data_venc DATE;
	
	SELECT
		nf.vl_total,
		nf.cd_cliente
	FROM nota_fiscal_saida nf
	WHERE nf.nr_nf_saida = p_nf_nota_fiscal
	INTO 
		v_total, 
		v_cliente;

	SELECT fc_obter_condicao_pagamento(p_nf_nota_fiscal)
	INTO v_condicao;

	SELECT fc_conta_itens_texto_com_virgula(v_condicao)
	INTO v_qtd_parcelas;

	SET v_parcial = v_total / v_qtd_parcelas;

	SET v_restante = v_condicao;
	
	while CHAR_LENGTH(TRIM(v_restante)) > 0 do
		SET v_pos = INSTR(v_restante, ',');
		
		if v_pos > 0 then
			SET v_item = TRIM(SUBSTRING(v_restante, 1, v_pos - 1));
			SET v_restante = SUBSTRING(v_restante, v_pos + 1);
		ELSE 
			SET v_item = TRIM(v_restante);
			SET v_restante = '';
		END if;
		
		SET v_parcela = v_parcela + 1;
		SET v_data_venc = DATE_ADD(p_data_base, INTERVAL v_item DAY);
		
		INSERT INTO titulo_receber (	nr_parcela, 
												dt_emissao, 
												dt_vencimento, 
												dt_pagamento,
												vl_titulo,
												vl_multa,
												vl_juros,
												nr_nf_saida,
												cd_cliente)
		VALUES (
			v_parcela,
			CURDATE(),
			v_data_venc,
			v_data_venc,
			v_parcial,
			0.0,
			0.0,
			p_nf_nota_fiscal,
			v_cliente
		);
	END while;
	
END $$

call sp_gerar_parcelas(1, '2025-03-23');
call sp_gerar_parcelas(2, '2025-03-23');
call sp_gerar_parcelas(3, '2025-03-23');
call sp_gerar_parcelas(4, '2025-04-23');


------------------------------------------

-- e) retornar o número de dias em atraso de um título (passado como parâmetro), 
-- considerando a data atual;

delimiter $$
CREATE OR REPLACE FUNCTION fc_obter_nr_dias_atraso_titulo(p_titulo INT)
	RETURNS INT
BEGIN
	
	DECLARE v_vencimento DATE;
	DECLARE v_dias INT;
	
	SELECT dt_vencimento
	FROM titulo_receber
	WHERE nr_titulo = p_titulo
	INTO v_vencimento;
	
	SET v_dias = DATEDIFF(CURDATE(), v_vencimento);
	
	RETURN v_dias;
	
END $$

SELECT fc_obter_nr_dias_atraso_titulo(14);
SELECT fc_obter_nr_dias_atraso_titulo(12);
SELECT fc_obter_nr_dias_atraso_titulo(21);

------------------------------------------

-- f) validar se, ao inserir um título a receber para o cliente, o valor acumulado 
-- de títulos em aberto não ultrapassa o limite de crédito do cliente. Se ultrapassar, 
-- informe um erro;

delimiter $$
CREATE OR REPLACE TRIGGER tg_titulo_receber_insert_before BEFORE INSERT 
	ON titulo_receber FOR EACH ROW
BEGIN
	DECLARE v_acumulo DECIMAL(8,2);
	DECLARE v_limite DECIMAL(8,2);
	
	SELECT vl_limite_credito
	FROM cliente
	WHERE cd_cliente = NEW.cd_cliente
	INTO v_limite;
	
	SELECT SUM(vl_titulo)
	FROM titulo_receber
	WHERE cd_cliente = NEW.cd_cliente
	INTO v_acumulo;
	
	SET v_acumulo = v_acumulo + NEW.vl_titulo;
	
	if v_acumulo > v_limite then
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Limite de crédito do cliente ultrapassado!';
	END if;

END $$

INSERT INTO titulo_receber (	nr_parcela, 
										dt_emissao, 
										dt_vencimento, 
										dt_pagamento,
										vl_titulo,
										vl_multa,
										vl_juros,
										nr_nf_saida,
										cd_cliente)
VALUES (
	1,
	CURDATE(),
	'2025-03-10',
	'2025-03-10',
	5000.0,
	0.0,
	0.0,
	1,
	1
);

	
INSERT INTO titulo_receber (	nr_parcela, 
										dt_emissao, 
										dt_vencimento, 
										dt_pagamento,
										vl_titulo,
										vl_multa,
										vl_juros,
										nr_nf_saida,
										cd_cliente)
VALUES (
	1,
	CURDATE(),
	'2025-03-10',
	'2025-03-10',
	5500.0,
	0.0,
	0.0,
	1,
	1
);
	
	
INSERT INTO titulo_receber (	nr_parcela, 
										dt_emissao, 
										dt_vencimento, 
										dt_pagamento,
										vl_titulo,
										vl_multa,
										vl_juros,
										nr_nf_saida,
										cd_cliente)
VALUES (
	1,
	CURDATE(),
	'2025-03-10',
	'2025-03-10',
	500.0,
	0.0,
	0.0,
	1,
	1
);

------------------------------------------
-- g) registrar o pagamento de um título tendo como parâmetros: número do título, 
-- data do pagamento, valor pago, multa e juros. A rotina deverá validar se o 
-- pagamento está sendo feito antes ou depois do vencimento (em atraso) e retornar 
-- uma mensagem correspondente.

delimiter $$
CREATE OR REPLACE function fc_registrar_pagamento_titulo(IN p_titulo INT,
																			IN p_pagamento DATE,
																			IN p_valor DECIMAL(8,2),
																			IN p_multa DECIMAL(8,2),
																			IN p_juros DECIMAL(8,2))
	RETURNS VARCHAR(10)
BEGIN
	DECLARE v_vencimento DATE;
	DECLARE v_mensagem VARCHAR(10);

	UPDATE titulo_receber
	SET 
		dt_pagamento = p_pagamento,
		vl_titulo = p_valor,
		vl_multa = p_multa,
		vl_juros = p_juros
	WHERE nr_titulo = p_titulo;

	SELECT dt_vencimento
	FROM titulo_receber
	WHERE nr_titulo = p_titulo
	INTO v_vencimento;

	if DATEDIFF(p_pagamento,v_vencimento) > 0 then
		SET v_mensagem = "Em atraso";
	else
		SET v_mensagem = "Em dia";
	END if;
	
	RETURN v_mensagem;
END $$

SELECT fc_registrar_pagamento_titulo(12, '2025-04-22', 105.0, 0.0, 0.0);
SELECT * FROM titulo_receber WHERE nr_titulo = 12;

SELECT fc_registrar_pagamento_titulo(13, '2025-04-22', 105.0, 0.0, 0.0);
SELECT * FROM titulo_receber WHERE nr_titulo = 13;

SELECT fc_registrar_pagamento_titulo(14, '2025-04-22', 105.0, 3.0, 2.0);
SELECT * FROM titulo_receber WHERE nr_titulo = 14;
