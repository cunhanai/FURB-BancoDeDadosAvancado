-- criação de função para retornar o lucro (margem %) de um medicamento
-- parâmetros: id do medicamento
-- retorno: percentual da margem de lucro
delimiter $$ CREATE
OR
REPLACE
	FUNCTION fc_calcular_margem_lucro (p_id_medicamento INTEGER) RETURNS DECIMAL(4, 1)
BEGIN
-- declaração de variável para o lucro apurado
DECLARE v_lucro DECIMAL(8, 2) DEFAULT 0.0;

-- obtem o valor correspondente a margem
SELECT
	((vl_venda-vl_custo)*100/vl_custo) INTO v_lucro
FROM
	medicamento
WHERE
	cd_medicamento=p_id_medicamento;

RETURN v_lucro;

END $$
-- testando a função
SELECT
	fc_calcular_margem_lucro (2);

--------------------------------------------------
delimiter $$ CREATE
OR
REPLACE
	FUNCTION fc_gasto_do_cliente (
		p_cliente INTEGER,
		p_data_ini DATE,
		p_data_fim DATE
	) RETURNS DECIMAL(8, 2)
BEGIN
-- declaração de variável para apurar o total
DECLARE v_total DECIMAL(10, 2) DEFAULT 0.0;

SELECT
	SUM(itf.qt_vendida*itf.vl_venda) INTO v_total
FROM
	notafiscal nf,
	itemnotafiscal itf
WHERE
	nf.nr_notafiscal=itf.nr_notafiscal
	AND nf.cd_cliente=p_cliente
	AND nf.dt_emissao BETWEEN p_data_ini AND p_data_fim;

RETURN v_total;

END $$
SELECT
	fc_gasto_do_cliente (1, '2025-01-01', '2025-04-16');

SELECT
	*
FROM
	notafiscal;

--------------------------------------------------
-- criação de procedure para atualizar preço medicamentos condicionados
-- parâmetros: percentual, valor mínimo e valor máximo do medicamento
delimiter $$ 
CREATE OR REPLACE PROCEDURE sp_atualizar_preco_medicamento (
																				IN p_percentual DECIMAL(4, 1),
																				IN p_preco_min DECIMAL(8, 2),
																				IN p_preco_max DECIMAL(8, 2)
																			)
BEGIN 
	DECLARE v_controle INT DEFAULT 0; -- utilizada oara controle do cursor
	DECLARE v_custo DECIMAL(8, 2); -- armazena o valor do custo do medicamento
	DECLARE v_preco_ajustado DECIMAL(8, 2); -- utilizada para atualizar o valor do medicamento
	DECLARE v_medicamento INT; -- id do medicamento
	-- declaração do cursor
	DECLARE cursor_medicamento CURSOR FOR
		SELECT
			m.cd_medicamento,
			m.vl_custo
		FROM
			medicamento m
		WHERE
			m.vl_custo BETWEEN p_preco_min AND p_preco_max;
	
	-- declaração de controle do cursor, define 1 quando fim
	DECLARE CONTINUE HANDLER FOR NOT FOUND
		SET v_controle=1;
	
	-- abrindo o cursor (execução do select associado)
	OPEN cursor_medicamento;
	
	loop_medicamento: loop
		-- atribuindo o valor das colunas de cada linha às variáveis
		FETCH cursor_medicamento INTO v_medicamento, v_custo;
	
		-- teste de fim de bloco do cursor
		IF v_controle = 1 THEN 
			LEAVE loop_medicamento;
		END IF;
	
		-- processamento com as variáveis (com valores atribuídos de cada linha)
		SET v_preco_ajustado = (v_custo*(1+p_percentual/100));
	
		-- atualiza o valor de venda do medicamento na tabela
		UPDATE medicamento
			SET
				vl_venda=v_preco_ajustado
			WHERE
				cd_medicamento=v_medicamento;
	
	END loop;
	CLOSE cursor_medicamento;

END $$

CALL sp_atualizar_preco_medicamento (20, 11, 50);

SELECT * 
FROM medicamento
ORDER BY vl_custo;