/****** Object:  Procedure [dbo].[sp_gera_processos_bancos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[sp_gera_processos_bancos] @cd_tipo_pagamento SMALLINT,
	@cd_tipo_servico_bancario SMALLINT,
	@equipe SMALLINT = NULL,
	@padrao SMALLINT = 1,
	@periodo_inicial DATETIME = NULL,
	@periodo_final DATETIME = NULL,
	@NaoretornaMensagem SMALLINT = NULL -- Quando for passado o parametro se o lote ja estiver registro com CD_Retorno is not null nao volta mensagem  de erro apenas RETURN
	-- Incluido 16.11
AS
BEGIN
	--return 
	IF @equipe = - 1
		SET @equipe = NULL

	BEGIN TRANSACTION

	DECLARE @cd_sequencial INT
	DECLARE @cd_funcionario INT
	DECLARE @vl MONEY
	DECLARE @qtlinha INT = 0
	DECLARE @cd_ass INT
	DECLARE @nm_sacado VARCHAR(100)
	DECLARE @dt_venc DATETIME
	DECLARE @dt_venc_B DATETIME
	DECLARE @dt_venc_Final DATETIME
	DECLARE @dt_venc_Final_Carne DATETIME
	-- Incluido 16.11
	DECLARE @tipoMov AS SMALLINT -- 1 - Processo Normal de Faturamento, 2 - Mudanca nas informacoes
	DECLARE @Acao AS SMALLINT -- 1 - Incluir , 100 - Alterar 
	DECLARE @flag_noarquivo AS SMALLINT
	-- Fim bloco : Incluido 16.11
	DECLARE @cd_ass_old INT = 0
	DECLARE @qtde_repeticao SMALLINT = 0
	DECLARE @qtde_repeticao_max SMALLINT = 1
	DECLARE @equipe_padrao INT

	SELECT @equipe_padrao = min(cd_equipe)
	FROM equipe_vendas

	DECLARE @carne INT
	DECLARE @fl_cobranca_registrada SMALLINT

	SELECT @qtde_repeticao_max = isnull(qt_maxima_repeticao_arquivo, 1),
		@carne = isnull(fl_carne, 0)
	FROM tipo_servico_bancario
	WHERE cd_tipo_servico_bancario = @cd_tipo_servico_bancario

	SELECT @fl_cobranca_registrada = convert(SMALLINT, isnull(fl_cobranca_registrada, 0))
	FROM TIPO_PAGAMENTO
	WHERE cd_tipo_pagamento = @cd_tipo_pagamento

	SET @cd_funcionario = 0

	SELECT @cd_funcionario = cd_funcionario
	FROM processos
	WHERE cd_processo = 1

	IF @cd_funcionario = 0
		OR @cd_funcionario IS NULL
	BEGIN -- 1.1
		ROLLBACK TRANSACTION

		RAISERROR (
				'Funcionario de atualização do Processo não definido.',
				16,
				1
				)

		RETURN
	END -- 1.1

	SET @cd_sequencial = 0

	PRINT '----PB 1'

	SELECT @cd_sequencial = isnull(max(cd_sequencial), 0)
	FROM lote_processos_bancos
	WHERE cd_tipo_pagamento = @cd_tipo_pagamento
		AND cd_tipo_servico_bancario = @cd_tipo_servico_bancario
		AND dt_finalizado IS NULL
		AND isnull(cd_equipe, 0) = ISNULL(@equipe, 0)
		AND isnull(cd_tipo_arquivo_banco, 1) = @padrao -- Incluido 

	-- Se o Sequencial já existir ver se algum registro que modificou de tipo de pagamento ou esta baixado
	IF @cd_sequencial > 0
	BEGIN -- 0 
		PRINT '----PB 2'
		PRINT @cd_sequencial
		PRINT @cd_tipo_pagamento

		-- Se tiver registro ja enviado para o Banco nao pode regerar o lote 
		IF (
				SELECT COUNT(0)
				FROM Lote_Processos_Bancos_Mensalidades
				WHERE cd_sequencial_lote = @cd_sequencial
					AND cd_retorno IS NOT NULL
				) > 0
		BEGIN
			ROLLBACK TRANSACTION

			IF @NaoretornaMensagem IS NULL
				RAISERROR (
						'Lote não pode ser regerado, pois tem registros ja enviado para os agentes financeiros.',
						16,
						1
						) -- Devolve mensagem se foi gerado pelo usuario

			RETURN
		END

		UPDATE mensalidades
		SET cd_lote_processo_banco = NULL,
			cd_usuario_alteracao = @cd_funcionario
		WHERE cd_lote_processo_banco = @cd_sequencial -- and 
			-- (cd_tipo_pagamento <> @cd_tipo_pagamento or cd_tipo_recebimento<>0)

		DELETE Lote_Processos_Bancos_Mensalidades
		WHERE cd_sequencial_lote = @cd_sequencial --and 
			-- cd_parcela not in (select cd_parcela from mensalidades where cd_lote_processo_banco = @cd_sequencial)

		PRINT '----PB F 2'
	END -- 0 

	-- Verificar se existe cd_tipo_servico_bancario p/ cd_tipo_pagamento 
	IF (
			SELECT count(0)
			FROM tipo_pagamento
			WHERE cd_tipo_pagamento = @cd_tipo_pagamento
				AND cd_tipo_servico_bancario = @cd_tipo_servico_bancario
			) = 0
	BEGIN -- 1 
		ROLLBACK TRANSACTION

		RAISERROR (
				'Erro na checagem dos dados.',
				16,
				1
				)

		RETURN
	END -- 1 

	SELECT @dt_venc_B = CASE 
			WHEN fl_recorrente = 0
				THEN DATEADD(day, qt_diasminimo, getdate())
			ELSE '03/01/2013'
			END
	FROM tipo_servico_bancario
	WHERE cd_tipo_servico_bancario = @cd_tipo_servico_bancario

	SET @dt_venc_B = CONVERT(VARCHAR(10), @dt_venc_B, 101)

	----select @dt_venc_Final = case when fl_recorrente = 0 then DATEADD(day,qt_diasmaximo,getdate()) else DATEADD(day,1,getdate()) end from tipo_servico_bancario where cd_tipo_servico_bancario = @cd_tipo_servico_bancario
	SELECT @dt_venc_Final = DATEADD(day, qt_diasmaximo, getdate()),
		@dt_venc_Final_Carne = DATEADD(day, isnull(qt_diasmaximo_1carne, 0), getdate())
	FROM tipo_servico_bancario
	WHERE cd_tipo_servico_bancario = @cd_tipo_servico_bancario

	SET @dt_venc_Final = CONVERT(VARCHAR(10), @dt_venc_Final, 101)
	SET @dt_venc_Final_Carne = CONVERT(VARCHAR(10), @dt_venc_Final_Carne, 101)

	PRINT '@dt_venc_B : @dt_venc_Final : @dt_venc_Final_Carne : @cd_tipo_pagamento : @carne : @equipe'
	PRINT @dt_venc_B
	PRINT @dt_venc_Final
	PRINT @dt_venc_Final_Carne
	PRINT @cd_tipo_pagamento
	PRINT @carne
	PRINT @equipe
	PRINT '-------------------------------------------------------------'

	-- Criar o cursor com todos os novos registros
	DECLARE @cd_parcela INT

	DECLARE cursor_gera_processos_bancos CURSOR
	FOR
	/*- Incluido 16.11  
order by m.dt_vencimento*/
	SELECT m.CD_PARCELA,
		m.VL_PARCELA + ISNULL(m.VL_Acrescimo, 0) - ISNULL(m.VL_Desconto, 0) - ISNULL(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.VL_AcrescimoAvulso, 0) - ISNULL(m.VL_DescontoAvulso, 0) AS Expr1,
		m.CD_ASSOCIADO_empresa,
		a.nm_completo,
		m.DT_VENCIMENTO,
		1 AS tipoMov,
		1 AS Acao
	FROM MENSALIDADES AS m
	INNER JOIN ASSOCIADOS AS a ON m.CD_ASSOCIADO_empresa = a.cd_associado
	INNER JOIN DEPENDENTES AS d ON a.cd_associado = d.CD_ASSOCIADO
	INNER JOIN HISTORICO AS h ON d.CD_Sequencial_historico = h.cd_sequencial
	INNER JOIN SITUACAO_HISTORICO AS sh ON h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
	LEFT OUTER JOIN FUNCIONARIO AS f ON d.cd_funcionario_vendedor = f.cd_funcionario
	WHERE (d.CD_GRAU_PARENTESCO = 1)
		AND (sh.fl_envia_cobranca = 1)
		AND (m.TP_ASSOCIADO_EMPRESA = 1)
		AND (m.CD_TIPO_PAGAMENTO = @cd_tipo_pagamento)
		AND (m.cd_lote_processo_banco IS NULL)
		AND (m.CD_TIPO_RECEBIMENTO = 0)
		AND (m.cd_tipo_parcela = 1)
		AND (m.DT_VENCIMENTO >= @dt_venc_B)
		AND (m.DT_VENCIMENTO <= @dt_venc_Final)
		AND (m.VL_PARCELA > 0)
		AND (
			m.CD_ASSOCIADO_empresa IN (
				SELECT CD_ASSOCIADO_empresa
				FROM MENSALIDADES AS m1
				WHERE (TP_ASSOCIADO_EMPRESA = 1)
					AND (CD_TIPO_PAGAMENTO = @cd_tipo_pagamento)
					AND (cd_lote_processo_banco IS NULL)
					AND (CD_TIPO_RECEBIMENTO = 0)
					AND (cd_tipo_parcela = 1)
					AND (DT_VENCIMENTO >= @dt_venc_B)
					AND (
						DT_VENCIMENTO <= CASE 
							WHEN @carne = 1
								THEN @dt_venc_Final_Carne
							ELSE @dt_venc_Final
							END
						)
					AND (VL_PARCELA > 0)
				GROUP BY CD_ASSOCIADO_empresa
				HAVING (
						MIN(DT_VENCIMENTO) <= DATEADD(month, CASE 
								WHEN @carne = 1
									THEN 1
								ELSE 99
								END, GETDATE())
						)
				)
			)
		AND (
			m.CD_PARCELA NOT IN (
				SELECT a.cd_parcela
				FROM MensalidadesAgrupadas AS a
				INNER JOIN MENSALIDADES AS m1 ON a.cd_parcelaMae = m1.CD_PARCELA
				WHERE (
						DATEADD(day, ISNULL((
									SELECT qt_dias_expira_boletovirtual
									FROM Configuracao
									), 0), m1.DT_VENCIMENTO) >= CONVERT(VARCHAR(10), GETDATE(), 101)
						)
					AND (m1.CD_TIPO_RECEBIMENTO NOT IN (1))
				)
			)
		AND (ISNULL(f.cd_equipe, 16) = ISNULL(@equipe, ISNULL(f.cd_equipe, 16)))
		AND (
			@padrao IN (
				1,
				3
				)
			)
	
	UNION
	
	SELECT m.cd_parcela,
		m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0), -- Alterado 18.11
		m.cd_associado_empresa,
		a.nm_razsoc AS nm_completo,
		m.dt_vencimento, -- Alterado 16.11
		1 AS tipoMov,
		1 AS Acao -- Incluido 16.11	 
	FROM mensalidades AS m,
		empresa AS a,
		HISTORICO AS h,
		SITUACAO_HISTORICO AS sh
	WHERE m.cd_associado_empresa = a.cd_empresa
		AND a.CD_Sequencial_historico = h.cd_sequencial
		AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
		AND sh.fl_envia_cobranca = 1
		AND m.tp_associado_empresa IN (
			2,
			3
			)
		AND m.cd_tipo_pagamento = @cd_tipo_pagamento
		AND m.cd_lote_processo_banco IS NULL
		AND m.cd_tipo_recebimento = 0
		AND m.cd_tipo_parcela = 1
		AND m.dt_vencimento >= @dt_venc_B
		AND m.dt_vencimento <= @dt_venc_Final
		AND m.vl_parcela > 0
		AND --- Incluido 16.11  
		@padrao IN (
			1,
			3
			) --- Incluido 16.11
	
	UNION -- Incluido 16.11
	
	SELECT m.cd_parcela,
		m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0),
		m.cd_associado_empresa,
		a.nm_completo,
		isnull(m.dt_vencimento_new, m.dt_vencimento) AS dt_vencimento,
		2 AS tipoMov,
		CASE 
			WHEN m.cd_lote_processo_banco IS NULL
				THEN 1 -- Nao foi enviado ao Banco -- -- Incluir
			WHEN m.CD_TIPO_PAGAMENTO <> ma.cd_tipo_pagamento
				THEN 2 -- Mudou o tipo de Pagamento -- Incluir
			WHEN isnull(m.dt_vencimento_new, m.dt_vencimento) <> ISNULL(ma.dt_vencimento_new, ma.dt_vencimento)
				THEN 6 -- Mudanca de Vencimento
			ELSE 31 -- valor 
			END AS Acao
	FROM MensalidadesAlteracoes AS ma
	INNER JOIN mensalidades AS m ON ma.cd_parcela = m.cd_parcela
	INNER JOIN tipo_pagamento AS t ON m.CD_TIPO_PAGAMENTO = t.cd_tipo_pagamento
		AND t.fl_cobranca_registrada = 1
	INNER JOIN associados AS a ON m.CD_ASSOCIADO_empresa = a.cd_associado
		AND m.TP_ASSOCIADO_EMPRESA = 1
	WHERE m.CD_TIPO_RECEBIMENTO = 0
		AND (
			(isnull(m.dt_vencimento_new, m.dt_vencimento) <> ISNULL(ma.dt_vencimento_new, ma.dt_vencimento))
			OR (m.vl_parcela + ISNULL(m.vl_acrescimo, 0) - ISNULL(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0) <> ma.vl_parcela + ISNULL(ma.vl_acrescimo, 0) - ISNULL(ma.vl_desconto, 0) - isnull(ma.vl_imposto, 0) + ISNULL(ma.vl_taxa, 0) + ISNULL(ma.VL_JurosMultaReferencia, 0) + ISNULL(ma.vl_acrescimoavulso, 0) - ISNULL(ma.VL_DescontoAvulso, 0))
			OR (m.CD_TIPO_PAGAMENTO <> ma.cd_tipo_pagamento)
			)
		--  and ma.cd_parcela in (1709142,1737821) 
		AND isnull(m.dt_vencimento_new, m.dt_vencimento) >= CONVERT(VARCHAR(10), getdate(), 101)
		AND ma.dt_inclusao_tabela > (
			SELECT TOP 1 dt_gerado
			FROM Lote_Processos_Bancos
			WHERE cd_tipo_pagamento = 145
				AND dt_finalizado IS NOT NULL
			ORDER BY dt_finalizado DESC
			)
		AND @padrao IN (
			2,
			3
			) --- Incluido 16.11
		AND m.cd_tipo_pagamento = @cd_tipo_pagamento
		AND m.TP_ASSOCIADO_EMPRESA = 1
	
	UNION
	
	SELECT m.cd_parcela,
		m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0),
		m.cd_associado_empresa,
		a.NM_RAZSOC,
		isnull(m.dt_vencimento_new, m.dt_vencimento) AS dt_vencimento,
		2 AS tipoMov,
		CASE 
			WHEN m.cd_lote_processo_banco IS NULL
				THEN 1 -- Nao foi enviado ao Banco -- -- Incluir
			WHEN m.CD_TIPO_PAGAMENTO <> ma.cd_tipo_pagamento
				THEN 2 -- Mudou o tipo de Pagamento -- Incluir
			WHEN isnull(m.dt_vencimento_new, m.dt_vencimento) <> ISNULL(ma.dt_vencimento_new, ma.dt_vencimento)
				THEN 6 -- Mudanca de Vencimento
			ELSE 31 -- valor 
			END AS Acao
	FROM MensalidadesAlteracoes AS ma
	INNER JOIN mensalidades AS m ON ma.cd_parcela = m.cd_parcela
	INNER JOIN tipo_pagamento AS t ON m.CD_TIPO_PAGAMENTO = t.cd_tipo_pagamento
		AND t.fl_cobranca_registrada = 1
	INNER JOIN empresa AS a ON m.CD_ASSOCIADO_empresa = a.CD_EMPRESA
		AND m.TP_ASSOCIADO_EMPRESA = 2
	WHERE m.CD_TIPO_RECEBIMENTO = 0
		AND (
			(isnull(m.dt_vencimento_new, m.dt_vencimento) <> ISNULL(ma.dt_vencimento_new, ma.dt_vencimento))
			OR (m.vl_parcela + ISNULL(m.vl_acrescimo, 0) - ISNULL(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0) <> ma.vl_parcela + ISNULL(ma.vl_acrescimo, 0) - ISNULL(ma.vl_desconto, 0) - isnull(ma.vl_imposto, 0) + ISNULL(ma.vl_taxa, 0) + ISNULL(ma.VL_JurosMultaReferencia, 0) + ISNULL(ma.vl_acrescimoavulso, 0) - ISNULL(ma.VL_DescontoAvulso, 0))
			OR (m.CD_TIPO_PAGAMENTO <> ma.cd_tipo_pagamento)
			)
		-- and ma.cd_parcela in (1709142,1737821) 
		AND isnull(m.dt_vencimento_new, m.dt_vencimento) >= CONVERT(VARCHAR(10), getdate(), 101)
		AND ma.dt_inclusao_tabela > (
			SELECT TOP 1 dt_gerado
			FROM Lote_Processos_Bancos
			WHERE cd_tipo_pagamento = 145
				AND dt_finalizado IS NOT NULL
			ORDER BY dt_finalizado DESC
			)
		AND @padrao IN (
			2,
			3
			) --- Incluido 16.11
		AND m.cd_tipo_pagamento = @cd_tipo_pagamento
		AND m.TP_ASSOCIADO_EMPRESA = 2
	
	UNION
	
	SELECT m.cd_parcela,
		m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0), -- Alterado 18.11
		m.cd_associado_empresa,
		a.nm_completo,
		isnull(m.dt_vencimento_new, m.dt_vencimento) AS dt_vencimento, -- Alterado 16.11
		2 AS tipoMov,
		1 AS Acao -- Incluido 16.11  -- Inclusao de boletos que nao sao Planos e Adesao 
	FROM mensalidades AS m,
		associados AS a,
		dependentes AS d,
		HISTORICO AS h,
		SITUACAO_HISTORICO AS sh,
		tipo_pagamento AS t
	WHERE m.cd_associado_empresa = a.cd_Associado
		AND a.cd_associado = d.CD_ASSOCIADO
		AND d.CD_GRAU_PARENTESCO = 1
		AND d.CD_Sequencial_historico = h.cd_sequencial
		AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
		AND
		--  sh.fl_envia_cobranca=1 and 
		m.tp_associado_empresa = 1
		AND m.CD_TIPO_PAGAMENTO = t.cd_tipo_pagamento
		AND t.fl_cobranca_registrada = 1
		AND m.cd_tipo_pagamento = @cd_tipo_pagamento
		AND m.cd_lote_processo_banco IS NULL
		AND m.cd_tipo_recebimento = 0
		AND isnull(m.dt_vencimento_new, m.dt_vencimento) >= CONVERT(VARCHAR(10), getdate(), 101)
		AND m.vl_parcela > 0
		AND m.cd_tipo_parcela > 2
		AND --- Incluido 16.11  
		@padrao IN (
			2,
			3
			) --- Incluido 16.11    
	
	UNION
	
	SELECT m.cd_parcela,
		m.vl_parcela + isnull(m.vl_acrescimo, 0) - isnull(m.vl_desconto, 0) - isnull(m.vl_imposto, 0) + ISNULL(m.vl_taxa, 0) + ISNULL(m.VL_JurosMultaReferencia, 0) + ISNULL(m.vl_acrescimoavulso, 0) - ISNULL(m.VL_DescontoAvulso, 0), -- Alterado 18.11
		m.cd_associado_empresa,
		a.nm_razsoc AS nm_completo,
		isnull(m.dt_vencimento_new, m.dt_vencimento) AS dt_vencimento, -- Alterado 16.11
		2 AS tipoMov,
		1 AS Acao -- Incluido 16.11 -- Inclusao de boletos que nao sao Planos e Adesao 
	FROM mensalidades AS m,
		empresa AS a,
		HISTORICO AS h,
		SITUACAO_HISTORICO AS sh,
		tipo_pagamento AS t
	WHERE m.cd_associado_empresa = a.cd_empresa
		AND a.CD_Sequencial_historico = h.cd_sequencial
		AND h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
		AND
		-- sh.fl_envia_cobranca=1 and 
		m.tp_associado_empresa IN (
			2,
			3
			)
		AND m.CD_TIPO_PAGAMENTO = t.cd_tipo_pagamento
		AND t.fl_cobranca_registrada = 1
		AND m.cd_tipo_pagamento = @cd_tipo_pagamento
		AND m.cd_lote_processo_banco IS NULL
		AND m.cd_tipo_recebimento = 0
		AND isnull(m.dt_vencimento_new, m.dt_vencimento) >= CONVERT(VARCHAR(10), getdate(), 101)
		AND m.vl_parcela > 0
		AND m.cd_tipo_parcela > 2
		AND --- Incluido 16.11  
		@padrao IN (
			2,
			3
			) --- Incluido 16.11
		-- Fim Bloco Incluido 16.11       
	ORDER BY tipoMov,
		Acao,
		m.cd_associado_empresa,
		m.dt_vencimento -- Alterado 16.11            

	OPEN cursor_gera_processos_bancos

	FETCH NEXT
	FROM cursor_gera_processos_bancos
	INTO @cd_parcela,
		@vl,
		@cd_ass,
		@nm_sacado,
		@dt_venc,
		@tipoMov,
		@acao

	WHILE (@@FETCH_STATUS <> - 1)
	BEGIN
		IF @cd_sequencial = 0
		BEGIN
			PRINT '----PB 3'

			INSERT INTO lote_processos_bancos (
				cd_tipo_servico_bancario,
				cd_tipo_pagamento,
				dt_gerado,
				cd_funcionario,
				cd_tipo_arquivo_banco,
				periodo_inicial,
				periodo_final
				)
			VALUES (
				@cd_tipo_servico_bancario,
				@cd_tipo_pagamento,
				getdate(),
				@cd_funcionario,
				@padrao,
				@periodo_inicial,
				@periodo_final
				)

			IF @@Rowcount = 0
			BEGIN -- 2
				CLOSE cursor_gera_processos_bancos

				DEALLOCATE cursor_gera_processos_bancos

				ROLLBACK TRANSACTION

				RAISERROR (
						'Erro na criação do Lote.',
						16,
						1
						)

				RETURN
			END -- 2

			SELECT @cd_sequencial = max(cd_sequencial)
			FROM lote_processos_bancos
			WHERE cd_tipo_pagamento = @cd_tipo_pagamento
				AND cd_tipo_servico_bancario = @cd_tipo_servico_bancario
				AND dt_finalizado IS NULL
				AND cd_tipo_arquivo_banco = @padrao -- incluido 16.11 				         

			PRINT '----PB F 3'
		END

		IF @cd_ass_old <> @cd_ass
		BEGIN -- 
			SET @cd_ass_old = @cd_ass
			SET @qtde_repeticao = 0
		END

		SET @flag_noarquivo = NULL

		-- Incluido 16.11
		IF @tipoMov = 2
			AND @acao > 1 -- Conferir p nao enviar 2x
		BEGIN
			SELECT @flag_noarquivo = COUNT(0)
			FROM Lote_Processos_Bancos_Mensalidades
			WHERE cd_sequencial_lote = @cd_sequencial
				AND cd_parcela = @cd_parcela
				AND cd_tipo_arquivo_banco = @tipoMov
				AND cd_acao_banco = @acao
		END

		-- Fim Bloco: Incluido 16.11
		IF @qtde_repeticao < @qtde_repeticao_max
			OR
			-- @acao = 1 or 
			(
				@tipoMov = 2
				AND ISNULL(@flag_noarquivo, 0) = 0
				) -- Incluido 16.11
		BEGIN -- Inicio @qtde_repeticao
			SET @qtde_repeticao = @qtde_repeticao + 1
			SET @qtlinha = @qtlinha + 1

			PRINT @qtlinha

			IF @tipoMov = 1
				OR (
					@tipoMov = 2
					AND @Acao = 1
					) -- Alterado 16.11
			BEGIN
				IF @fl_cobranca_registrada = 1
				BEGIN
					UPDATE mensalidades
					SET cd_lote_processo_banco = @cd_sequencial,
						cd_usuario_alteracao = @cd_funcionario,
						NOSSO_NUMERO = CASE 
							WHEN NOSSO_NUMERO IS NOT NULL
								THEN NOSSO_NUMERO
							ELSE '1' + right('0000000000' + convert(VARCHAR(10), @cd_parcela), 10)
							END
					WHERE cd_parcela = @cd_parcela
				END
				ELSE
				BEGIN
					UPDATE mensalidades
					SET cd_lote_processo_banco = @cd_sequencial,
						cd_usuario_alteracao = @cd_funcionario,
						NOSSO_NUMERO = '1' + right('0000000000' + convert(VARCHAR(10), @cd_parcela), 10)
					WHERE cd_parcela = @cd_parcela
				END
			END

			--print '----PB F4'
			INSERT Lote_Processos_Bancos_Mensalidades (
				cd_sequencial_lote,
				cd_parcela,
				cd_Associado,
				nm_sacado,
				dt_vencimento,
				vl_parcela,
				cd_tipo_arquivo_banco,
				cd_acao_banco
				)
			VALUES (
				@cd_sequencial,
				@cd_parcela,
				@cd_ass,
				@nm_sacado,
				@dt_venc,
				@vl,
				@tipoMov,
				@acao
				)
		END

		FETCH NEXT
		FROM cursor_gera_processos_bancos
		INTO @cd_parcela,
			@vl,
			@cd_ass,
			@nm_sacado,
			@dt_venc,
			@tipoMov,
			@acao
	END

	CLOSE cursor_gera_processos_bancos

	DEALLOCATE cursor_gera_processos_bancos

	COMMIT

	---Gerar Impressao Externa 
	EXEC dbo.SP_Gera_Processos_Impressao @cd_tipo_pagamento,
		@cd_tipo_servico_bancario,
		@equipe,
		@padrao
		-- -- Remover do Lotes os vencimentos q possuem + de 30 dias
		-- 		update mensalidades 
		--  set cd_lote_processo_banco = null , 
		--            cd_usuario_alteracao = @cd_funcionario
		--where cd_lote_processo_banco = @cd_sequencial  
		--  and TP_ASSOCIADO_EMPRESA = 1 
		--  and CD_ASSOCIADO_empresa  not in (
		--	select cd_associado -- ,MIN(dt_vencimento)--,COUNT(0) 
		--	  from lote_processos_bancos_mensalidades 
		--	 where cd_sequencial_lote=@cd_sequencial 
		--	 group by cd_associado 
		--	 having MIN(dt_vencimento) <= dateadd(month,1,getdate()	)
		--	 )
		-- delete Lote_Processos_Bancos_Mensalidades 
		--  where cd_sequencial_lote = @cd_sequencial 
		--    and cd_Associado not in (
		-- select cd_associado -- ,MIN(dt_vencimento)--,COUNT(0) 
		--   from lote_processos_bancos_mensalidades 
		--  where cd_sequencial_lote=@cd_sequencial 
		--  group by cd_associado 
		--  having MIN(dt_vencimento) <= dateadd(month,1,getdate())
		--     ) 
END
