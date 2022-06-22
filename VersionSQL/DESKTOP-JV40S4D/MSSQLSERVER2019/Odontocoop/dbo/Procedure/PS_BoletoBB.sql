/****** Object:  Procedure [dbo].[PS_BoletoBB]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_BoletoBB]
	@cd_tipopagamento SMALLINT,
	@incd_parcela VARCHAR(MAX),
	@cd_funcionario INT,
	@sequencial INT = 0
AS
BEGIN
	DECLARE @fl_loteinformado INT
	IF @sequencial = 0
	BEGIN
		SET @fl_loteinformado = 0
		SELECT
			@sequencial = ISNULL(MIN(cd_sequencial_lote), 0) - 1
		FROM Boleto
	END
	ELSE
	BEGIN
		SET @fl_loteinformado = 1
	END


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
	DECLARE @nfprepos INT
	DECLARE @nf INT

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
	SELECT
		@cd_tiposervico = T.cd_tipo_servico_bancario,
		--@cd_tipopagamento = t.cd_tipo_pagamento ,                
		@nm_tipopagamento = T.nm_tipo_pagamento,
		@cd_banco = T.banco,
		@convenio = T.Convenio,
		@convenio_dv = T.dv_convenio,
		@cedente = T.Cedente + ' - ' + T.nr_cnpj + ' </br>' + T.EndCedente,
		@nm_banco = B.nm_banco,
		@dt_finalizado = GETDATE(),
		@nr_cnpj = T.nr_cnpj,
		@tp_ag = T.ag,
		@tp_ag_dv = T.dv_ag,
		@cta = T.cta,
		@dv_cta = T.dv_cta,
		@carteira = carteira,
		@variacaocarteira = T.VariacaoCarteira,
		@juros = ISNULL(Perc_juros, 0),
		@multa = ISNULL(Perc_multa, 0),
		@taxa = ISNULL(vl_taxa, 0),
		@agencia = T.ag,
		@dv_ag = T.dv_ag,
		@qt_diasminimo = ISNULL(TSB.qt_diasminimo, 0),
		@instrucao3 = nm_mensagem1,
		@instrucao4 = nm_mensagem2,
		@instrucao5 = nm_mensagem3
	--FROM dbo.TIPO_PAGAMENTO AS T,
	--	 dbo.TB_Banco_Contratos AS B,
	--	 dbo.tipo_servico_bancario AS TSB
	--WHERE T.CD_TIPO_PAGAMENTO = @cd_tipopagamento
	--AND T.cd_tipo_servico_bancario = TSB.cd_tipo_servico_bancario
	--AND T.banco *= B.cd_banco

	FROM dbo.TIPO_PAGAMENTO AS T
		INNER JOIN dbo.tipo_servico_bancario TSB ON T.cd_tipo_servico_bancario = TSB.cd_tipo_servico_bancario
		LEFT OUTER JOIN dbo.TB_Banco_Contratos AS B ON T.banco = B.cd_banco
	WHERE T.CD_TIPO_PAGAMENTO = @cd_tipopagamento


	IF @@rowcount = 0
	BEGIN -- 1.2              
		RAISERROR ('Sequencial nao encontrado.', 16, 1)
		RETURN
	END -- 1.2              


	-- Validar variaveis obrigatorias               
	IF @cd_banco IS NULL
		OR @convenio IS NULL
		OR @cedente IS NULL
	BEGIN -- 2.1              
		RAISERROR ('Banco, Convênio ou Cedente não definidos na tabela de Tipo de Pagamento.', 16, 1)
		RETURN
	END -- 2.1                 


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
	IF @fl_loteinformado = 0
	BEGIN
		DELETE Boleto
		WHERE cd_sequencial_lote = @sequencial
	END

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
			A.NM_COMPLETO,
			LTRIM(ISNULL(TL.NOME_TIPO, '') + ' ' + A.EndLogradouro + ' ' +
			CASE
				WHEN A.EndNumero IS NULL THEN ''
				WHEN A.EndNumero = 0 THEN ' 0 '
				ELSE ', ' + CONVERT(VARCHAR(10), A.EndNumero)
			END + ' ' + ISNULL(A.EndComplemento, '')),
			ISNULL(B.baiDescricao, ''),
			A.LogCep,
			ISNULL(CID.NM_MUNICIPIO, ''),
			ISNULL(UF.ufSigla, ''),
			M.NOSSO_NUMERO,
			CASE
				WHEN ISNULL(A.taxa_cobranca, 1) = 1 THEN ISNULL(M.vl_taxa, 0)
				ELSE 0
			END,
			ISNULL(EMP.nf_pre_pospaga, 1),
			ISNULL(M.NF, -1)
		--FROM MENSALIDADES AS M,
		--	 ASSOCIADOS AS A,
		--	 TB_TIPOLOGRADOURO AS TL,
		--	 Bairro AS B,
		--	 MUNICIPIO AS CID,
		--	 UF,
		--	 TIPO_PAGAMENTO T5,
		--	 EMPRESA EMP
		--WHERE M.CD_PARCELA IN (SELECT
		--		id
		--	FROM @temptab)
		--AND M.CD_ASSOCIADO_empresa = A.cd_associado
		--AND M.TP_ASSOCIADO_EMPRESA = 1
		--AND A.CHAVE_TIPOLOGRADOURO *= TL.CHAVE_TIPOLOGRADOURO
		--AND A.BaiId *= B.BaiId
		--AND A.CidID *= CID.cd_municipio
		--AND A.ufId *= UF.ufId
		--AND M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
		--AND EMP.CD_EMPRESA = A.CD_EMPRESA

		FROM dbo.MENSALIDADES AS M
			INNER JOIN dbo.ASSOCIADOS AS A ON M.CD_ASSOCIADO_empresa = A.cd_associado
			LEFT OUTER JOIN TB_TIPOLOGRADOURO AS TL ON A.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO
			LEFT OUTER JOIN Bairro AS B ON A.BaiId = B.BaiId
			LEFT OUTER JOIN MUNICIPIO AS CID ON A.CidID = CID.cd_municipio
			LEFT OUTER JOIN UF ON A.ufId = dbo.UF.ufId
			INNER JOIN TIPO_PAGAMENTO T5 ON M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
			INNER JOIN EMPRESA EMP ON EMP.CD_EMPRESA = A.CD_EMPRESA
		WHERE M.CD_PARCELA IN (SELECT
				id
			FROM @temptab)
		AND M.TP_ASSOCIADO_EMPRESA = 1

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
			A.NM_FANTASIA NM_COMPLETO,
			LTRIM(ISNULL(TL.NOME_TIPO, '') + ' ' + A.EndLogradouro + ' ' +
			CASE
				WHEN A.EndNumero IS NULL THEN ''
				WHEN A.EndNumero = 0 THEN ' 0 '
				ELSE ', ' + CONVERT(VARCHAR(10), A.EndNumero)
			END + ' ' + ISNULL(A.EndComplemento, '')),
			ISNULL(B.baiDescricao, ''),
			A.Cep,
			ISNULL(CID.NM_MUNICIPIO, ''),
			ISNULL(UF.ufSigla, ''),
			M.NOSSO_NUMERO,
			0,
			ISNULL(EMP.nf_pre_pospaga, 1),
			ISNULL(M.NF, -1)
		--FROM MENSALIDADES AS M,
		--	 EMPRESA AS A,
		--	 TB_TIPOLOGRADOURO AS TL,
		--	 Bairro AS B,
		--	 MUNICIPIO AS CID,
		--	 UF,
		--	 TIPO_PAGAMENTO T5,
		--	 EMPRESA EMP
		--WHERE M.CD_PARCELA IN (SELECT
		--		id
		--	FROM @temptab)
		--AND M.CD_ASSOCIADO_empresa = A.CD_EMPRESA
		--AND M.TP_ASSOCIADO_EMPRESA IN (2, 3)
		--AND A.CHAVE_TIPOLOGRADOURO *= TL.CHAVE_TIPOLOGRADOURO
		--AND A.BaiId *= B.BaiId
		--AND A.cd_municipio *= CID.cd_municipio
		--AND A.ufId *= UF.ufId
		--AND M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
		--AND EMP.CD_EMPRESA = A.CD_EMPRESA
		--ORDER BY nm_completo, M.CD_ASSOCIADO_empresa, M.DT_VENCIMENTO ASC--m.cd_parcela             

		FROM dbo.MENSALIDADES AS M
			INNER JOIN dbo.EMPRESA AS A ON M.CD_ASSOCIADO_empresa = A.CD_EMPRESA
			LEFT OUTER JOIN dbo.TB_TIPOLOGRADOURO AS TL ON A.CHAVE_TIPOLOGRADOURO = TL.CHAVE_TIPOLOGRADOURO
			LEFT OUTER JOIN dbo.Bairro AS B ON A.BaiId = B.BaiId
			LEFT OUTER JOIN dbo.MUNICIPIO AS CID ON A.cd_municipio = CID.cd_municipio
			LEFT OUTER JOIN dbo.UF ON A.ufId = dbo.UF.ufId
			INNER JOIN dbo.TIPO_PAGAMENTO T5 ON M.CD_TIPO_PAGAMENTO = T5.CD_TIPO_PAGAMENTO
			INNER JOIN dbo.EMPRESA EMP ON EMP.CD_EMPRESA = A.CD_EMPRESA
		WHERE M.CD_PARCELA IN (SELECT
				id
			FROM @temptab)
		AND M.TP_ASSOCIADO_EMPRESA IN (2, 3)
		ORDER BY NM_COMPLETO, M.CD_ASSOCIADO_empresa, M.DT_VENCIMENTO ASC

	OPEN cursor_gera_processos_bancos_mens
	FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento,
	@vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa, @nfprepos, @nf

	WHILE (@@fetch_status <> -1)
	BEGIN  -- 4.2               
	SET @instrucao2 = ''
	SET @count_parcela = @count_parcela + 1
	SET @dt_vencimento_parc = @dt_vencimento

	SET @instrucao1 = 'Ref.: Mensalidade ' + RIGHT(CONVERT(VARCHAR(10), DATEADD(MONTH, 1 - @nfprepos, @dt_vencimento_parc), 103), 7)

	IF @nf > -1
	BEGIN
		SET @instrucao2 = 'NF ' + CONVERT(VARCHAR(20), @nf) + '. '
	END
	SET @instrucao2 = @instrucao2 + 'Após o vencimento cobrar: Juros de R$ ' + REPLACE(CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @juros / 100 / 30 * 100, 0) / 100), '.', ',') + ' ao dia.'

	SELECT
		@instrucao2 = @instrucao2 + ' Multa de R$ ' + REPLACE(CONVERT(VARCHAR(10), ROUND(@vl_parcela_l * @multa / 100 * 100, 0) / 100), '.', ',') + '.'

	--***Gerando NN caso nao exista**************************              
	IF (@nn IS NULL
		OR @nn = '')
	BEGIN
		IF @cd_banco = 1
			SET @nn = '1' + RIGHT('0000000000' + CONVERT(VARCHAR(10), @cd_parcela), 9)     -- alterado 21/09/2015              
		ELSE
			SET @nn = '1' + RIGHT('0000000000' + CONVERT(VARCHAR(10), @cd_parcela), 10)-- alterado 21/09/2015              

		PRINT 'NN novo: ' + @nn
		UPDATE MENSALIDADES
		SET cd_sequencial_lote_boleto = @sequencial,
			CD_USUARIO_ALTERACAO = @cd_funcionario,
			DT_ALTERACAO = GETDATE(),
			NOSSO_NUMERO = @nn
		WHERE CD_PARCELA = @cd_parcela
	END
	--*****************************************************              

	SET @vl_total = @vl_total + CONVERT(INT, @vl_parcela_l * 100)
	SET @qtde = @qtde + 1

	IF @cd_banco = 1
	BEGIN
		SET @nn = RIGHT('000000000000' + @nn, 10)
		SET @nn = LEFT(CONVERT(VARCHAR(10), @convenio), 7) + @nn

		---***CAMPO LIVRE***************************************              
		SET @campolivre = '000000' + @nn + LEFT(CONVERT(VARCHAR(10), @carteira) + '00', 2)
		SET @campolivre = @campolivre + dbo.FS_CalculoModulo11_CNAB240(@campolivre, 3)

	---********************************************************              

	END
	ELSE
	BEGIN
		--Set @nn = right('000000000000'+@nn,15)              
		--Set @nn = convert(varchar(2),@carteira) + @nn + convert(varchar(5),dbo.FS_CalculoModulo11_CNAB240(convert(varchar(2),@carteira) + @nn,4))              

		---***CAMPO LIVRE***************************************              
		SET @campolivre = @convenio + ISNULL(@convenio_dv, '') + SUBSTRING(@nn, 3, 3) + SUBSTRING(@nn, 1, 1) + SUBSTRING(@nn, 6, 3) + SUBSTRING(@nn, 2, 1) + SUBSTRING(@nn, 9, 9)
		SET @campolivre = @campolivre + dbo.FS_CalculoModulo11_CNAB240(@campolivre, 3)

	---********************************************************                      
	END

	PRINT 'carteira: ' + CONVERT(VARCHAR(10), @carteira)
	PRINT 'nn: ' + ISNULL(@nn, '')
	PRINT RIGHT('00' + CONVERT(VARCHAR(3), @cd_banco), 3) + '9'
	PRINT CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc))
	PRINT RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10)
	PRINT @campolivre
	PRINT 'xxxxxxxxxxxxxx'

	SET @codbarras = RIGHT('00' + CONVERT(VARCHAR(3), @cd_banco), 3) + '9' + CONVERT(VARCHAR(4), DATEDIFF(DAY, '10/07/1997', @dt_vencimento_parc)) + -- Fator de Vencimento              
	RIGHT('00000000000' + REPLACE(CONVERT(VARCHAR(12), CONVERT(INT, FLOOR((@vl_parcela_m + @taxa) * 100))), '.', ''), 10) + -- Valor da Parcela               
	@campolivre


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
	PRINT 'codBrVisual: ' + dbo.FG_TRADUZ_Codbarras(@codbarras)
	PRINT 'inst5: ' + @instrucao5
	PRINT 'inst6: ' + @instrucao6
	PRINT '---'

	SET @codbarras = LEFT(@codbarras, 4) + dbo.FS_DigitoVerificarCodigoBarras(@codbarras) + RIGHT(@codbarras, 39)

	SET @linhadig1 = LEFT(@codbarras, 4) + LEFT(@campolivre, 5)
	SET @linhadig1 = LEFT(@linhadig1, 5) + '.' + RIGHT(@linhadig1, 4) + dbo.FS_CalculoModulo10(@linhadig1)

	SET @linhadig2 = SUBSTRING(@campolivre, 6, 10)
	SET @linhadig2 = LEFT(@linhadig2, 5) + '.' + RIGHT(@linhadig2, 5) + dbo.FS_CalculoModulo10(@linhadig2)

	SET @linhadig3 = SUBSTRING(@campolivre, 16, 10)
	SET @linhadig3 = LEFT(@linhadig3, 5) + '.' + RIGHT(@linhadig3, 5) + dbo.FS_CalculoModulo10(@linhadig3)

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
	PRINT 'Ini boleto'
	---*****GRAVANDO TB BOLETO***************************              
	INSERT Boleto (cd_sequencial_lote,
				   cd_associado_empresa,
				   cd_parcela,
				   cedente,
				   cnpj,
				   dt_vencimento,
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
				UPPER(@cedente),
				@nr_cnpj,
				CONVERT(VARCHAR(10), @dt_vencimento, 103),
				ISNULL(@agencia, ''),
				ISNULL(@dv_ag, ''),
				ISNULL(@cta, ''),
				ISNULL(@dv_cta, ''),
				ISNULL(@convenio, ''),
				ISNULL(@convenio_dv, ''),
				CONVERT(VARCHAR(10), @carteira),
				@nn,
				@vl_parcela_l,
				UPPER(@nome),
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
	PRINT 'fim boleto'


	FETCH NEXT FROM cursor_gera_processos_bancos_mens INTO @cd_associado_empresa, @cd_parcela, @cd_tipo_pagamento_m, @vl_parcela_m, @dt_vencimento,
	@vl_parcela_l, @cd_tipo_recebimento, @cpf_cnpj, @nome, @endereco, @bairro, @cep, @cidade, @uf, @nn, @taxa, @nfprepos, @nf

	END -- 3.2              
	CLOSE cursor_gera_processos_bancos_mens
	DEALLOCATE cursor_gera_processos_bancos_mens

	COMMIT

	SELECT
		@sequencial AS SEQUENCIALLOTE,
		@cd_banco CD_BANCO,
		0 AS ACEITAMULTIPLOSSERVICOBANCARIO

END
