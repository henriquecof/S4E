/****** Object:  Procedure [dbo].[PS_BoletoBANESE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_BoletoBANESE]

	@cd_tipopagamento SMALLINT,
	@incd_parcela VARCHAR(MAX),
	@cd_funcionario INT
AS
BEGIN
	DECLARE @sequencial INT
	SELECT
		@sequencial = ISNULL(MIN(cd_sequencial_lote), 0) - 1
	FROM Boleto

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
	SELECT
		@cd_tiposervico = T.cd_tipo_servico_bancario,
		--@cd_tipopagamento = t.cd_tipo_pagamento ,  
		@nm_tipopagamento = T.nm_tipo_pagamento,
		@cd_banco = T.banco,
		@convenio = T.Convenio,
		@convenio_dv = T.dv_convenio,
		@cedente = T.Cedente + ' - ' + T.nr_cnpj + ' <br>' + T.EndCedente,
		@nm_banco = B.nm_banco,
		@dt_finalizado = GETDATE(),
		@nr_cnpj = T.nr_cnpj,
		@tp_ag = T.ag,
		@tp_ag_dv = T.dv_ag,
		@cta = T.cta,
		@dv_cta = T.dv_cta,
		@carteira = carteira,
		@juros = ISNULL(Perc_juros, 0),
		@multa = ISNULL(Perc_multa, 0),
		@taxa = ISNULL(vl_taxa, 0),
		@agencia = T.ag,
		@dv_ag = T.dv_ag,
		@qt_diasminimo = ISNULL(TSB.qt_diasminimo, 0),
		@instrucao3 = nm_mensagem1,
		@instrucao4 = nm_mensagem2,
		@instrucao5 = nm_mensagem3
	FROM --tipo_pagamento as t , 
	--TB_Banco_Contratos as b, 
	--tipo_servico_bancario as tsb   
	dbo.TIPO_PAGAMENTO T
		LEFT OUTER JOIN dbo.TB_Banco_Contratos B ON T.banco = B.cd_banco
		INNER JOIN dbo.tipo_servico_bancario TSB ON T.cd_tipo_servico_bancario = TSB.cd_tipo_servico_bancario
	WHERE T.CD_TIPO_PAGAMENTO = @cd_tipopagamento
	--AND t.cd_tipo_servico_bancario = tsb.cd_tipo_servico_bancario 
	--AND t.banco *= b.cd_banco 

	IF @@rowcount = 0
	BEGIN -- 1.2
		RAISERROR ('Sequencial nao encontrado.', 16, 1)
		RETURN
	END -- 1.2


	SELECT
		@qt_diasminimo = qt_diasminimo
	FROM tipo_servico_bancario
	WHERE cd_tipo_servico_bancario = @cd_tiposervico
	SET @dt_ref = DATEADD(DAY, @qt_diasminimo, GETDATE())
	WHILE DATEPART(dw, @dt_ref) = 1
	OR DATEPART(dw, @dt_ref) = 7
	BEGIN
	SET @dt_ref = DATEADD(DAY, 1, @dt_ref)
	END

	PRINT 'tipo serviço: ' + CONVERT(VARCHAR(10), ISNULL(@cd_tiposervico, 0))
	IF @cd_tiposervico = 6
		OR -- Debito Automatico
		@cd_tiposervico = 1
		OR -- CNAB 240 - Carne
		@cd_tiposervico = 3
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
		id INT NOT NULL
	)
	WHILE PATINDEX('%' + @seperator + '%', @incd_parcela) <> 0
	BEGIN
	SELECT
		@sp = PATINDEX('%' + @seperator + '%', @incd_parcela)
	SELECT
		@value = LEFT(@incd_parcela, @sp - 1)
	SELECT
		@incd_parcela = STUFF(@incd_parcela, 1, @sp, '')
	INSERT INTO @temptab (id)
		VALUES (@value)
	END

	SET @count_parcela = 0
	DELETE Boleto
	WHERE cd_sequencial_lote = @sequencial

	--Set @instrucao1='Após o vencimento cobrar:'
	PRINT 'convenio: ' + CONVERT(VARCHAR(10), @convenio)
	IF (@convenio IS NULL
		OR LEN(@convenio) < 6)
	BEGIN -- 4.0.3
		RAISERROR ('Convenio deve ser informado com no minimo 6 digitos.', 16, 1)
		RETURN
	END -- 4.0.3    

	SELECT
		@erro = 0,
		@vl_total = 0,
		@qtde = 0


	DECLARE cursor_gera_processos_bancos_mens CURSOR FOR
		SELECT
			M.CD_ASSOCIADO_empresa,
			M.CD_PARCELA,
			M.CD_TIPO_PAGAMENTO,
			M.VL_PARCELA + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0) - ISNULL(M.vl_imposto, 0),
			M.DT_VENCIMENTO AS DT_VENCIMENTO,
			CONVERT(MONEY, M.VL_PARCELA + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0) - ISNULL(M.vl_imposto, 0)
			+
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.DT_PAGAMENTO, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((M.VL_PARCELA - ISNULL(M.vl_imposto, 0) + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0)) * ISNULL(T5.Perc_multa, 0)) / 100)
				ELSE 0
			END +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.DT_PAGAMENTO, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((((M.VL_PARCELA - ISNULL(M.vl_imposto, 0) + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0)) * ISNULL(T5.Perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), GETDATE()))
				ELSE 0
			END)
			VALOR,
			M.CD_TIPO_RECEBIMENTO,
			A.nr_cpf,
			A.nm_completo,
			LTRIM(ISNULL(TL.NOME_TIPO, '') + ' ' + A.EndLogradouro + ' ' +
			CASE
				WHEN A.EndNumero IS NULL THEN ''
				WHEN A.EndNumero = 0 THEN ''
				ELSE ', num. ' + CONVERT(VARCHAR(10), A.EndNumero)
			END + ' ' + ISNULL(A.EndComplemento, '')),
			ISNULL(B.baiDescricao, ''),
			A.LogCep,
			ISNULL(CID.NM_MUNICIPIO, ''),
			ISNULL(UF.ufSigla, ''),
			M.NOSSO_NUMERO,
			CASE
				WHEN ISNULL(A.taxa_cobranca, 1) = 1 THEN M.vl_taxa
				ELSE 0
			END
		FROM -- Mensalidades as M, Associados as a  , TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF , TIPO_PAGAMENTO T5 
		dbo.MENSALIDADES M
			INNER JOIN dbo.ASSOCIADOS A ON M.CD_ASSOCIADO_empresa = A.cd_associado
			LEFT JOIN dbo.TB_TIPOLOGRADOURO TL ON A.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO
			LEFT JOIN dbo.Bairro B ON A.baiId = B.baiId
			LEFT JOIN dbo.MUNICIPIO CID ON A.CidID = CID.cd_municipio
			LEFT JOIN UF ON A.ufId = UF.ufId
			INNER JOIN dbo.TIPO_PAGAMENTO T5 ON M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
		WHERE M.CD_PARCELA IN (SELECT
				id
			FROM @temptab)
		AND --m.cd_Associado_empresa = a.cd_Associado and 
		M.TP_ASSOCIADO_EMPRESA = 1
		--AND a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO 
		--AND a.BaiId*=b.baiId 
		--AND a.cidid *= CId.CD_MUNICIPIO 
		--AND a.ufId *= Uf.ufId 
		--AND m.CD_TIPO_PAGAMENTO = T5.cd_tipo_pagamento
		UNION
		SELECT
			M.CD_ASSOCIADO_empresa,
			M.CD_PARCELA,
			M.CD_TIPO_PAGAMENTO,
			M.VL_PARCELA + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0) - ISNULL(M.vl_imposto, 0),
			M.DT_VENCIMENTO,
			M.VL_PARCELA + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0) - ISNULL(M.vl_imposto, 0)
			+
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.DT_PAGAMENTO, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((M.VL_PARCELA - ISNULL(M.vl_imposto, 0) + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0)) * ISNULL(T5.Perc_multa, 0)) / 100)
				ELSE 0
			END +
			CASE
				WHEN DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), ISNULL(M.DT_PAGAMENTO, GETDATE())) > 0 THEN CONVERT(DECIMAL(10, 2), ((((M.VL_PARCELA - ISNULL(M.vl_imposto, 0) + ISNULL(M.VL_Acrescimo, 0) - ISNULL(M.VL_Desconto, 0)) * ISNULL(T5.Perc_juros, 0)) / 30) / 100) * DATEDIFF(DAY, ISNULL(M.dt_vencimento_new, M.DT_VENCIMENTO), GETDATE()))
				ELSE 0
			END
			VALOR,
			M.CD_TIPO_RECEBIMENTO,
			A.NR_CGC,
			A.NM_RAZSOC,
			LTRIM(ISNULL(TL.NOME_TIPO, '') + ' ' + A.EndLogradouro + ' ' +
			CASE
				WHEN A.EndNumero IS NULL THEN ''
				WHEN A.EndNumero = 0 THEN ''
				ELSE ', num. ' + CONVERT(VARCHAR(10), A.EndNumero)
			END + ' ' + ISNULL(A.EndComplemento, '')),
			ISNULL(B.baiDescricao, ''),
			A.Cep,
			ISNULL(CID.NM_MUNICIPIO, ''),
			ISNULL(UF.ufSigla, ''),
			M.NOSSO_NUMERO,
			0
		FROM -- Mensalidades as M, empresa as a, TB_TIPOLOGRADOURO as TL, Bairro as B, MUNICIPIO as CID, UF , TIPO_PAGAMENTO T5 
		dbo.MENSALIDADES M
			INNER JOIN dbo.EMPRESA A ON M.CD_ASSOCIADO_empresa = A.CD_EMPRESA
			LEFT JOIN dbo.TB_TIPOLOGRADOURO TL ON A.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO
			LEFT JOIN dbo.Bairro B ON A.baiId = B.baiId
			LEFT JOIN dbo.MUNICIPIO CID ON CID.cd_municipio = A.cd_municipio
			LEFT JOIN dbo.UF ON UF.ufId = A.ufId
			INNER JOIN dbo.TIPO_PAGAMENTO T5 ON M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
		WHERE M.CD_PARCELA IN (SELECT
				id
			FROM @temptab)
		--AND m.cd_Associado_empresa = a.cd_empresa 
		AND M.TP_ASSOCIADO_EMPRESA IN (2, 3)
		--AND a.CHAVE_TIPOLOGRADOURO *= tl.CHAVE_TIPOLOGRADOURO 
		--AND a.BaiId*=b.baiId 
		--AND a.cd_municipio *= CId.CD_MUNICIPIO 
		--AND a.ufId *= Uf.ufId 
		--AND m.CD_TIPO_PAGAMENTO = T5.cd_tipo_pagamento
		ORDER BY M.DT_VENCIMENTO ASC --m.cd_parcela 

	OPEN cursor_gera_processos_bancos_mens
	FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento,
	@vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa

	WHILE (@@fetch_status <> -1)
	BEGIN -- 4.2 

	SET @count_parcela = @count_parcela + 1
	SET @dt_vencimento_parc = @dt_vencimento

	SET @instrucao1 = 'Após o vencimento cobrar:'
	SELECT
		@instrucao1 = @instrucao1 + ' Juros de R$ ' + CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @juros / 100 / 30 * 100, 0) / 100) + ' ao dia.'
	SELECT
		@instrucao1 = @instrucao1 + ' Multa de R$ ' + CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @multa / 100 * 100, 0) / 100) + '.'

	SET @instrucao2 = 'Após 30 (trinta) dias de atraso protestar.'

	--***Gerando NN caso nao exista**************************
	IF (@nn IS NULL
		OR @nn = '')
	BEGIN
		SET @nn = RIGHT('00000000' + CONVERT(VARCHAR(8), @cd_parcela), 8) -- alterado 26/11/2017

		PRINT 'NN novo: ' + @nn
		UPDATE MENSALIDADES
		SET cd_lote_processo_banco = @sequencial,
			CD_USUARIO_ALTERACAO = @cd_funcionario,
			DT_ALTERACAO = GETDATE(),
			NOSSO_NUMERO = @nn
		WHERE CD_PARCELA = @cd_parcela
	END
	--*****************************************************

	SET @vl_total = @vl_total + CONVERT(INT, @vl_parcela_l * 100)
	SET @qtde = @qtde + 1

	SET @nn = RIGHT('000000000000' + @nn, 8)
	PRINT 'carteira: ' + CONVERT(VARCHAR(10), @carteira)
	PRINT 'nn: ' + ISNULL(@nn, '')

	--Set @nn = convert(varchar(2),@carteira) + @nn + convert(varchar(5),dbo.FS_CalculoModulo11_CNAB240(convert(varchar(2),@carteira) + @nn,4))

	---***CAMPO LIVRE***************************************
	DECLARE @nosso_numero_dac INT = dbo.FS_CalculoModulo11_BANESE(RIGHT('00' + @agencia, 2) + @nn, 9, 1)

	IF @nosso_numero_dac = 1
		OR @nosso_numero_dac = 0
		SET @nosso_numero_dac = 0
	ELSE
		SET @nosso_numero_dac = 11 - @nosso_numero_dac

	SET @nn = @nn + CONVERT(VARCHAR(1), @nosso_numero_dac)

	SET @campolivre = RIGHT('00' + @agencia, 2) + RIGHT('000000000' + @convenio + @convenio_dv, 9) + RIGHT('000000000' + @nn, 9) + '047'
	SET @campolivre = @campolivre + dbo.FS_DuploDigito_Banese(@campolivre)

	SET @codbarras = RIGHT('000' + CONVERT(VARCHAR(3), @cd_banco), 3) + --Codigo banco
	'9' + -- Moeda Real
	RIGHT('0000' + CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc)), 4) + -- Fator de Vencimento
	RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10) + -- Valor da Parcela 
	@campolivre --Campo Livre

	---********************************************************

	DECLARE @dac VARCHAR(1) = dbo.FS_CalculoModulo11_BANESE(@codbarras, 9, 0)
	SET @codbarras = RIGHT('000' + CONVERT(VARCHAR(3), @cd_banco), 3) + --Codigo banco
	'9' + -- Moeda Real
	@dac +
	RIGHT('0000' + CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc)), 4) + -- Fator de Vencimento
	RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10) + -- Valor da Parcela 
	@campolivre --Campo Livre
	PRINT '###'
	PRINT @codbarras + '/'
	PRINT '###'
	SELECT
		SUBSTRING(@codbarras, 20, 25) --29003102228004434038          

	DECLARE @livretemp VARCHAR(200) = SUBSTRING(@codbarras, 20, 25)
	SET @linhadig1 = LEFT(@codbarras, 4) + SUBSTRING(@livretemp, 1, 5) --0479 + 31022
	SET @linhadig1 = @linhadig1 + dbo.FS_CalculoModulo10_BANESE(@linhadig1)
	SET @linhadig1 = SUBSTRING(@linhadig1, 1, 5) + '.' + SUBSTRING(@linhadig1, 6, 5)

	SET @linhadig2 = SUBSTRING(@livretemp, 6, 10)
	SET @linhadig2 = @linhadig2 + dbo.FS_CalculoModulo10_BANESE(@linhadig2)
	SET @linhadig2 = SUBSTRING(@linhadig2, 1, 5) + '.' + SUBSTRING(@linhadig2, 6, 6)

	SET @linhadig3 = SUBSTRING(@livretemp, 16, 10)
	SET @linhadig3 = @linhadig3 + dbo.FS_CalculoModulo10_BANESE(@linhadig3)
	SET @linhadig3 = SUBSTRING(@linhadig3, 1, 5) + '.' + SUBSTRING(@linhadig3, 6, 6)

	SET @linhadig4 = SUBSTRING(@codbarras, 5, 1)

	SET @linhadig5 = (SUBSTRING(@codbarras, 6, 14))


	PRINT '---'
	PRINT 'convenio: ' + @convenio
	PRINT 'digto: ' + CONVERT(VARCHAR(5), @convenio_dv)
	PRINT 'nn: ' + ISNULL(@nn, '')
	PRINT 'campo livre: ' + ISNULL(@campolivre, '')
	PRINT 'Codigo Br: ' + ISNULL(@codbarras, '')
	PRINT 'Tamanho CodBR:' + CONVERT(VARCHAR(10), ISNULL(LEN(@codbarras), 0))
	PRINT 'DigCodBarras: ' + CONVERT(VARCHAR(2), dbo.FS_DigitoVerificarCodigoBarras(@codbarras))
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
	PRINT 'valor: ' + CONVERT(VARCHAR(15), @vl_parcela_l)
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
	PRINT 'codBrVisual: ' + dbo.FG_TRADUZ_Codbarras(@codbarras)
	PRINT 'inst5: ' + @instrucao5
	PRINT 'inst6: ' + @instrucao6
	PRINT '---'

	PRINT @linhadig1
	PRINT @linhadig2
	PRINT @linhadig3
	PRINT @linhadig4
	PRINT @linhadig5
	PRINT 'CodBr: ' + @codbarras

	SET @nn = LEFT(@nn, LEN(@nn) - 1) + '-' + RIGHT(@nn, 1)


	---*****GRAVANDO TB BOLETO***************************
	INSERT Boleto (cd_sequencial_lote,
				   CD_ASSOCIADO_empresa,
				   CD_PARCELA,
				   Cedente,
				   cnpj,
				   DT_VENCIMENTO,
				   agencia,
				   dg_ag,
				   conta,
				   dg_conta,
				   Convenio,
				   dg_convenio,
				   carteira,
				   nn,
				   valor,
				   pagador,
				   cpf_cnpj_pagador,
				   end_pagador,
				   bai_pagador,
				   cep_pagador,
				   mun_pagador,
				   uf_pagador,
				   vl_multa,
				   vl_juros,
				   instrucao1,
				   instrucao2,
				   instrucao3,
				   instrucao4,
				   linha,
				   Barra,
				   cod_barra,
				   instrucao5,
				   instrucao6,
				   count_Parcela)

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
				@carteira,
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
				dbo.FG_TRADUZ_Codbarras(@codbarras),
				@instrucao5,
				@instrucao6,
				@count_parcela)
	---**********************************************************



	FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento,
	@vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa

	END -- 3.2
	CLOSE cursor_gera_processos_bancos_mens
	DEALLOCATE cursor_gera_processos_bancos_mens

	COMMIT
	SELECT
		@sequencial AS SEQUENCIALLOTE,
		@cd_banco CD_BANCO,
		0 ACEITAMULTIPLOSSERVICOBANCARIO
END
