/****** Object:  Procedure [dbo].[PS_CaixaProjetado]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Data e Hora.: 2022-05-24 14:41:11
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
TRECHOS NO CÓDIGO FORAM COMENTADOS E DEIXADOS PARA HISTORICO.
*/


CREATE PROCEDURE [dbo].[PS_CaixaProjetado] (
	@dt DATE,
	@centrocusto VARCHAR(100),
	@valorprojetado MONEY,
	@chave VARCHAR(100), -- Codigo Usuario + DDMMYYYYHHMMSS
	@calculado BIT -- 1-Calculado, 0-Informado
)
AS BEGIN

		DELETE caixaprojetado
		WHERE chave = @chave

		DECLARE @result TABLE (
			cd_centro_custo INT )
		DECLARE @sql VARCHAR(500)
		DECLARE @dti DATE
		DECLARE @dtf DATE
		DECLARE @vlpagar MONEY
		DECLARE @vlreceber MONEY

		DECLARE @perc_recvista FLOAT
		DECLARE @perc_desprod FLOAT
		DECLARE @receitatotal MONEY
		DECLARE @vl_rateiovista MONEY
		DECLARE @vl_rateioproducao MONEY

		SET @dti = RIGHT('0' + CONVERT(VARCHAR(2), MONTH(@dt)), 2) + '/01/' + CONVERT(VARCHAR(4), YEAR(@dt))
		SET @dtf = DATEADD(MONTH, 1, @dti)

		-- Criar os Registros
		SET @dt = @dti
		WHILE @dt < @dtf
		BEGIN
			INSERT caixaprojetado ( chave,
			                        data,
			                        dia,
			                        dia_semana,
			                        vl_pagar,
			                        vl_receber,
			                        vl_recvista,
			                        vl_desvista,
			                        perc )
			VALUES ( @chave,
			         @dt,
			         CASE WHEN DATEPART(dw, @dt) = 1 THEN 0
					      ELSE dbo.fs_contadiasuteis(CONVERT(VARCHAR(10), @dti, 126), @dt, 0, 31) END,
			         DATEPART(dw, @dt),
			         0,
			         0,
			         0,
			         0,
			         0 )

			SET @dt = DATEADD(DAY, 1, @dt)
		END
		-- Filtrar Centro de Custos selecionado
		SET @sql = 'select cd_centro_custo from Centro_Custo '

		IF @centrocusto <> '' BEGIN
			SET @sql = @sql + ' where cd_centro_custo in (' + @centrocusto + ')'
		END

		INSERT INTO @result EXEC (@sql)

		-- Calcular o Pagar e receber
		DECLARE cursor_cxprojetado CURSOR FOR
		SELECT
        	CONVERT(VARCHAR(10), CASE WHEN T4.tipo_contalancamento = 1 THEN T4.data_pagamento
        			                  ELSE T4.data_documento END, 101) AS DT ,
        	SUM(CASE WHEN T2.codigo_conta LIKE '%0401'
        		OR T2.codigo_conta LIKE '%0704' THEN 0
        		     WHEN T1.tipo_conta = 1 THEN 0
        			 ELSE CASE WHEN T4.tipo_contalancamento = 1 THEN T4.valor_lancamento
        					   ELSE T4.valor_previsto END END) AS VALORPAGAR ,
        	SUM(CASE WHEN T4.forma_lancamento IN (6, 7) THEN 0 -- Dinheiro ou Debito
        		     WHEN T1.tipo_conta = 1 THEN CASE WHEN T4.tipo_contalancamento = 1 THEN T4.valor_lancamento
        					                          ELSE T4.valor_previsto END
        			 ELSE 0 END) AS VALORRECEBER
        --FROM tb_contamae T1,
        --	tb_conta T2,
        --	tb_lancamento T3,
        --	tb_formalancamento T4,
        --	tb_historicomovimentacao T5,
        --	tb_movimentacaofinanceira T6
        --WHERE T1.sequencial_contamae = T2.sequencial_contamae
        --AND T2.conta_valida = 1
        --AND T2.sequencial_conta = T3.sequencial_conta
        --AND T3.data_horaexclusao IS NULL
        --AND T3.sequencial_lancamento = T4.sequencial_lancamento
        --AND T4.sequencial_historico = T5.sequencial_historico
        --AND T5.sequencial_movimentacao = T6.sequencial_movimentacao
        --AND T6.cd_centro_custo IN (SELECT
        --                           	cd_centro_custo
        --                           FROM @result)
        --AND ( ( T4.tipo_contalancamento = 1
        --AND T4.data_pagamento >= @dti
        --AND T4.data_pagamento < @dtf )
        --OR ( T4.tipo_contalancamento = 2
        --AND T4.data_documento >= @dti
        --AND T4.data_documento < @dtf ) )
        --GROUP BY CONVERT(VARCHAR(10), CASE WHEN T4.tipo_contalancamento = 1 THEN T4.data_pagamento
        --		                           ELSE T4.data_documento END, 101)

        FROM TB_ContaMae AS T1
        	INNER JOIN TB_Conta AS T2 ON T1.Sequencial_ContaMae = T2.Sequencial_ContaMae
        	INNER JOIN TB_Lancamento AS T3 ON T2.Sequencial_Conta = T3.Sequencial_Conta
        	INNER JOIN TB_FormaLancamento AS T4 ON T3.Sequencial_Lancamento = T4.Sequencial_Lancamento
        	INNER JOIN TB_HistoricoMovimentacao AS T5 ON T4.Sequencial_Historico = T5.Sequencial_Historico
        	INNER JOIN TB_MovimentacaoFinanceira AS T6 ON T5.Sequencial_Movimentacao = T6.Sequencial_Movimentacao
        WHERE (T2.Conta_Valida = 1)
        AND (T3.Data_HoraExclusao IS NULL)
        AND T6.cd_centro_custo IN (SELECT
                                   	cd_centro_custo
                                   FROM @result)
        AND ( ( T4.tipo_contalancamento = 1
        AND T4.data_pagamento >= @dti
        AND T4.data_pagamento < @dtf )
        OR ( T4.tipo_contalancamento = 2
        AND T4.data_documento >= @dti
        AND T4.data_documento < @dtf ) )
        GROUP BY CONVERT(VARCHAR(10),
        CASE    WHEN T4.tipo_contalancamento = 1 THEN T4.data_pagamento
        		ELSE T4.data_documento END, 101)
        ORDER BY DT

		OPEN cursor_cxprojetado
		FETCH NEXT FROM cursor_cxprojetado INTO @dt, @vlpagar, @vlreceber
		WHILE (@@fetch_status <> -1)
		BEGIN

			IF DATEPART(dw, @dt) = 7
			AND DATEADD(DAY, 1, @dt) <> @dtf SET @dt = DATEADD(DAY, 1, @dt)

			IF DATEPART(dw, @dt) = 1
			AND DATEADD(DAY, 1, @dt) <> @dtf SET @dt = DATEADD(DAY, 1, @dt)

			UPDATE caixaprojetado SET vl_pagar = vl_pagar + @vlpagar ,
					vl_receber = vl_receber + @vlreceber
			WHERE chave = @chave
			AND data = @dt

			FETCH NEXT FROM cursor_cxprojetado INTO @dt, @vlpagar, @vlreceber
		END
		CLOSE cursor_cxprojetado
		DEALLOCATE cursor_cxprojetado

		-- Recuperar o valor total e o % a Vista e Prod
		SELECT
        	@receitatotal = ISNULL(SUM(ISNULL(vl_acumulado, 0)), 0)
        FROM configuracao_fluxoprojetado
        WHERE cd_centro_custo IN (SELECT
                                  	cd_centro_custo
                                  FROM @result)
		SELECT
        	@perc_recvista = ROUND((SUM(ISNULL(vl_receitavista, 0)) / @receitatotal) * 100, 2) ,
        	@perc_desprod = ROUND((SUM(ISNULL(vl_despesaprodutividade, 0)) / @receitatotal) * 100, 2)
        FROM centro_custo AS C
        WHERE C.cd_centro_custo IN (SELECT
                                    	cd_centro_custo
                                    FROM @result)
		SELECT
        	@vl_rateiovista = ROUND((@valorprojetado / 100) * @perc_recvista, 2) ,
        	@vl_rateioproducao = ROUND((@valorprojetado / 100) * @perc_desprod, 2)
		PRINT @vl_rateiovista
		PRINT @vl_rateioproducao

		-- Encontra os % de recebimento diario
		UPDATE caixaprojetado SET perc = ROUND((vl_dia / @receitatotal) * 100, 2)
		FROM (SELECT
              	dia ,
              	SUM(ISNULL(vl_acumulado, 0)) AS VL_DIA
              FROM configuracao_fluxoprojetado
              WHERE cd_centro_custo IN (SELECT
                                        	cd_centro_custo
                                        FROM @result)
              GROUP BY dia) AS X
		WHERE chave = @chave
		AND caixaprojetado.dia = X.dia
		AND caixaprojetado.dia > 0

		UPDATE caixaprojetado SET perc = ROUND(perc + (100 - (SELECT
                                                              	SUM(perc) AS TOTAL
                                                              FROM caixaprojetado
                                                              WHERE chave = @chave)), 2)
		WHERE chave = @chave
		AND dia = 25

		-- Calculo do valor do recebimento a vista e pagamento de produtividade
		UPDATE caixaprojetado SET vl_recvista = ROUND((@vl_rateiovista / 100) * perc, 2) ,
				vl_desvista = ROUND((@vl_rateioproducao / 100) * perc, 2)
		WHERE chave = @chave
		AND dia > 0

		-- Se o Dia Atual > Inicio do Calculo calcular a rec e desp a vista pelo caixa
		UPDATE caixaprojetado SET vl_recvista = valorrecebido ,
				vl_desvista = valorpago
		FROM (SELECT
              	CONVERT(VARCHAR(10), T4.data_pagamento, 101) AS DT ,
              	SUM(CASE WHEN T2.codigo_conta LIKE '%0401'
              		OR T2.codigo_conta LIKE '%0704' THEN
              			--case when t1.tipo_conta=1 then 0 else T4.Valor_Lancamento End
              			CASE    WHEN T1.tipo_conta = 1 THEN 0
              					ELSE CASE WHEN T4.tipo_contalancamento = 1 THEN T4.valor_lancamento
              							  ELSE T4.valor_previsto END END
              			 ELSE 0 END) AS VALORPAGO ,
              	SUM(CASE WHEN T4.forma_lancamento NOT IN (6, 7) THEN 0 -- Dinheiro ou Debito
              		     WHEN T1.tipo_conta = 1 THEN CASE WHEN T4.tipo_contalancamento = 1 THEN T4.valor_lancamento
              					                          ELSE T4.valor_previsto END
              			 ELSE 0 END) AS VALORRECEBIDO
              --FROM tb_contamae T1,
              --	tb_conta T2,
              --	tb_lancamento T3,
              --	tb_formalancamento T4,
              --	tb_historicomovimentacao T5,
              --	tb_movimentacaofinanceira T6
              --WHERE T1.sequencial_contamae = T2.sequencial_contamae
              --AND T2.conta_valida = 1
              --AND T2.sequencial_conta = T3.sequencial_conta
              --AND T3.data_horaexclusao IS NULL
              --AND T3.sequencial_lancamento = T4.sequencial_lancamento
              --AND T4.sequencial_historico = T5.sequencial_historico
              --AND T5.sequencial_movimentacao = T6.sequencial_movimentacao
              --AND T6.cd_centro_custo IN (SELECT
              --                           	cd_centro_custo
              --                           FROM @result)
              --AND ( ( T4.tipo_contalancamento = 1
              --AND T4.data_pagamento >= @dti
              --AND T4.data_pagamento < DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 101)) )
              --OR ( T4.tipo_contalancamento = 2
              --AND T4.data_documento >= @dti
              --AND T4.data_documento < DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 101)) ) )


              FROM TB_ContaMae AS T1
              	INNER JOIN TB_Conta AS T2 ON T1.Sequencial_ContaMae = T2.Sequencial_ContaMae
              	INNER JOIN TB_Lancamento AS T3 ON T2.Sequencial_Conta = T3.Sequencial_Conta
              	INNER JOIN TB_FormaLancamento AS T4 ON T3.Sequencial_Lancamento = T4.Sequencial_Lancamento
              	INNER JOIN TB_HistoricoMovimentacao AS T5 ON T4.Sequencial_Historico = T5.Sequencial_Historico
              	INNER JOIN TB_MovimentacaoFinanceira AS T6 ON T5.Sequencial_Movimentacao = T6.Sequencial_Movimentacao
              WHERE (T2.Conta_Valida = 1)
              AND (T3.Data_HoraExclusao IS NULL)
              AND T6.cd_centro_custo IN (SELECT
                                         	cd_centro_custo
                                         FROM @result)
              AND ( ( T4.tipo_contalancamento = 1
              AND T4.data_pagamento >= @dti
              AND T4.data_pagamento < DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 101)) )
              OR ( T4.tipo_contalancamento = 2
              AND T4.data_documento >= @dti
              AND T4.data_documento < DATEADD(DAY, -1, CONVERT(VARCHAR(10), GETDATE(), 101)) ) )

              GROUP BY CONVERT(VARCHAR(10), T4.data_pagamento, 101)) AS X
		WHERE chave = @chave
		AND data = X.DT

	END
