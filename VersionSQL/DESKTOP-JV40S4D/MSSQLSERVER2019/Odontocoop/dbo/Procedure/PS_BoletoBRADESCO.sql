/****** Object:  Procedure [dbo].[PS_BoletoBRADESCO]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_BoletoBRADESCO]
	-- Add the parameters for the stored procedure here        
	@cd_tipopagamento SMALLINT,
	@incd_parcela VARCHAR(MAX),
	@cd_funcionario INT
AS
BEGIN
	DECLARE @sequencial INT

	SELECT @sequencial = ISNULL(MIN(Cd_sequencial_lote), 0) - 1 FROM Boleto

	DECLARE @cd_tiposervico SMALLINT
	DECLARE @nm_tipopagamento VARCHAR(10)
	DECLARE @cd_banco INT
	DECLARE @convenio VARCHAR(10)
	DECLARE @convenio_dv CHAR(1)
	DECLARE @cedente VARCHAR(300)
	DECLARE @nm_banco VARCHAR(100)
	DECLARE @nsa INT
	DECLARE @dt_finalizado DATETIME
	DECLARE @nr_cnpj CHAR(14)
	DECLARE @tp_ag VARCHAR(10)
	DECLARE @tp_ag_dv CHAR(1)
	DECLARE @cta VARCHAR(20)
	DECLARE @dv_cta VARCHAR(1)
	DECLARE @carteira INT
	DECLARE @juros INT
	DECLARE @multa INT
	DECLARE @taxa MONEY
	DECLARE @qt_diasminimo INT
	DECLARE @dt_ref DATETIME
	DECLARE @nome VARCHAR(100)
	DECLARE @endereco VARCHAR(100)
	DECLARE @bairro VARCHAR(100)
	DECLARE @cep VARCHAR(8)
	DECLARE @cidade VARCHAR(50)
	DECLARE @uf VARCHAR(2)
	DECLARE @parc_atual INT
	DECLARE @parc_total INT
	DECLARE @val_cartao VARCHAR(6)
	DECLARE @cd_seguranca INT
	DECLARE @cd_bandeira SMALLINT
	DECLARE @codbarras VARCHAR(440)
	DECLARE @campolivre VARCHAR(25)
	DECLARE @linhadig1 VARCHAR(54)
	DECLARE @linhadig2 VARCHAR(54)
	DECLARE @linhadig3 VARCHAR(54)
	DECLARE @linhadig4 VARCHAR(54)
	DECLARE @linhadig5 VARCHAR(54)
	DECLARE @instrucao1 VARCHAR(100) = ''
	DECLARE @instrucao2 VARCHAR(100) = ''
	DECLARE @instrucao3 VARCHAR(100) = ''
	DECLARE @instrucao4 VARCHAR(100) = ''
	DECLARE @instrucao5 VARCHAR(100) = ''
	DECLARE @instrucao6 VARCHAR(100) = ''
	-- Variaveis do Arquivo        
	DECLARE @cd_associado_empresa INT
	DECLARE @cd_parcela INT
	DECLARE @cd_tipo_pagamento_m SMALLINT
	DECLARE @vl_parcela_m MONEY
	DECLARE @dt_vencimento DATETIME
	DECLARE @dt_vencimento_parc DATETIME
	DECLARE @agencia INT
	DECLARE @dv_ag VARCHAR(1)
	DECLARE @nr_conta VARCHAR(20)
	DECLARE @nr_conta_dv VARCHAR(1)
	DECLARE @nr_autorizacao VARCHAR(20)
	DECLARE @vl_parcela_l MONEY
	DECLARE @cd_tipo_recebimento SMALLINT
	DECLARE @g005 VARCHAR(1)
	DECLARE @cpf_cnpj AS VARCHAR(14)
	DECLARE @tp_associado_empresa AS SMALLINT
	DECLARE @nr_contrato VARCHAR(20)
	DECLARE @nn VARCHAR(20)
	DECLARE @tipo_cartao_hiper SMALLINT = 0
	DECLARE @count_parcela INT
	DECLARE @variacaocarteira INT
	-- Variavel de Erro        
	DECLARE @erro BIT
	-- Variaveis do Trailler
	DECLARE @qtde INT
	DECLARE @vl_total BIGINT
	DECLARE @qtde_no INT = 0
	DECLARE @vl_total_no BIGINT = 0
	DECLARE @numerolinha INT = 1
	DECLARE @numero_nos INT = 1

	BEGIN TRANSACTION

	PRINT 'TESTE'
	SELECT
		@cd_tiposervico = T.Cd_tipo_servico_bancario,
		--@cd_tipopagamento = t.cd_tipo_pagamento ,          
		@nm_tipopagamento = T.Nm_tipo_pagamento,
		@cd_banco = T.Banco,
		@convenio = T.Convenio,
		@convenio_dv = T.Dv_convenio,
		@cedente = T.Cedente + ' - ' + T.Nr_cnpj + ' <br>' + T.Endcedente,
		@nm_banco = B.Nm_banco,
		@dt_finalizado = GETDATE(),
		@nr_cnpj = T.Nr_cnpj,
		@tp_ag = T.Ag,
		@tp_ag_dv = T.Dv_ag,
		@cta = T.Cta,
		@dv_cta = T.Dv_cta,
		@carteira = Carteira,
		@variacaocarteira = T.Variacaocarteira,
		@juros = ISNULL(Perc_juros, 0),
		@multa = ISNULL(Perc_multa, 0),
		@taxa = ISNULL(Vl_taxa, 0),
		@agencia = T.Ag,
		@dv_ag = T.Dv_ag,
		@qt_diasminimo = ISNULL(TSB.Qt_diasminimo, 0),
		@instrucao3 = Nm_mensagem1,
		@instrucao4 = Nm_mensagem2,
		@instrucao5 = Nm_mensagem3
	--FROM Tipo_pagamento AS T,
	--	 Tb_banco_contratos AS B,
	--	 Tipo_servico_bancario AS TSB
	--WHERE T.Cd_tipo_pagamento = @cd_tipopagamento
	--AND T.Cd_tipo_servico_bancario = TSB.Cd_tipo_servico_bancario
	--AND T.Banco *= B.Cd_banco
	FROM Tipo_pagamento AS T
		INNER JOIN Tipo_servico_bancario AS TSB ON T.Cd_tipo_servico_bancario = TSB.Cd_tipo_servico_bancario
		LEFT OUTER JOIN Tb_banco_contratos AS B ON T.Banco = B.Cd_banco
	WHERE (T.Cd_tipo_pagamento = @cd_tipopagamento)

	IF @@rowcount = 0
	BEGIN -- 1.2        
		RAISERROR ('Sequencial nao encontrado.', 16, 1)

		RETURN
	END -- 1.2        

	SELECT
		@qt_diasminimo = Qt_diasminimo
	FROM Tipo_servico_bancario
	WHERE Cd_tipo_servico_bancario = @cd_tiposervico

	SET @dt_ref = DATEADD(DAY, @qt_diasminimo, GETDATE())

	WHILE DATEPART(Dw, @dt_ref) = 1
	OR DATEPART(Dw, @dt_ref) = 7
	BEGIN
	SET @dt_ref = DATEADD(DAY, 1, @dt_ref)
	END

	PRINT 'tipo serviço: ' + CONVERT(VARCHAR(10), ISNULL(@cd_tiposervico, 0))

	IF @cd_tiposervico = 6
		OR -- Debito Automatico
		@cd_tiposervico = 1
		OR -- CNAB 240
		@cd_tiposervico = 12
		OR -- CNAB 400 Santander
		@cd_tiposervico = 21 -- CNAB 400
	BEGIN -- 1.4
		-- Validar variaveis obrigatorias
		IF @cd_banco IS NULL
			OR @convenio IS NULL
			OR @cedente IS NULL
		BEGIN -- 2.1
			RAISERROR ('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.', 16, 1)

			RETURN
		END -- 2.1
	END -- 1.4

	--Trabalhando CD_Parcela
	DECLARE @seperator AS VARCHAR(1)
	DECLARE @sp INT
	DECLARE @value VARCHAR(1000)

	SET @seperator = ','

	DECLARE @temptab TABLE (
		Id INT NOT NULL
	)
	WHILE PATINDEX('%' + @seperator + '%', @incd_parcela) <> 0
	BEGIN
	SELECT @sp = PATINDEX('%' + @seperator + '%', @incd_parcela)

	SELECT @value = LEFT(@incd_parcela, @sp - 1)

	SELECT @incd_parcela = STUFF(@incd_parcela, 1, @sp, '')

	INSERT INTO @temptab (Id)
		VALUES (@value)
	END

	SET @count_parcela = 0

	DELETE Boleto
	WHERE Cd_sequencial_lote = @sequencial

	--Set @instrucao1='Após o vencimento cobrar:'        
	PRINT 'convenio: ' + CONVERT(VARCHAR(10), @convenio)

	IF (
		@convenio IS NULL
		OR LEN(@convenio) < 5
		)
	BEGIN -- 4.0.3
		RAISERROR ('Convenio deve ser informado com no minimo 5 digitos.', 16, 1)

		RETURN
	END -- 4.0.3

	SELECT @erro = 0, @vl_total = 0, @qtde = 0

	DECLARE Cursor_gera_processos_bancos_mens CURSOR FOR
		SELECT
			M.Cd_associado_empresa,
			M.Cd_parcela,
			M.Cd_tipo_pagamento,
			M.Vl_parcela + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0) - ISNULL(M.Vl_imposto, 0),
			M.DT_VENCIMENTO AS DT_VENCIMENTO,
			CONVERT(MONEY, M.Vl_parcela + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0) - ISNULL(M.Vl_imposto, 0) +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.Dt_pagamento, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((M.Vl_parcela - ISNULL(M.Vl_imposto, 0) + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0)) * ISNULL(T5.Perc_multa, 0)) / 100)
				ELSE 0
			END +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.Dt_pagamento, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((((M.Vl_parcela - ISNULL(M.Vl_imposto, 0) + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0)) * ISNULL(T5.Perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), GETDATE()))
				ELSE 0
			END) VALOR,
			M.Cd_tipo_recebimento,
			A.Nr_cpf,
			A.NM_COMPLETO,
			LTRIM(ISNULL(TL.Nome_tipo, '') + ' ' + A.Endlogradouro + ' ' +
			CASE
				WHEN A.Endnumero IS NULL THEN ''
				WHEN A.Endnumero = 0 THEN ''
				ELSE ', num. ' + CONVERT(VARCHAR(10), A.Endnumero)
			END + ' ' + ISNULL(A.Endcomplemento, '')),
			ISNULL(B.Baidescricao, ''),
			A.Logcep,
			ISNULL(CID.Nm_municipio, ''),
			ISNULL(Uf.Ufsigla, ''),
			M.Nosso_numero,
			CASE
				WHEN ISNULL(A.Taxa_cobranca, 1) = 1 THEN ISNULL(M.Vl_taxa, 0)
				ELSE 0
			END
		--FROM Mensalidades AS M,
		--	 Associados AS A,
		--	 Tb_tipologradouro AS TL,
		--	 Bairro AS B,
		--	 Municipio AS CID,
		--	 Uf,
		--	 Tipo_pagamento T5
		--WHERE M.Cd_parcela IN (SELECT
		--		Id
		--	FROM @temptab)
		--AND M.Cd_associado_empresa = A.Cd_associado
		--AND M.Tp_associado_empresa = 1
		--AND A.Chave_tipologradouro *= TL.Chave_tipologradouro
		--AND A.Baiid *= B.Baiid
		--AND A.Cidid *= CID.Cd_municipio
		--AND A.Ufid *= Uf.Ufid
		--AND M.Cd_tipo_pagamento = T5.Cd_tipo_pagamento
		FROM Mensalidades AS M
			INNER JOIN Associados AS A ON M.Cd_associado_empresa = A.Cd_associado
			LEFT OUTER JOIN Tb_tipologradouro AS TL ON A.Chave_tipologradouro = TL.Chave_tipologradouro
			LEFT OUTER JOIN Bairro AS B ON A.Baiid = B.Baiid
			LEFT OUTER JOIN Municipio AS CID ON A.Cidid = CID.Cd_municipio
			LEFT OUTER JOIN Uf ON A.Ufid = Uf.Ufid
			INNER JOIN Tipo_pagamento AS T5 ON M.Cd_tipo_pagamento = T5.Cd_tipo_pagamento
		WHERE M.Cd_parcela IN (SELECT
				Id
			FROM @temptab)
		AND (M.Tp_associado_empresa = 1)

		UNION

		SELECT
			M.Cd_associado_empresa,
			M.Cd_parcela,
			M.Cd_tipo_pagamento,
			M.Vl_parcela + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0) - ISNULL(M.Vl_imposto, 0),
			M.DT_VENCIMENTO,
			M.Vl_parcela + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0) - ISNULL(M.Vl_imposto, 0) +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.Dt_pagamento, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((M.Vl_parcela - ISNULL(M.Vl_imposto, 0) + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0)) * ISNULL(T5.Perc_multa, 0)) / 100)
				ELSE 0
			END +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.Dt_pagamento, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((((M.Vl_parcela - ISNULL(M.Vl_imposto, 0) + ISNULL(M.Vl_acrescimo, 0) - ISNULL(M.Vl_desconto, 0)) * ISNULL(T5.Perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, ISNULL(M.Dt_vencimento_new, M.DT_VENCIMENTO), GETDATE()))
				ELSE 0
			END VALOR,
			M.Cd_tipo_recebimento,
			A.Nr_cgc,
			A.Nm_razsoc AS NM_COMPLETO,
			LTRIM(ISNULL(TL.Nome_tipo, '') + ' ' + A.Endlogradouro + ' ' +
			CASE
				WHEN A.Endnumero IS NULL THEN ''
				WHEN A.Endnumero = 0 THEN ''
				ELSE ', num. ' + CONVERT(VARCHAR(10), A.Endnumero)
			END + ' ' + ISNULL(A.Endcomplemento, '')),
			ISNULL(B.Baidescricao, ''),
			A.Cep,
			ISNULL(CID.Nm_municipio, ''),
			ISNULL(Uf.Ufsigla, ''),
			M.Nosso_numero,
			0
		--FROM Mensalidades AS M,
		--	 Empresa AS A,
		--	 Tb_tipologradouro AS TL,
		--	 Bairro AS B,
		--	 Municipio AS CID,
		--	 Uf,
		--	 Tipo_pagamento T5
		--WHERE M.Cd_parcela IN (SELECT
		--		Id
		--	FROM @temptab)
		--AND M.Cd_associado_empresa = A.Cd_empresa
		--AND M.Tp_associado_empresa IN (2, 3)
		--AND A.Chave_tipologradouro *= TL.Chave_tipologradouro
		--AND A.Baiid *= B.Baiid
		--AND A.Cd_municipio *= CID.Cd_municipio
		--AND A.Ufid *= Uf.Ufid
		--AND M.Cd_tipo_pagamento = T5.Cd_tipo_pagamento
		--ORDER BY NM_COMPLETO,
		--		 M.Cd_associado_empresa,
		--		 M.DT_VENCIMENTO ASC --m.cd_parcela,a.nm_completo       
		FROM Mensalidades AS M
			INNER JOIN Empresa AS A ON M.Cd_associado_empresa = A.Cd_empresa
			LEFT OUTER JOIN Tb_tipologradouro AS TL ON A.Chave_tipologradouro = TL.Chave_tipologradouro
			LEFT OUTER JOIN Bairro AS B ON A.Baiid = B.Baiid
			LEFT OUTER JOIN Municipio AS CID ON A.Cd_municipio = CID.Cd_municipio
			LEFT OUTER JOIN Uf ON A.Ufid = Uf.Ufid
			INNER JOIN Tipo_pagamento AS T5 ON M.Cd_tipo_pagamento = T5.Cd_tipo_pagamento
		WHERE M.Cd_parcela IN (SELECT
				Id
			FROM @temptab)
		AND (M.Tp_associado_empresa IN (2, 3))
		ORDER BY NM_COMPLETO,
				 M.Cd_associado_empresa,
				 M.DT_VENCIMENTO

	OPEN Cursor_gera_processos_bancos_mens

	FETCH NEXT
	FROM Cursor_gera_processos_bancos_mens
	INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento, @vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa

	WHILE (@@fetch_status <> -1)
	BEGIN -- 4.2         
	SET @count_parcela = @count_parcela + 1
	SET @dt_vencimento_parc = @dt_vencimento
	SET @instrucao1 = 'Após o vencimento cobrar:'

	SELECT
		@instrucao1 = @instrucao1 + ' Juros de R$ ' + CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @juros / 100 / 30 * 100, 0) / 100) + ' ao dia.'

	SELECT
		@instrucao1 = @instrucao1 + ' Multa de R$ ' + CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @multa / 100 * 100, 0) / 100) + '.'

	SET @instrucao2 = ''

	--***Gerando NN caso nao exista**************************        
	IF (
		@nn IS NULL
		OR @nn = ''
		)
	BEGIN

		SET @nn = '1' + RIGHT('0000000000' + CONVERT(VARCHAR(10), @cd_parcela), 10)	-- alterado 21/09/2015        

		PRINT 'NN novo: ' + @nn

		UPDATE Mensalidades
		SET Cd_sequencial_lote_boleto = @sequencial,
			Cd_usuario_alteracao = @cd_funcionario,
			Dt_alteracao = GETDATE(),
			Nosso_numero = @nn
		WHERE Cd_parcela = @cd_parcela
	END

	--*****************************************************        
	SET @vl_total = @vl_total + CONVERT(INT, @vl_parcela_l * 100)
	SET @qtde = @qtde + 1


	SET @nn = RIGHT('00000000000' + @nn, 11)

	---***CAMPO LIVRE***************************************        
	SET @campolivre = RIGHT('0000' + CONVERT(VARCHAR(4), @agencia), 4) +    -- Agencia SEM DAC (4)
	RIGHT('00' + CONVERT(VARCHAR(2), @carteira), 2) +    -- Carteira SEM DAC (2)
	@nn +    -- NN SEM DAC(11)
	RIGHT('0000000' + CONVERT(VARCHAR(7), @cta), 7) +    -- Conta SEM DAC (7)
	'0' -- ZERO(1)

	---********************************************************         


	PRINT 'carteira: ' + CONVERT(VARCHAR(10), @carteira)
	PRINT 'nn: ' + ISNULL(@nn, '')
	PRINT RIGHT('00' + CONVERT(VARCHAR(3), @cd_banco), 3) + '9'
	PRINT CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc))
	PRINT RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10)
	PRINT @campolivre
	PRINT 'xxxxxxxxxxxxxx'

	SET @codbarras = RIGHT('000' + CONVERT(VARCHAR(3), @cd_banco), 3) + '9' + CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc)) +    -- Fator de Vencimento        
	RIGHT('0000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10) +    -- Valor da Parcela         
	@campolivre

	PRINT '---'
	PRINT 'convenio: ' + @convenio
	PRINT 'digto: ' + CONVERT(VARCHAR(5), @convenio_dv)
	PRINT 'nn: ' + ISNULL(@nn, '')
	PRINT 'campo livre: ' + ISNULL(@campolivre, '')
	PRINT 'Codigo Br: ' + ISNULL(@codbarras, '')
	PRINT 'Tamanho CodBR:' + CONVERT(VARCHAR(10), ISNULL(LEN(@codbarras), 0))
	PRINT 'DigCodBarras: ' + CONVERT(VARCHAR(2), Dbo.Fs_digitoverificarcodigobarras(@codbarras))
	PRINT 'sequencial: ' + CONVERT(VARCHAR(10), @sequencial)
	PRINT 'cd_associado_empresa: ' + CONVERT(VARCHAR(10), @cd_associado_empresa)
	PRINT 'parcela: ' + CONVERT(VARCHAR(10), @cd_parcela)
	PRINT 'cedente: ' + @cedente
	PRINT 'cedente: ' + @nr_cnpj
	PRINT 'vencimento: ' + CONVERT(VARCHAR(10), @dt_vencimento, 103)
	PRINT 'agencia: ' + CONVERT(VARCHAR(10), @agencia)
	PRINT 'digAg: ' + CONVERT(VARCHAR(1), @dv_ag)
	PRINT 'cta: ' + CONVERT(VARCHAR(10), @cta)
	PRINT 'digCta: ' + CONVERT(VARCHAR(10), @dv_cta)
	PRINT 'convencio: ' + CONVERT(VARCHAR(10), @convenio)
	PRINT 'digConv: ' + CONVERT(VARCHAR(1), @convenio_dv)
	PRINT 'carteira: ' + CONVERT(VARCHAR(10), @carteira)
	PRINT 'NN: ' + @nn
	PRINT 'valor: ' + RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10)
	PRINT 'Nome: ' + @nome
	PRINT 'CPF/CNPJ: ' + @cpf_cnpj
	PRINT 'Endereço: ' + @endereco
	PRINT 'Bairro: ' + @bairro
	PRINT 'CEP: ' + @cep
	PRINT 'Cidade: ' + @cidade
	PRINT 'UF: ' + @uf
	PRINT 'multas: ' + CONVERT(VARCHAR(15), ROUND(@vl_parcela_l * @multa / 100 * 100, 0) / 100)
	PRINT 'juros: ' + CONVERT(VARCHAR(15), ROUND(@vl_parcela_l * @juros / 100 / 30 * 100, 0) / 100)
	PRINT 'inst1: ' + @instrucao1
	PRINT 'inst2: ' + @instrucao2
	PRINT 'inst3: ' + @instrucao3
	PRINT 'inst4: ' + @instrucao4
	PRINT 'LinhaDig: ' + @linhadig1 + ' ' + @linhadig2 + ' ' + @linhadig3 + ' ' + @linhadig4 + ' ' + @linhadig5
	PRINT 'CodBr: ' + @codbarras
	PRINT 'codBrVisual: ' + Dbo.Fg_traduz_codbarras(@codbarras)
	PRINT 'inst5: ' + @instrucao5
	PRINT 'inst6: ' + @instrucao6
	PRINT '---'

	SET @codbarras = LEFT(@codbarras, 4) + Dbo.Fs_digitoverificarcodigobarras(@codbarras) + RIGHT(@codbarras, 39)
	SET @linhadig1 = LEFT(@codbarras, 4) + LEFT(@campolivre, 5)
	SET @linhadig1 = LEFT(@linhadig1, 5) + '.' + RIGHT(@linhadig1, 4) + Dbo.Fs_calculomodulo10(@linhadig1)
	SET @linhadig2 = SUBSTRING(@campolivre, 6, 10)
	SET @linhadig2 = LEFT(@linhadig2, 5) + '.' + RIGHT(@linhadig2, 5) + Dbo.Fs_calculomodulo10(@linhadig2)
	SET @linhadig3 = SUBSTRING(@campolivre, 16, 10)
	SET @linhadig3 = LEFT(@linhadig3, 5) + '.' + RIGHT(@linhadig3, 5) + Dbo.Fs_calculomodulo10(@linhadig3)
	SET @linhadig4 = SUBSTRING(@codbarras, 5, 1)
	SET @linhadig5 = SUBSTRING(@codbarras, 6, 14)

	PRINT @linhadig1
	PRINT @linhadig2
	PRINT @linhadig3
	PRINT @linhadig4
	PRINT @linhadig5
	PRINT 'CodBr: ' + @codbarras

	IF @cd_banco <> 1
	BEGIN
		SET @nn = LEFT(@nn, LEN(@nn) - 1) + '-' + RIGHT(@nn, 1)
	END

	---*****GRAVANDO TB BOLETO***************************      
	INSERT Boleto (Cd_sequencial_lote,
				   Cd_associado_empresa,
				   Cd_parcela,
				   Cedente,
				   Cnpj,
				   Dt_vencimento,
				   Agencia,
				   Dg_ag,
				   Conta,
				   Dg_conta,
				   Convenio,
				   Dg_convenio,
				   Carteira,
				   Nn,
				   Valor,
				   Pagador,
				   Cpf_cnpj_pagador,
				   End_pagador,
				   Bai_pagador,
				   Cep_pagador,
				   Mun_pagador,
				   Uf_pagador,
				   Vl_multa,
				   Vl_juros,
				   Instrucao1,
				   Instrucao2,
				   Instrucao3,
				   Instrucao4,
				   Linha,
				   Barra,
				   Cod_barra,
				   Instrucao5,
				   Instrucao6,
				   Count_parcela)
		VALUES (@sequencial,
				@cd_associado_empresa,
				@cd_parcela,
				@cedente,
				@nr_cnpj,
				CONVERT(VARCHAR(10), @dt_vencimento, 103),
				@agencia,
				@dv_ag,
				@cta,
				@dv_cta,
				@convenio,
				@convenio_dv,
				CONVERT(VARCHAR(10), @carteira),
				@nn,
				@vl_parcela_l,
				@nome,
				@cpf_cnpj,
				@endereco,
				@bairro,
				@cep,
				@cidade,
				@uf,
				ROUND(@vl_parcela_l * @multa / 100 * 100, 0) / 100,
				ROUND(@vl_parcela_l * @juros / 100 / 30 * 100, 0) / 100,
				@instrucao1,
				@instrucao2,
				@instrucao3,
				@instrucao4,
				@linhadig1 + ' ' + @linhadig2 + ' ' + @linhadig3 + ' ' + @linhadig4 + ' ' + @linhadig5,
				@codbarras,
				Dbo.Fg_traduz_codbarras(@codbarras),
				@instrucao5,
				@instrucao6,
				@count_parcela)

	---**********************************************************        
	FETCH NEXT 
	FROM Cursor_gera_processos_bancos_mens
	INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento, @vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa
	END -- 3.2        

	CLOSE Cursor_gera_processos_bancos_mens

	DEALLOCATE Cursor_gera_processos_bancos_mens

	COMMIT

	SELECT
		@sequencial AS SEQUENCIALLOTE,
		@cd_banco CD_BANCO,
		NULL AS ACEITAMULTIPLOSSERVICOBANCARIO
END
