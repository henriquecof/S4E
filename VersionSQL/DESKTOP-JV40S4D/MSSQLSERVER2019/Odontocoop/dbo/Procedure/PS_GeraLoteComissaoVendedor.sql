/****** Object:  Procedure [dbo].[PS_GeraLoteComissaoVendedor]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Data e Hora.: 2022-05-24 16:13:04
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
QUERYS ANTIGAS MANTIDAS NO CÓDIGO PARA HISTORICO.
*/


CREATE PROCEDURE [dbo].[PS_GeraLoteComissaoVendedor] (
	@CD_Funcionario INT,
	@Tipo SMALLINT = NULL,
	@dt1 DATETIME = NULL,
	@dt2 DATETIME = NULL
)
AS BEGIN

		-- @Tipo = 1 Comissao , 2 = Vitalicio , 3 = Ambas

		DECLARE @fl_baixa_adesao_aut INT = -100
		SELECT
        	@fl_baixa_adesao_aut = ISNULL(fl_baixaadesao_automatico , -100)
        FROM FUNCIONARIO
        WHERE cd_funcionario = @CD_Funcionario

		--declaração de variaveis--------------------------------------------------------------------------
		DECLARE @cd_sequencial_dependente INT
		DECLARE @cd_parcela_comissao INT
		DECLARE @valor MONEY
		DECLARE @perc_pagamento MONEY
		DECLARE @cd_sequencial INT
		DECLARE @NumeroParcela INT
		DECLARE @sequencialmensalidade INT
		DECLARE @quantidadeparcelapaga INT
		DECLARE @usuario_inclusao INT
		DECLARE @gerar_lote SMALLINT
		DECLARE @sequencial_lote_comissao INT
		DECLARE @vl_parcela MONEY
		DECLARE @cd_tipo_recebimento INT

		DECLARE @dt_base_ini DATETIME = @dt1
		DECLARE @dt_base DATETIME = @dt2

		IF @dt_base_ini IS NULL BEGIN
			SET @dt_base_ini = DATEADD(MONTH , -1 , GETDATE())
			SET @dt_base_ini = RIGHT('0' + CONVERT(VARCHAR(2) , MONTH(@dt_base_ini)) , 2) + '/01/' + CONVERT(VARCHAR(4) , YEAR(@dt_base_ini))
		END

		IF @dt_base IS NULL BEGIN
			SET @dt_base = DATEADD(DAY , -1 , DATEADD(MONTH , 1 , @dt_base_ini)) -- Ultimo dia do mes anterior
		END

		SET @dt_base = CONVERT(VARCHAR(10) , @dt_base , 101) + ' 23:59'

		-- usuario inclusao --------------------------------------------------------------------------------
		SELECT
        	@usuario_inclusao = cd_funcionario
        FROM Processos
        WHERE cd_processo = 2

		SET @gerar_lote = 0
		--  saber se tem algum  lote de comissão aberto para o vendedor.
		SET @sequencial_lote_comissao = 0

		-- Lote = 0
		-- Cancela os lotes de comissao de Empresas
		UPDATE comissao_vendedor SET cd_sequencial_lote = NULL ,
				dt_exclusao = GETDATE()
		WHERE cd_sequencial_lote = @sequencial_lote_comissao
		AND cd_empresa IS NOT NULL

		UPDATE comissao_vendedor -- Limpa os registros do Lote para iniciar o processo
			SET cd_sequencial_lote = NULL ,
				cd_sequencial_mensalidade_planos = NULL
		WHERE cd_sequencial_lote = @sequencial_lote_comissao

		IF ISNULL(@Tipo , 3) = 3 SELECT
                                 	@sequencial_lote_comissao = ISNULL(MAX(cd_sequencial) , 0)
                                 FROM lote_comissao
                                 WHERE cd_funcionario = @CD_Funcionario
                                 AND dt_finalizado IS NULL ELSE
		SELECT
        	@sequencial_lote_comissao = ISNULL(MAX(cd_sequencial) , 0)
        FROM lote_comissao
        WHERE cd_funcionario = @CD_Funcionario
        AND dt_finalizado IS NULL
        AND cd_tipo = @Tipo

		IF @sequencial_lote_comissao > 0 BEGIN
			SELECT
            	@dt_base = CASE WHEN dt_base_fim IS NULL THEN @dt_base
            			        ELSE dt_base_fim END , -- Busca a data de fim
            	@dt_base_ini = CASE WHEN dt_base_ini IS NULL THEN @dt_base_ini
            			            ELSE dt_base_ini END
            FROM lote_comissao
            WHERE cd_sequencial = @sequencial_lote_comissao

			SET @gerar_lote = 1 -- Nao precisa gerar lote

			-- Cancela os lotes de comissao de Empresas
			UPDATE comissao_vendedor SET dt_exclusao = GETDATE() ,
					cd_sequencial_lote = NULL
			WHERE cd_sequencial_lote = @sequencial_lote_comissao
			AND cd_empresa IS NOT NULL

			UPDATE comissao_vendedor -- Limpa os registros do Lote para iniciar o processo
				SET cd_sequencial_lote = NULL ,
					cd_sequencial_mensalidade_planos = NULL
			WHERE cd_sequencial_lote = @sequencial_lote_comissao

		END

		UPDATE comissao_vendedor -- Limpa os registros do Lote para iniciar o processo
			SET cd_sequencial_mensalidade_planos = NULL
		WHERE cd_funcionario = @CD_Funcionario
		AND cd_sequencial_mensalidade_planos IS NOT NULL
		AND cd_sequencial_lote IS NULL

		-- Se tiver parcelas = 0 colocar logo no lote
		SET @cd_sequencial = 0
		SELECT
        	@cd_sequencial = COUNT(0)
        FROM comissao_vendedor
        WHERE cd_funcionario = @CD_Funcionario
        AND cd_sequencial_mensalidade_planos IS NULL
        AND cd_sequencial_lote IS NULL
        AND dt_exclusao IS NULL
        AND cd_sequencial_dependente IS NOT NULL
        AND fl_vitalicio IS NULL
        AND -- Nao ser vitalicio
        cd_parcela_comissao < 0
        AND valor > 0

		IF ISNULL(@cd_sequencial , 0) > 0 BEGIN

			IF @gerar_lote = 0 BEGIN

				SET @gerar_lote = 1

				IF @sequencial_lote_comissao = 0 BEGIN
					INSERT INTO lote_comissao ( dt_cadastro,
					                            dt_finalizado,
					                            qt_comissoes,
					                            cd_usuario_cadastro,
					                            vl_total,
					                            cd_funcionario,
					                            dt_lancamento,
					                            cd_sequencial_caixa,
					                            dt_base_fim,
					                            dt_base_ini )
					VALUES ( CONVERT(VARCHAR(10) , GETDATE() , 101),
					         NULL,
					         NULL,
					         @usuario_inclusao,
					         NULL,
					         @CD_Funcionario,
					         NULL,
					         NULL,
					         @dt_base,
					         @dt_base_ini )

					SELECT
                    	@sequencial_lote_comissao = MAX(cd_sequencial)
                    FROM lote_comissao
                    WHERE cd_funcionario = @CD_Funcionario
				END

			END

			UPDATE comissao_vendedor SET cd_sequencial_lote = @sequencial_lote_comissao
			WHERE cd_funcionario = @CD_Funcionario
			AND cd_sequencial_mensalidade_planos IS NULL
			AND cd_sequencial_lote IS NULL
			AND dt_exclusao IS NULL
			AND cd_sequencial_dependente IS NOT NULL
			AND fl_vitalicio IS NULL
			AND -- Nao ser vitalicio
			cd_parcela_comissao < 0
			AND valor > 0

		END

		--Todos as parcelas em aberto de comissão desse vendedor ----------------------------------------------
		IF ISNULL(@Tipo , 3) = 3 -- Comissao + Vitalicio
		BEGIN
			DECLARE cursor_lote_pro CURSOR
			FOR SELECT
                	cd_sequencial ,
                	cd_sequencial_dependente ,
                	cd_parcela_comissao ,
                	valor ,
                	perc_pagamento
                FROM comissao_vendedor
                WHERE cd_funcionario = @CD_Funcionario
                AND cd_sequencial_mensalidade_planos IS NULL
                AND cd_sequencial_lote IS NULL
                AND dt_exclusao IS NULL
                AND cd_sequencial_dependente IS NOT NULL
                AND fl_vitalicio IS NULL -- Nao ser vitalicio
                ORDER BY cd_sequencial_dependente,
                         cd_parcela_comissao
		END

		IF ISNULL(@Tipo , 3) = 1 -- Comissao
		BEGIN
			DECLARE cursor_lote_pro CURSOR
			FOR SELECT
                	cd_sequencial ,
                	cd_sequencial_dependente ,
                	cd_parcela_comissao ,
                	valor ,
                	perc_pagamento
                FROM comissao_vendedor
                WHERE cd_funcionario = @CD_Funcionario
                AND cd_sequencial_mensalidade_planos IS NULL
                AND cd_sequencial_lote IS NULL
                AND dt_exclusao IS NULL
                AND cd_sequencial_dependente IS NOT NULL
                AND fl_vitalicio IS NULL
                AND -- Nao ser vitalicio
                cd_sequencial_origem IS NULL
                ORDER BY cd_sequencial_dependente,
                         cd_parcela_comissao
		END

		IF ISNULL(@Tipo , 3) = 2 -- Vitalicio
		BEGIN
			DECLARE cursor_lote_pro CURSOR
			FOR SELECT
                	cd_sequencial ,
                	cd_sequencial_dependente ,
                	cd_parcela_comissao ,
                	valor ,
                	perc_pagamento
                FROM comissao_vendedor
                WHERE cd_funcionario = @CD_Funcionario
                AND cd_sequencial_mensalidade_planos IS NULL
                AND cd_sequencial_lote IS NULL
                AND dt_exclusao IS NULL
                AND cd_sequencial_dependente IS NOT NULL
                AND fl_vitalicio IS NULL
                AND -- Nao ser vitalicio
                cd_sequencial_origem IS NOT NULL
                ORDER BY cd_sequencial_dependente,
                         cd_parcela_comissao
		END

		OPEN cursor_lote_pro
		FETCH NEXT FROM cursor_lote_pro
		INTO @cd_sequencial , @cd_sequencial_dependente , @cd_parcela_comissao , @valor ,
		@perc_pagamento

		WHILE (@@FETCH_STATUS <> -1)
		BEGIN

			PRINT @cd_sequencial_dependente

			--numero da parcela
			SET @NumeroParcela = 1

			--Saber se essa mensalidade foi paga.
			DECLARE cursor_mensalidade_pro CURSOR FOR
			--SELECT
			--         	t2.cd_sequencial ,
			--         	t2.valor ,
			--         	CASE    WHEN t1.cd_tipo_parcela = 2
			--         		OR t2.cd_tipo_parcela = 2 THEN 0
			--         			ELSE dbo.FF_Parcela(@cd_sequencial_dependente , t1.cd_parcela , t1.DT_VENCIMENTO , t2.cd_sequencial) END ,
			--         	t1.CD_TIPO_RECEBIMENTO
			--         FROM MENSALIDADES t1,
			--         	Mensalidades_Planos t2
			--         WHERE t1.DT_PAGAMENTO <= @dt_base
			--         AND t1.DT_PAGAMENTO >= @dt_base_ini
			--         AND
			--         --t1.tp_associado_empresa = 1         And
			--         t1.CD_TIPO_RECEBIMENTO > 2
			--         AND t1.cd_tipo_parcela IN (1 , 2)
			--         AND ISNULL(t2.cd_tipo_parcela , 1) IN (1 , 2)
			--         AND t1.cd_parcela = t2.cd_parcela_mensalidade
			--         AND t2.cd_sequencial_dep = @cd_sequencial_dependente
			--         AND t2.dt_exclusao IS NULL
			--         AND t2.cd_sequencial NOT IN (
			--         SELECT
			--         	cd_sequencial_mensalidade_planos
			--         FROM comissao_vendedor t100
			--         WHERE cd_sequencial_mensalidade_planos IS NOT NULL
			--         AND t100.cd_sequencial_dependente = t2.cd_sequencial_dep
			--         AND t100.cd_funcionario = @CD_Funcionario )
			--         ORDER BY 1

			SELECT
            	t2.cd_sequencial ,
            	t2.valor ,
            	CASE    WHEN t1.cd_tipo_parcela = 2
            		OR t2.cd_tipo_parcela = 2 THEN 0
            			ELSE dbo.FF_Parcela(@cd_sequencial_dependente, t1.cd_parcela, t1.DT_VENCIMENTO, t2.cd_sequencial) END AS Expr1 ,
            	t1.CD_TIPO_RECEBIMENTO
            FROM MENSALIDADES AS t1
            	INNER JOIN Mensalidades_Planos AS t2 ON t1.CD_PARCELA = t2.cd_parcela_mensalidade
            WHERE (t1.DT_PAGAMENTO <= @dt_base)
            AND (t1.DT_PAGAMENTO >= @dt_base_ini)
            AND (t1.CD_TIPO_RECEBIMENTO > 2)
            AND (t1.cd_tipo_parcela IN (1, 2))
            AND (ISNULL(t2.cd_tipo_parcela, 1) IN (1, 2))
            AND (t2.cd_sequencial_dep = @cd_sequencial_dependente)
            AND (t2.dt_exclusao IS NULL)
            AND (t2.cd_sequencial NOT IN
            (SELECT
             	cd_sequencial_mensalidade_planos
             FROM comissao_vendedor AS t100
             WHERE (cd_sequencial_mensalidade_planos IS NOT NULL)
             AND (cd_sequencial_dependente = t2.cd_sequencial_dep)
             AND (cd_funcionario = @CD_Funcionario)))
            ORDER BY t2.cd_sequencial

			OPEN cursor_mensalidade_pro
			FETCH NEXT FROM cursor_mensalidade_pro INTO
			@sequencialmensalidade , @vl_parcela , @quantidadeparcelapaga , @cd_tipo_recebimento

			WHILE (@@FETCH_STATUS <> -1)
			BEGIN
				--Saber se numero da parcela a ser paga como comissão já foi paga pelo associado.
				--vou comparar o numero da parcela com a quantidade de parcelas pagas.

				IF (@cd_parcela_comissao = @quantidadeparcelapaga) --And (@vl_parcela >= @valor)
				BEGIN

					--inclusao lote comissao
					IF @gerar_lote = 0 BEGIN

						SET @gerar_lote = 1

						IF @sequencial_lote_comissao = 0 BEGIN
							INSERT INTO lote_comissao ( dt_cadastro,
							                            dt_finalizado,
							                            qt_comissoes,
							                            cd_usuario_cadastro,
							                            vl_total,
							                            cd_funcionario,
							                            dt_lancamento,
							                            cd_sequencial_caixa,
							                            dt_base_fim,
							                            dt_base_ini,
							                            cd_tipo )
							VALUES ( CONVERT(VARCHAR(10) , GETDATE() , 101),
							         NULL,
							         NULL,
							         @usuario_inclusao,
							         NULL,
							         @CD_Funcionario,
							         NULL,
							         NULL,
							         @dt_base,
							         @dt_base_ini,
							         CASE WHEN ISNULL(@tipo , 3) = 3 THEN NULL
									      ELSE @Tipo END )

							SELECT
                            	@sequencial_lote_comissao = MAX(cd_sequencial)
                            FROM lote_comissao
                            WHERE cd_funcionario = @CD_Funcionario
						END

					END

					--incluindo comissao no lote
					UPDATE comissao_vendedor SET cd_sequencial_mensalidade_planos = @sequencialmensalidade ,
							cd_sequencial_lote = @sequencial_lote_comissao ,
							valor = @vl_parcela ,
							fl_vendedor_reteu = CASE WHEN @cd_tipo_recebimento = @fl_baixa_adesao_aut THEN 1
									                 ELSE fl_vendedor_reteu END
					WHERE cd_sequencial = @cd_sequencial
					AND cd_sequencial_mensalidade_planos IS NULL
					AND cd_sequencial_lote IS NULL
					AND dt_exclusao IS NULL

				END

				FETCH NEXT FROM cursor_mensalidade_pro INTO @sequencialmensalidade , @vl_parcela , @quantidadeparcelapaga , @cd_tipo_recebimento

			END
			CLOSE cursor_mensalidade_pro
			DEALLOCATE cursor_mensalidade_pro

			FETCH NEXT FROM cursor_lote_pro INTO @cd_sequencial , @cd_sequencial_dependente , @cd_parcela_comissao , @valor , @perc_pagamento

		END
		CLOSE cursor_lote_pro
		DEALLOCATE cursor_lote_pro


		DECLARE @cd_empresa INT
		DECLARE @cd_tipo_comissao INT
		DECLARE @cd_parcela INT
		DECLARE @dt_venc DATE
		DECLARE @qtde_vidas INT

		-- Criar as Comissoes Vitalicias (9) ou Vitalicio Dif (10) e Agenciamento (2)
		-- 1o: Verificar quem tem comissao vitalicia (9) ou Vitalicio Dif (10) vinculada a determinada empresa
		-- 2o: Verificar quem tem comissao vitalicia e Vitalicio Dif e nao esta identificado a empresa e verificar quais as suas empresas
		DECLARE cursor_lote_pro_emp CURSOR FOR
		--SELECT
		--      	c.cd_empresa ,
		--      	cd_parcela ,
		--      	perc_pagamento ,
		--      	cd_tipo_comissao
		--      FROM cm_vendedor AS c,
		--      	EMPRESA AS e,
		--      	Historico AS h,
		--      	SITUACAO_HISTORICO AS sh
		--      WHERE c.cd_empresa = e.cd_empresa
		--      AND -- c.cd_funcionario = e.cd_func_vendedor and
		--      e.CD_Sequencial_historico = h.cd_sequencial
		--      AND h.cd_situacao = sh.CD_SITUACAO_HISTORICO
		--      AND
		--      -- sh.fl_envia_cobranca=1 and
		--      c.cd_funcionario = @CD_Funcionario
		--      AND c.cd_empresa IS NOT NULL
		--      AND cd_tipo_comissao IN (CASE WHEN ISNULL(@tipo , 3) IN (2 , 3) THEN 9
		--      		                      ELSE 0 END ,
		--      CASE    WHEN ISNULL(@tipo , 3) IN (2 , 3) THEN 10
		--      		ELSE 0 END ,
		--      CASE    WHEN ISNULL(@tipo , 3) IN (1 , 3) THEN 2
		--      		ELSE 0 END
		--      )

		SELECT
        	c.cd_empresa ,
        	c.cd_parcela ,
        	c.perc_pagamento ,
        	c.cd_tipo_comissao
        FROM cm_vendedor AS c
        	INNER JOIN EMPRESA AS e ON c.cd_empresa = e.CD_EMPRESA
        	INNER JOIN HISTORICO AS h ON e.CD_Sequencial_historico = h.cd_sequencial
        	INNER JOIN SITUACAO_HISTORICO AS sh ON h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
        WHERE (c.cd_funcionario = @CD_Funcionario)
        AND (c.cd_empresa IS NOT NULL)
        AND (c.cd_tipo_comissao IN (CASE WHEN ISNULL(@tipo, 3) IN (2, 3) THEN 9
        		                         ELSE 0 END, CASE WHEN ISNULL(@tipo, 3) IN (2, 3) THEN 10
        		                                          ELSE 0 END,
        CASE    WHEN ISNULL(@tipo, 3) IN (1, 3) THEN 2
        		ELSE 0 END))

        UNION
        --SELECT
        --	e.cd_empresa ,
        --	cd_parcela ,
        --	perc_pagamento ,
        --	cd_tipo_comissao
        --FROM cm_vendedor AS c,
        --	EMPRESA AS e,
        --	Historico AS h,
        --	SITUACAO_HISTORICO AS sh
        --WHERE c.cd_funcionario = e.cd_func_vendedor
        --AND e.CD_Sequencial_historico = h.cd_sequencial
        --AND h.cd_situacao = sh.CD_SITUACAO_HISTORICO
        --AND
        ----  sh.fl_envia_cobranca=1 and
        --c.cd_funcionario = @CD_Funcionario
        --AND c.cd_empresa IS NULL
        --AND cd_tipo_comissao IN (CASE WHEN ISNULL(@tipo , 3) IN (2 , 3) THEN 9
        --		                      ELSE 0 END ,
        --CASE    WHEN ISNULL(@tipo , 3) IN (2 , 3) THEN 10
        --		ELSE 0 END ,
        --CASE    WHEN ISNULL(@tipo , 3) IN (1 , 3) THEN 2
        --		ELSE 0 END
        --)
        --AND e.cd_empresa NOT IN (SELECT
        --                         	cd_empresa
        --                         FROM cm_vendedor
        --                         WHERE cd_funcionario = @CD_Funcionario
        --                         AND cd_empresa IS NOT NULL
        --                         AND cd_tipo_comissao IN (9 , 10 , 2)
        --)
        --ORDER BY 1,
        --         2

        SELECT
        	e.CD_EMPRESA ,
        	c.cd_parcela ,
        	c.perc_pagamento ,
        	c.cd_tipo_comissao
        FROM cm_vendedor AS c
        	INNER JOIN EMPRESA AS e ON c.cd_funcionario = e.cd_func_vendedor
        	INNER JOIN HISTORICO AS h ON e.CD_Sequencial_historico = h.cd_sequencial
        	INNER JOIN SITUACAO_HISTORICO AS sh ON h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO
        WHERE (c.cd_funcionario = @CD_Funcionario)
        AND (c.cd_empresa IS NULL)
        AND (c.cd_tipo_comissao IN (CASE WHEN ISNULL(@tipo, 3) IN (2, 3) THEN 9
        		                         ELSE 0 END, CASE WHEN ISNULL(@tipo, 3) IN (2, 3) THEN 10
        		                                          ELSE 0 END,
        CASE    WHEN ISNULL(@tipo, 3) IN (1, 3) THEN 2
        		ELSE 0 END))
        AND (e.CD_EMPRESA NOT IN
        (SELECT
         	cd_empresa
         FROM cm_vendedor
         WHERE (cd_funcionario = @CD_Funcionario)
         AND (cd_empresa IS NOT NULL)
         AND (cd_tipo_comissao IN (9, 10, 2))))
		--ORDER BY e.CD_EMPRESA,
		--         c.cd_parcela

		OPEN cursor_lote_pro_emp
		FETCH NEXT FROM cursor_lote_pro_emp INTO @cd_empresa , @cd_parcela_comissao , @perc_pagamento , @cd_tipo_comissao

		WHILE (@@FETCH_STATUS <> -1)
		BEGIN

			--Quais as parcelas pagas nos ultimos 90 dias que nao estao na comissao do vendedor
			DECLARE cursor_mensalidade_emp CURSOR
			FOR SELECT
                	cd_parcela ,
                	DT_VENCIMENTO ,
                	CASE    WHEN cd_tipo_parcela = 2 THEN 0
                			ELSE dbo.FF_Parcela_Empresa(@cd_empresa , cd_parcela , DT_VENCIMENTO) END ,
                	CD_TIPO_RECEBIMENTO
                FROM MENSALIDADES
                WHERE CD_ASSOCIADO_empresa = @cd_empresa
                AND TP_ASSOCIADO_EMPRESA IN (2 , 3)
                AND cd_tipo_parcela IN (1 , 2)
                AND CD_TIPO_RECEBIMENTO > 2
                AND DT_PAGAMENTO >= @dt_base_ini --DATEADD(month,-3,@dt_base)
                AND DT_PAGAMENTO <= @dt_base
                AND cd_parcela NOT IN (SELECT
                                       	cd_parcela
                                       FROM comissao_vendedor
                                       WHERE cd_parcela IS NOT NULL
                                       AND cd_empresa = @cd_empresa
                                       AND dt_exclusao IS NULL
                                       AND cd_funcionario = @CD_Funcionario
                                       AND cd_sequencial_lote IS NOT NULL
                )
                ORDER BY DT_VENCIMENTO,
                         cd_parcela
			OPEN cursor_mensalidade_emp
			FETCH NEXT FROM cursor_mensalidade_emp INTO @cd_parcela , @dt_venc , @NumeroParcela , @cd_tipo_recebimento
			WHILE (@@FETCH_STATUS <> -1)
			BEGIN

				IF (@NumeroParcela = @cd_parcela_comissao)
				OR ( @NumeroParcela > @cd_parcela_comissao
				AND @cd_tipo_comissao IN (9 , 10) ) BEGIN

					-- Pegar o valor da parcela e qtde de vidas
					IF @cd_tipo_comissao = 10 -- Vitalicia DIF.. Vitalicia retirando que é o primeiro mes
					BEGIN
						SELECT
                        	@vl_parcela = SUM(valor) ,
                        	@qtde_vidas = COUNT(0)
                        FROM Mensalidades_Planos
                        WHERE cd_parcela_mensalidade = @cd_parcela
                        AND dt_exclusao IS NULL
                        AND cd_tipo_parcela IN (1 , 2 , 11)
                        AND cd_sequencial_dep IN (SELECT DISTINCT
                                                  	     cd_sequencial_dep
                                                  FROM MENSALIDADES AS m,
                                                  	Mensalidades_Planos AS mp,
                                                  	DEPENDENTES AS d
                                                  WHERE m.cd_parcela = mp.cd_parcela_mensalidade
                                                  AND mp.cd_sequencial_dep = d.cd_sequencial
                                                  AND m.cd_tipo_parcela = 1
                                                  AND m.CD_TIPO_RECEBIMENTO > 2
                                                  AND mp.dt_exclusao IS NULL
                                                  AND m.CD_ASSOCIADO_empresa = @cd_empresa
                                                  AND m.TP_ASSOCIADO_EMPRESA IN (2 , 3)
                                                  AND m.DT_VENCIMENTO < @dt_venc
                                                  AND m.DT_VENCIMENTO > d.dt_assinaturaContrato
                        )
					END ELSE
					BEGIN
						SELECT
                        	@vl_parcela = SUM(valor) ,
                        	@qtde_vidas = COUNT(0)
                        FROM Mensalidades_Planos
                        WHERE cd_parcela_mensalidade = @cd_parcela
                        AND dt_exclusao IS NULL
                        AND cd_tipo_parcela IN (1 , 2 , 11)
					END

					--inclusao lote comissao
					IF @gerar_lote = 0 BEGIN

						SET @gerar_lote = 1

						IF @sequencial_lote_comissao = 0 BEGIN
							INSERT INTO lote_comissao ( dt_cadastro,
							                            dt_finalizado,
							                            qt_comissoes,
							                            cd_usuario_cadastro,
							                            vl_total,
							                            cd_funcionario,
							                            dt_lancamento,
							                            cd_sequencial_caixa,
							                            dt_base_fim,
							                            dt_base_ini,
							                            cd_tipo )
							VALUES ( CONVERT(VARCHAR(10) , GETDATE() , 101),
							         NULL,
							         NULL,
							         @usuario_inclusao,
							         NULL,
							         @CD_Funcionario,
							         NULL,
							         NULL,
							         @dt_base,
							         @dt_base_ini,
							         CASE WHEN ISNULL(@tipo , 3) = 3 THEN NULL
									      ELSE @Tipo END )

							SELECT
                            	@sequencial_lote_comissao = MAX(cd_sequencial)
                            FROM lote_comissao
                            WHERE cd_funcionario = @CD_Funcionario
						END

					END

					-- Inserindo na Comissao Vendedor
					INSERT comissao_vendedor ( cd_parcela_comissao,
					                           cd_funcionario,
					                           valor,
					                           perc_pagamento,
					                           fl_vendedor_reteu,
					                           dt_inclusao,
					                           cd_sequencial_lote,
					                           cd_empresa,
					                           cd_parcela,
					                           nr_vidas )
					VALUES ( @NumeroParcela,
					         @CD_Funcionario,
					         @vl_parcela,
					         @perc_pagamento,
					         CASE WHEN @cd_tipo_recebimento = @fl_baixa_adesao_aut THEN 1
							      ELSE 0 END,
					         CONVERT(VARCHAR(10) , GETDATE() , 101),
					         @sequencial_lote_comissao,
					         @cd_empresa,
					         @cd_parcela,
					         @qtde_vidas )

				END

				FETCH NEXT FROM cursor_mensalidade_emp INTO @cd_parcela , @dt_venc , @NumeroParcela , @cd_tipo_recebimento
			END
			CLOSE cursor_mensalidade_emp
			DEALLOCATE cursor_mensalidade_emp

			FETCH NEXT FROM cursor_lote_pro_emp INTO @cd_empresa , @cd_parcela_comissao , @perc_pagamento , @cd_tipo_comissao
		END
		CLOSE cursor_lote_pro_emp
		DEALLOCATE cursor_lote_pro_emp

		EXEC [PS_AjustaLoteComissaoVendedorFromAcertoFuncionario]
			@sequencial_lote_comissao;


	END
