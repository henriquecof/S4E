/****** Object:  Procedure [dbo].[SP_GERA_MENSALIDADE]    Committed by VersionSQL https://www.versionsql.com ******/

/*
<alt>
alteração de teste 3
</alt>

*/


CREATE PROCEDURE [dbo].[SP_GERA_MENSALIDADE]
	@wl_venc datetime,
	@codigo_PK integer, -- Caso Empresa: Codigo da Empresa, Associado: Codigo do Associado
	@tp_empresa integer,
	@Sequencial_LogMensalidades integer = 0, -- Codigo Sequencial da Tabela de Log_Mensalidades, para informar se a mesma foi regerada
	@cd_parcela integer = 0, -- Codigo da Parcela para cancelar
	@acao integer = 1, -- Se nao for passado
	@qtdias integer = 0,
	@cd_funcionario integer = 0,
	@modificadoValorPlano smallint = 0, -- Quando for 1 se for passado a parcela e tiver reajuste no dia desprezar
	@tipoPagamento int = 0
AS BEGIN -- 1

		PRINT @tp_empresa
		PRINT 'chegou aqui'
		IF @tp_empresa >= 10
		OR @tp_empresa = 6 -- Empresa >= 10 Sao particulares e Convenios e nao faturados por essa rotina
		BEGIN -- 1.0.1
			RAISERROR('Tipo de Empresa deve ser inferior a 10 e não pode ser 6.',16,1)
			RETURN
		END -- 1.0.1

		-- **************************************
		-- Processo : 01 - Faturamento
		-- **************************************
		IF (@cd_funcionario = 0) BEGIN
			SELECT
            	@cd_funcionario = cd_funcionario
            FROM processos
            WHERE cd_processo = 1
		END

		IF @cd_funcionario IS NULL
		OR @cd_funcionario = 0 BEGIN -- 1.1
			RAISERROR('Funcionario de atualização do Processo não definido.',16,1)
			RETURN
		END -- 1.1

		IF @cd_parcela > 0
		AND @Sequencial_LogMensalidades > 0 -- Nao deixar passar o Log e a Parcela
		BEGIN -- 1.1
			RAISERROR('Só pode ser passado como parametro o Sequencial do Log ou o Codigo da Parcela.',16,1)
			RETURN
		END -- 1.1

		IF @cd_parcela > 0
		AND -- Conferir se esta na empresa certa
		(SELECT
         	count(0)
         FROM mensalidades
         WHERE cd_parcela = @cd_parcela
         AND cd_associado_empresa = @codigo_PK
         AND tp_Associado_empresa = (CASE WHEN @tp_empresa IN (2,7,8) THEN 2
         	                              WHEN @tp_empresa IN (6) THEN 3
         		                          ELSE 1 END))=0 BEGIN -- 1.2
			RAISERROR('Codigo da Parcela, Tipo Associado e Código não conferem.',16,1)
			RETURN
		END -- 1.2


		---- Verificar se esta vindo da rotina da rotina que recalcula as parcelas devido a ter sido modificado o valor do plano
		IF @cd_parcela > 0
		AND @tp_empresa NOT IN (2,6,7,8)
		AND @modificadoValorPlano = 1
		AND (SELECT
             	COUNT(0)
             FROM log_reajuste AS l
             	INNER JOIN DEPENDENTES AS d ON l.cd_sequencial_dep = d.CD_SEQUENCIAL
             WHERE d.CD_ASSOCIADO = @codigo_PK
             AND CONVERT(varchar(10),l.dt_reajuste,101) = CONVERT(varchar(10),getdate(),101))>0 BEGIN -- 1.2
			-- Raiserror('Mensalidade não pode ser regerado devido o reajuste.',16,1)
			RETURN
		END -- 1.2
		---------------------------------------------

		IF @Sequencial_LogMensalidades>0
		AND @cd_parcela = 0 -- Recupera o Codigo da Parcela
		SELECT
        	@cd_parcela = isnull(cd_parcela,0)
        FROM Log_Mensalidades
        WHERE cd_sequencial = @Sequencial_LogMensalidades ELSE
		BEGIN -- 1.3
			IF @Sequencial_LogMensalidades=0
			AND @cd_parcela>0 -- Recupera o Codigo da Parcela
			SELECT
            	@Sequencial_LogMensalidades = isnull(cd_sequencial,0)
            FROM Log_Mensalidades
            WHERE cd_parcela = @cd_parcela
            AND fl_regerado = 0
		END -- 1.3

		DECLARE @wl_acumula money
		DECLARE @vl_total money
		DECLARE @wl_cdparc integer
		DECLARE @Qtdeparcelas integer /* Testa se Mensalidades Existem */

		DECLARE @ajuste money
		DECLARE @wl_percretencao money
		DECLARE @wl_tpempresa integer
		DECLARE @cd_tipopagamento integer
		DECLARE @email varchar(100)
		DECLARE @grupo int
		DECLARE @fl_Online int
		DECLARE @cd_tipo_servico_bancario smallint

		DECLARE @cd_Ass integer
		DECLARE @cd_dep integer
		DECLARE @vl_plano money
		DECLARE @gera money
		DECLARE @vl_acrescimo money
		DECLARE @vl_desconto money

		DECLARE @vl_tit money
		DECLARE @vl_dep money
		DECLARE @vl_agregado money

		DECLARE @vl_dep1 money
		DECLARE @vl_dep2 money
		DECLARE @vl_dep3 money
		DECLARE @vl_dep4 money
		DECLARE @vl_dep5 money

		DECLARE @tipo_preco int -- 1 - Padrao , 2 - Qtde de Vidas
		DECLARE @ordem_cto smallint = 0

		DECLARE @fl_valor_fixo money
		DECLARE @cd_grau_parentesco int
		DECLARE @altera_dep bit
		DECLARE @dt_impresso datetime
		DECLARE @cd_plano int
		DECLARE @nr_parcela int
		DECLARE @fl_calcula_prorata smallint
		DECLARE @dia_inicio_cobertura date
		DECLARE @cd_tipo_parcela smallint
		DECLARE @fl_cobranca_registrada SMALLINT

		DECLARE @qt_parcelas_anual smallint
		DECLARE @enviaParcelaLoteEnvio tinyint = 0

		----- Variaveis Carne
		DECLARE @cd_tipopagamento_aux integer
		DECLARE @wl_venc_Aux datetime
		DECLARE @qt_parcelas_Gerar integer
		DECLARE @nr_parcela_anual int
		DECLARE @incremento_mes smallint

		DECLARE @dia_venc smallint -- 12/04
		DECLARE @fl_envia_email_fatautomatico smallint

		SELECT
        	@fl_envia_email_fatautomatico = isnull(fl_envia_email_fatautomatico,1)
        FROM configuracao

		BEGIN TRANSACTION
		PRINT @codigo_PK
		PRINT @wl_venc
		PRINT @tp_empresa
		PRINT 'chegou aqui 2'
		IF @tp_empresa IN (2,6,7,8) BEGIN -- 1.1
			DECLARE GERA_MENSALIDADE CURSOR FOR
			SELECT
            	CASE    WHEN fl_acrescimo IS NULL THEN 0
            		    WHEN fl_acrescimo = 1 THEN vl_ajuste
            			ELSE vl_ajuste*-1 END ,
            	isnull(percentual_retencao,0) ,
            	tp_empresa ,
            	cd_grupo ,
            	e.cd_tipo_pagamento ,
            	isnull(fl_online,0) ,
            	isnull(tp.cd_tipo_servico_bancario,0) ,
            	(SELECT TOP 1
                 	isnull(tustelefone,'')
                 FROM tb_contato AS t
                 WHERE t.ttesequencial=50
                 AND t.cd_origeminformacao=3
                 AND t.cd_sequencial = e.cd_empresa
                 AND t.fl_ativo=1) ,
            	CASE    WHEN (SELECT
                              	isnull(fl_calcula_prorata,0)
                              FROM Configuracao)=1
            		AND isnull(e.fl_prorata,0)=1 THEN 1
            			ELSE 0 END ,
            	CONVERT(varchar(2),month(@wl_venc)) + '/' +CONVERT(varchar(2),isnull(CASE WHEN month(@wl_venc)=2
            		AND dia_inicio_cobertura >28 THEN 28
            			                                                                  ELSE dia_inicio_cobertura END,1))+'/'+CONVERT(varchar(4),year(@wl_venc)) ,
            	isnull(e.cd_tipo_preco,1) ,
            	e.dt_vencimento ,
            	isnull(tp.fl_cobranca_registrada, 0) -- 12/04
            FROM empresa AS e,
            	historico AS h,
            	tipo_pagamento AS tp,
            	situacao_historico AS s
            WHERE e.cd_empresa = @codigo_PK
            AND e.cd_sequencial_historico = h.cd_sequencial
            AND e.cd_tipo_pagamento = tp.cd_tipo_pagamento
            AND h.cd_situacao = s.cd_situacao_historico
            AND s.fl_gera_cobranca=1
            AND e.tp_empresa IN (2,6,7,8)
		END -- 1.1
		ELSE
		BEGIN -- 1.2
			DECLARE GERA_MENSALIDADE CURSOR FOR
			SELECT
            	0 ,
            	0 ,
            	tp_empresa ,
            	NULL ,
            	e.cd_tipo_pagamento ,
            	CASE    WHEN (SELECT
                              	licencaS4e
                              FROM configuracao) IN ('QJSH717634HGSD981276SDSCVJHSD8721365SAAUS7A615002') THEN 0
            			ELSE isnull(fl_online,0) END , -- Online
            	isnull(tp.cd_tipo_servico_bancario,0) ,
            	(SELECT TOP 1
                 	isnull(tustelefone,'')
                 FROM tb_contato AS t
                 WHERE t.ttesequencial=50
                 AND t.cd_origeminformacao=1
                 AND t.cd_sequencial = a.cd_associado
                 AND t.fl_ativo=1) ,
            	CASE    WHEN (SELECT
                              	isnull(fl_calcula_prorata,0)
                              FROM Configuracao)=1
            		AND isnull(e.fl_prorata,0)=1 THEN 1
            			ELSE 0 END ,
            	@wl_venc ,
            	isnull(e.cd_tipo_preco,1) ,
            	e.dt_vencimento ,
            	isnull(tp.fl_cobranca_registrada, 0) -- 12/04
            FROM associados AS a,
            	dependentes AS d,
            	historico AS h /*Dependente */,
            	situacao_historico AS s,
            	empresa AS e,
            	tipo_pagamento AS tp
            WHERE a.cd_associado = @codigo_PK
            AND a.cd_empresa = e.cd_empresa
            AND e.cd_tipo_pagamento = tp.cd_tipo_pagamento
            AND a.cd_associado = d.cd_associado
            AND d.cd_sequencial_historico = h.cd_sequencial
            AND h.cd_situacao = s.cd_situacao_historico
            AND d.cd_grau_parentesco =1
            AND s.fl_gera_cobranca = 1
            AND e.tp_empresa = @tp_empresa
            AND d.mm_aaaa_1pagamento <= CONVERT(int,year(@wl_venc))*100 + CONVERT(int,month(@wl_venc))

		END -- 1.2
		OPEN GERA_MENSALIDADE
		FETCH NEXT FROM GERA_MENSALIDADE INTO @ajuste,@wl_percretencao, @wl_tpempresa, @grupo, @cd_tipopagamento, @fl_Online, @cd_tipo_servico_bancario, @email,@fl_calcula_prorata,@dia_inicio_cobertura,@tipo_preco,@dia_venc, @fl_cobranca_registrada
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN -- 2

			PRINT 'Inicio'

			IF @cd_parcela>0 -- Cancela a parcela para gerar novamente
			BEGIN -- 2.1
				UPDATE mensalidades SET cd_tipo_recebimento = 1 ,
						cd_usuario_alteracao = @cd_funcionario ,
						cd_usuario_baixa = @cd_funcionario ,
						dt_baixa = getdate()
				WHERE cd_parcela = @cd_parcela
				AND cd_tipo_recebimento=0
				IF @@Rowcount = 0 BEGIN -- 2.1.1
					CLOSE GERA_MENSALIDADE
					DEALLOCATE GERA_MENSALIDADE
					ROLLBACK TRANSACTION
					RAISERROR('Erro na exclusão da Mensalidade.',16,1)
					RETURN
				END -- 2.1.1
			END -- 2.1

			IF @Sequencial_LogMensalidades>0 BEGIN -- 2.2
				UPDATE Log_Mensalidades SET fl_regerado = 1
				WHERE cd_sequencial = @Sequencial_LogMensalidades
				AND fl_regerado = 0
				IF @@Rowcount = 0 BEGIN -- 2.2.1
					CLOSE GERA_MENSALIDADE
					DEALLOCATE GERA_MENSALIDADE
					ROLLBACK TRANSACTION
					RAISERROR('Erro na atualização do Log.',16,1)
					RETURN
				END -- 2.2.1
			END -- 2.2

			SELECT
            	@Qtdeparcelas = (SELECT
                                 	count(0)
                                 FROM mensalidades
                                 WHERE cd_associado_empresa = @codigo_PK
                                 AND tp_associado_empresa = (CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                                 	                              WHEN @wl_tpempresa IN (6) THEN 3
                                 		                          ELSE 1 END)
                                 AND month(dt_vencimento) = month(@wl_venc)
                                 AND year(dt_vencimento) = year(@wl_venc)
                                 AND cd_tipo_recebimento NOT IN (1)
                                 AND cd_tipo_parcela = 1)


			-- Verificar se foi Gerado a parcela da mae.
			IF @Qtdeparcelas = 0
			AND @grupo IS NOT NULL
			AND @wl_tpempresa = 2 BEGIN -- 2.3

				SELECT
                	@Qtdeparcelas = (SELECT
                                     	count(0)
                                     FROM mensalidades
                                     WHERE cd_associado_empresa IN (SELECT
                                                                    	cd_empresa
                                                                    FROM empresa
                                                                    WHERE cd_grupo = @grupo
                                                                    AND tp_empresa=6)
                                     AND tp_associado_empresa = 3
                                     AND month(dt_vencimento) = month(@wl_venc)
                                     AND year(dt_vencimento) = year(@wl_venc)
                                     AND cd_tipo_recebimento NOT IN (1)
                                     AND cd_tipo_parcela = 1)

			END -- 2.3

			IF @Qtdeparcelas = 0 BEGIN -- 3

				PRINT 'Gerar mensal'

				SET @nr_parcela = 0

				SELECT
                	@nr_parcela = COUNT(0) --- Saber qual a parcela do associado
                FROM MENSALIDADES
                WHERE CD_ASSOCIADO_empresa = @codigo_PK
                AND cd_tipo_parcela=1
                AND TP_ASSOCIADO_EMPRESA = CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                	                            WHEN @wl_tpempresa IN (6) THEN 3
                		                        ELSE 1 END
                AND CD_TIPO_RECEBIMENTO NOT IN (1)


				-- Configurar conforme Tipo Servico Bancario -- Para @acao = 0 or @tp_empresa in (2,6,7,8) or @Sequencial_LogMensalidades > 0 or @cd_parcela>0 sempre gerar apenas 1.
				SET @cd_tipopagamento_aux = @cd_tipopagamento
				SET @wl_venc_Aux = @wl_venc

				-- Select @qt_parcelas_Gerar = Case when @acao = 0 or @tp_empresa in (2,6,7,8) or @Sequencial_LogMensalidades > 0 or @cd_parcela>0 then @nr_parcela+1 when @nr_parcela <  isnull(qt_parcelas,1) then  isnull(qt_parcelas,1) else isnull(qt_parcelas_complementar,1)+@nr_parcela end  from tipo_servico_bancario where cd_tipo_servico_bancario=@cd_tipo_servico_bancario
				SELECT
                	@qt_parcelas_Gerar = CASE WHEN @acao = 0
                		OR @tp_empresa IN (2,6,7,8)
                		OR @Sequencial_LogMensalidades > 0
                		OR @cd_parcela>0 THEN @nr_parcela+1
                		                      WHEN ISNULL(fl_referencia,0) = 1 THEN @nr_parcela + dbo.FF_QtdeMesRenovacao(@codigo_PK,@wl_venc,fl_referencia) -- 12/04
                		                      WHEN @nr_parcela < isnull(qt_parcelas,1) THEN isnull(qt_parcelas,1)
                			                  ELSE isnull(qt_parcelas,1)+isnull(qt_parcelas_complementar,1) END
                FROM tipo_servico_bancario
                WHERE cd_tipo_servico_bancario=@cd_tipo_servico_bancario

				SELECT
                	@incremento_mes = isnull(qt_parcelas_complementar,1)
                FROM tipo_servico_bancario
                WHERE cd_tipo_servico_bancario=@cd_tipo_servico_bancario

				IF @qt_parcelas_Gerar IS NULL SET @qt_parcelas_Gerar = @nr_parcela+1

				WHILE @nr_parcela >= @qt_parcelas_Gerar
				BEGIN
					SET @qt_parcelas_Gerar = @qt_parcelas_Gerar + @incremento_mes
				END

				SET @incremento_mes = 0 -- Somar a qtde de mes para o caso de carne

				IF @wl_tpempresa IN (3) BEGIN
					SELECT
                    	@enviaParcelaLoteEnvio = isnull(a.enviaParcelaLoteEnvio,1)
                    FROM ASSOCIADOS a
                    WHERE a.cd_associado = @codigo_PK
				END ELSE
				BEGIN
					SET @enviaParcelaLoteEnvio = 1
				END

				WHILE @nr_parcela < @qt_parcelas_Gerar
				BEGIN -- Inicio do Laço para criar as mensalidades Boleto=1 ou Carnes=N

					SET @wl_venc = DATEADD(MONTH,@incremento_mes, @wl_venc_Aux)
					SET @incremento_mes = @incremento_mes + 1

					-- 12/04
					IF day(@wl_venc) IN (28,29)
					AND month(@wl_venc)<>2
					AND @dia_venc=30 BEGIN

						SELECT
                        	@wl_venc = CONVERT(date,CONVERT(varchar(2),month(@wl_venc)) + '/30/'+CONVERT(varchar(4),year(@wl_venc)),101)

					END
					-- 12/04

					SET @nr_parcela = @nr_parcela + 1
					SET @cd_tipopagamento = @cd_tipopagamento_aux

					SELECT
                    	@cd_tipopagamento = cd_tipo_pagamento_Destino
                    FROM Tipo_Pagamento_Auxiliar
                    WHERE cd_tipo_pagamento=@cd_tipopagamento
                    AND cd_parcela=@nr_parcela

					-- Se a parcela ja existe nao gerar novamente 12/04
					IF (SELECT
                        	count(0)
                        FROM mensalidades
                        WHERE cd_Associado_empresa = @codigo_PK
                        AND tp_associado_empresa = CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                        	                            WHEN @wl_tpempresa IN (6) THEN 3
                        		                        ELSE 1 END
                        AND CONVERT(varchar(6),dt_vencimento,112) = CONVERT(varchar(6),@wl_venc,112)
                        AND cd_tipo_parcela = 1
                        AND cd_tipo_recebimento NOT IN (1)
					) > 0 CONTINUE -- Ja existe a parcela
					-- Se a parcela ja existe nao gerar novamente

					/* Gera a parcela da Empresa ou Associado para descobrir o cd_parcela */
					INSERT mensalidades ( CD_ASSOCIADO_empresa,
					                      TP_ASSOCIADO_EMPRESA,
					                      cd_tipo_parcela,
					                      CD_TIPO_PAGAMENTO,
					                      CD_TIPO_RECEBIMENTO,
					                      DT_VENCIMENTO,
					                      DT_GERADO,
					                      vl_parcela,
					                      cd_usuario_cadastro,
					                      cd_lote_processo_banco )
					VALUES ( @codigo_PK,
					         (CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
						           WHEN @wl_tpempresa IN (6) THEN 3
							       ELSE 1 END),
					         1,
					         @cd_tipopagamento,
					         0,
					         @wl_venc,
					         isnull((SELECT
                                     	DT_GERADO
                                     FROM mensalidades
                                     WHERE cd_parcela = @cd_parcela),GETDATE()),
					         0,
					         @cd_funcionario,
					         CASE WHEN @enviaParcelaLoteEnvio > 0 THEN NULL
							      ELSE 0 END )
					IF @@Rowcount = 0 BEGIN -- 5
						CLOSE GERA_MENSALIDADE
						DEALLOCATE GERA_MENSALIDADE
						ROLLBACK TRANSACTION
						INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
						                          TP_ASSOCIADO_EMPRESA,
						                          CD_TIPO_PAGAMENTO,
						                          dt_gerado,
						                          DT_VENCIMENTO,
						                          cd_statusLog,
						                          obs )
						VALUES ( @codigo_PK,
						         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
							          WHEN @wl_tpempresa IN (6) THEN 3
								      ELSE 1 END,
						         @cd_tipopagamento,
						         getdate(),
						         @wl_venc,
						         0,
						         'Erro na Geração do Header da fatura.' )
						RETURN
					END -- 5

					SELECT
                    	@wl_cdparc = max(CD_PARCELA)
                    FROM mensalidades
                    WHERE cd_associado_empresa = @codigo_PK
                    AND cd_tipo_parcela = 1
                    AND DT_VENCIMENTO = @wl_venc
                    AND cd_tipo_recebimento = 0
                    AND TP_ASSOCIADO_EMPRESA = (CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                    	                             WHEN @wl_tpempresa IN (6) THEN 3
                    		                         ELSE 1 END)

					SELECT
                    	@wl_acumula = 0
					IF @tp_empresa IN (2,6,7,8) BEGIN
						DECLARE GERA_MENSALIDADE_2 CURSOR FOR
						SELECT
                        	a.cd_Associado ,
                        	d.cd_sequencial ,
                        	vl_plano ,
                        	(SELECT TOP 1
                             	s2.fl_gera_cobranca
                             FROM dependentes AS d2,
                             	historico AS h2 /*Dependente Titular*/,
                             	situacao_historico AS s2
                             WHERE a.cd_associado = d2.cd_associado
                             AND d2.cd_grau_parentesco =1
                             AND d2.cd_sequencial_historico = h2.cd_sequencial
                             AND h2.cd_situacao = s2.cd_situacao_historico) ,
                        	isnull(vl_tit,0) ,
                        	isnull(CASE WHEN p.cd_tipo_plano=2
                        		AND g.fl_semvalor_fam = 1 THEN 0 -- Fam
                        		        WHEN p.cd_tipo_plano=3
                        		AND g.fl_semvalor_cas = 1 THEN 0 -- Cas
                        			    ELSE vl_dep END,0) AS vl_dep ,
                        	isnull(CASE WHEN p.cd_tipo_plano=2
                        		AND g.fl_semvalor_fam = 1 THEN 0 -- Fam
                        		        WHEN p.cd_tipo_plano=3
                        		AND g.fl_semvalor_cas = 1 THEN 0 -- Cas
                        			    ELSE vl_agregado END,0) AS vl_agregado ,
                        	isnull(fl_valor_fixo,0) ,
                        	d.cd_grau_parentesco ,
                        	d.cd_plano ,
                        	0 ,
                        	isnull(pp.Vl_dep1,0) ,
                        	isnull(pp.Vl_dep2,0) ,
                        	isnull(pp.Vl_dep3,0) ,
                        	isnull(pp.Vl_dep4,0) ,
                        	isnull(pp.Vl_dep5,0)
                        --  from associados as a, dependentes as d, historico as h /*Dependente */,
                        --	   situacao_historico as s , preco_plano as pp , planos as p, grau_parentesco as g
                        -- where a.cd_empresa = @codigo_PK and
                        --	   a.cd_associado = d.cd_associado and
                        --	   d.cd_sequencial_historico = h.cd_sequencial and
                        --	   d.cd_grau_parentesco = g.cd_grau_parentesco and
                        --	   h.cd_situacao = s.cd_situacao_historico and
                        --	   d.cd_plano *= pp.cd_plano and a.cd_empresa *= pp.cd_empresa and pp.fl_inativo is null and
                        --	   d.cd_plano = p.cd_plano and p.fl_cortesia = 0 and
                        --	   s.fl_gera_cobranca = 1 and
                        --	   d.mm_aaaa_1pagamento <= convert(int,year(@wl_venc ))*100 + convert(int,month(@wl_venc))
                        --order by a.cd_Associado, case when d.CD_GRAU_PARENTESCO=1 then 1 else 2 end , d.CD_SEQUENCIAL

                        FROM ASSOCIADOS AS a
                        	INNER JOIN DEPENDENTES AS d ON a.cd_associado = d.CD_ASSOCIADO
                        	INNER JOIN HISTORICO AS h ON d.CD_Sequencial_historico = h.cd_sequencial
                        	INNER JOIN GRAU_PARENTESCO AS g ON d.CD_GRAU_PARENTESCO = g.cd_grau_parentesco
                        	INNER JOIN SITUACAO_HISTORICO AS s ON h.CD_SITUACAO = s.CD_SITUACAO_HISTORICO
                        	LEFT OUTER JOIN preco_plano AS pp ON d.cd_plano = pp.cd_plano
                        		AND a.cd_empresa = pp.cd_empresa
                        	INNER JOIN PLANOS AS p ON d.cd_plano = p.cd_plano
                        WHERE (a.cd_empresa = @codigo_PK)
                        AND (pp.fl_inativo IS NULL)
                        AND (p.fl_cortesia = 0)
                        AND (s.fl_gera_cobranca = 1)
                        AND (d.mm_aaaa_1pagamento <= CONVERT(int, YEAR(@wl_venc)) * 100 + CONVERT(int, MONTH(@wl_venc)))
                        ORDER BY a.cd_associado,
                                 CASE WHEN d .CD_GRAU_PARENTESCO = 1 THEN 1
                        		      ELSE 2 END,
                                 d.CD_SEQUENCIAL

					END ELSE
					BEGIN
						DECLARE GERA_MENSALIDADE_2 CURSOR FOR
						SELECT
                        	a.cd_Associado ,
                        	d.cd_sequencial ,
                        	vl_plano ,
                        	1 ,
                        	0 ,
                        	0 ,
                        	0 ,
                        	0 ,
                        	cd_grau_parentesco ,
                        	d.cd_plano ,
                        	pp.qt_parcelas_anual ,
                        	isnull(pp.Vl_dep1,0) ,
                        	isnull(pp.Vl_dep2,0) ,
                        	isnull(pp.Vl_dep3,0) ,
                        	isnull(pp.Vl_dep4,0) ,
                        	isnull( pp.Vl_dep5,0)
                        FROM associados AS a
                        	INNER JOIN dependentes AS d ON a.cd_associado = d.cd_associado
                        	INNER JOIN historico AS h /*Dependente */ ON d.cd_sequencial_historico = h.cd_sequencial
                        	INNER JOIN situacao_historico AS s ON h.cd_situacao = s.cd_situacao_historico
                        	INNER JOIN planos AS p ON d.cd_plano = p.cd_plano
                        	LEFT JOIN preco_plano AS pp ON a.cd_empresa = pp.cd_empresa
                        		AND d.cd_plano = pp.cd_plano
                        		AND pp.fl_inativo IS NULL
                        WHERE a.cd_associado = @codigo_PK
                        AND p.fl_cortesia = 0
                        AND s.fl_gera_cobranca = 1
                        AND d.mm_aaaa_1pagamento <= CONVERT(int,year(@wl_venc))*100 + CONVERT(int,month(@wl_venc))
                        ORDER BY a.cd_Associado,
                                 CASE WHEN d.CD_GRAU_PARENTESCO=1 THEN 1
                        		      ELSE 2 END,
                                 d.CD_SEQUENCIAL
					END
					OPEN GERA_MENSALIDADE_2 -- Valores dos Planos dos Usuarios
					FETCH NEXT FROM GERA_MENSALIDADE_2 INTO @cd_Ass, @cd_dep, @vl_plano, @gera, @vl_tit, @vl_dep, @vl_agregado, @fl_valor_fixo, @cd_grau_parentesco, @cd_plano,@qt_parcelas_anual,@vl_dep1,@vl_dep2,@vl_dep3,@vl_dep4,@vl_dep5
					WHILE (@@FETCH_STATUS <> -1)
					BEGIN -- 6

						PRINT @cd_Ass

						IF @gera = 1 -- Dependente esta em situacao fl_gera_cobranca = 1
						BEGIN -- 6.1

							IF @fl_valor_fixo=1 BEGIN -- 6.1.1

								IF @cd_grau_parentesco=1 BEGIN
									SET @ordem_cto = 0
								END ELSE
								BEGIN
									SET @ordem_cto = @ordem_cto + 1
								END

								SET @altera_dep=0

								IF @cd_grau_parentesco=1
								AND @vl_plano<>@vl_tit SELECT
                                                       	@vl_plano=@vl_tit ,
                                                       	@altera_dep=1

								-- Tipo Preco = 1 -- Padrao
								IF @tipo_preco = 1
								AND @cd_grau_parentesco>1
								AND @cd_grau_parentesco <10
								AND @vl_plano<>@vl_dep SELECT
                                                       	@vl_plano=@vl_dep ,
                                                       	@altera_dep=1

								IF @tipo_preco = 1
								AND @cd_grau_parentesco=10
								AND @vl_plano<>@vl_agregado SELECT
                                                            	@vl_plano=@vl_agregado ,
                                                            	@altera_dep=1

								-- Tipo Preco = 2 -- Vidas
								IF @tipo_preco = 2
								AND @ordem_cto = 1
								AND @cd_grau_parentesco>1
								AND @vl_plano<>@vl_dep1 SELECT
                                                        	@vl_plano=@vl_dep1 ,
                                                        	@altera_dep=1

								IF @tipo_preco = 2
								AND @ordem_cto = 2
								AND @cd_grau_parentesco>1
								AND @vl_plano<>@vl_dep2 SELECT
                                                        	@vl_plano=@vl_dep2 ,
                                                        	@altera_dep=1

								IF @tipo_preco = 2
								AND @ordem_cto = 3
								AND @cd_grau_parentesco>1
								AND @vl_plano<>@vl_dep3 SELECT
                                                        	@vl_plano=@vl_dep3 ,
                                                        	@altera_dep=1

								IF @tipo_preco = 2
								AND @ordem_cto = 4
								AND @cd_grau_parentesco>1
								AND @vl_plano<>@vl_dep4 SELECT
                                                        	@vl_plano=@vl_dep4 ,
                                                        	@altera_dep=1

								IF @tipo_preco = 2
								AND @ordem_cto >= 5
								AND @cd_grau_parentesco>1
								AND @vl_plano<>@vl_dep5 SELECT
                                                        	@vl_plano=@vl_dep5 ,
                                                        	@altera_dep=1

								IF @altera_dep=1 BEGIN -- 6.1.1.1

									UPDATE dependentes SET vl_plano = @vl_plano
									WHERE cd_sequencial=@cd_dep

									IF @@Rowcount = 0 BEGIN -- 6.1.1.1.1

										CLOSE GERA_MENSALIDADE
										DEALLOCATE GERA_MENSALIDADE

										CLOSE GERA_MENSALIDADE_2
										DEALLOCATE GERA_MENSALIDADE_2

										ROLLBACK TRANSACTION
										INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
										                          TP_ASSOCIADO_EMPRESA,
										                          CD_TIPO_PAGAMENTO,
										                          dt_gerado,
										                          DT_VENCIMENTO,
										                          cd_statusLog,
										                          obs,
										                          cd_parcela )
										VALUES ( @codigo_PK,
										         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
											          WHEN @wl_tpempresa IN (6) THEN 3
												      ELSE 1 END,
										         @cd_tipopagamento,
										         getdate(),
										         @wl_venc,
										         0,
										         'Erro na atualização do valor do dependente. Associado ('+ CONVERT(varchar(10),@cd_Ass)+') - Dependente ('+CONVERT(varchar(10),@cd_dep)+')',
										         @wl_cdparc )
										RETURN
									END -- 6.1.1.1.1

								END -- 6.1.1.1

							END -- 6.1.1


							IF @qt_parcelas_anual > 0 BEGIN -- Verificar a qtde de parcelas qtde o plano tem

								SELECT
                                	@nr_parcela_anual = (COUNT(0) + 1) -- ((COUNT(0) + 1)%12) Essa instrucao calcula a renovacao = ao 1 ano
                                FROM MENSALIDADES AS m,
                                	Mensalidades_Planos AS mp
                                WHERE m.CD_PARCELA = mp.cd_parcela_mensalidade
                                AND mp.cd_sequencial_dep = @cd_dep
                                AND mp.dt_exclusao IS NULL
                                AND mp.cd_plano = @cd_plano
                                AND m.cd_tipo_parcela IN (1,2)
                                AND m.CD_TIPO_RECEBIMENTO <> 1
                                AND m.DT_VENCIMENTO <= @wl_venc

								-- Instrucao p calculo da renovacao == ao 1 ano
								--if @nr_parcela_anual > @qt_parcelas_anual or @nr_parcela_anual=0
								--   Set @vl_plano = 0
								-- FIm

								IF @nr_parcela_anual>12 SET @vl_plano = CONVERT(money,((@vl_plano*@qt_parcelas_anual)/12))

								IF @nr_parcela_anual > @qt_parcelas_anual
								AND @nr_parcela_anual<=12 SET @vl_plano = 0


							END -- Verificar a qtde de parcelas qtde o plano tem

							PRINT 'a'
							INSERT mensalidades_planos ( cd_parcela_mensalidade,
							                             cd_sequencial_dep,
							                             cd_plano,
							                             valor,
							                             cd_tipo_parcela )
							VALUES ( @wl_cdparc,
							         @cd_dep,
							         @cd_plano,
							         @vl_plano + round(CASE WHEN @qtdias=0 THEN 0
									                        ELSE @qtdias * (@vl_plano/30) END,2),
							         1 ) -- Alterado
							IF @@Rowcount = 0 BEGIN -- 6.1.1

								CLOSE GERA_MENSALIDADE
								DEALLOCATE GERA_MENSALIDADE

								CLOSE GERA_MENSALIDADE_2
								DEALLOCATE GERA_MENSALIDADE_2

								ROLLBACK TRANSACTION
								INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
								                          TP_ASSOCIADO_EMPRESA,
								                          CD_TIPO_PAGAMENTO,
								                          dt_gerado,
								                          DT_VENCIMENTO,
								                          cd_statusLog,
								                          obs,
								                          cd_parcela )
								VALUES ( @codigo_PK,
								         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
									          WHEN @wl_tpempresa IN (6) THEN 3
										      ELSE 1 END,
								         @cd_tipopagamento,
								         getdate(),
								         @wl_venc,
								         0,
								         'Erro na Geração da Mensalidade do Associado ('+ CONVERT(varchar(10),@cd_Ass) + '/' + CONVERT(varchar(10),@cd_dep) +')',
								         @wl_cdparc )
								RETURN
							END -- 6.1.1
							PRINT 'b'
							SELECT
                            	@wl_acumula = @wl_acumula + @vl_plano + round(CASE WHEN @qtdias=0 THEN 0
                            			                                           ELSE @qtdias * (@vl_plano/30) END,2) -- Alterado
							PRINT 'c'

						END -- 6.1

						FETCH NEXT FROM GERA_MENSALIDADE_2 INTO @cd_Ass, @cd_dep, @vl_plano, @gera, @vl_tit, @vl_dep, @vl_agregado, @fl_valor_fixo, @cd_grau_parentesco, @cd_plano,@qt_parcelas_anual,@vl_dep1,@vl_dep2,@vl_dep3,@vl_dep4,@vl_dep5
					END -- 6
					CLOSE GERA_MENSALIDADE_2
					DEALLOCATE GERA_MENSALIDADE_2

					-- Gerar o Pro-Rata
					IF @fl_calcula_prorata>0 BEGIN
						DECLARE GERA_MENSALIDADE_3 CURSOR FOR
						SELECT TOP 10000
                        	t2.cd_Associado ,
                        	cd_sequencial_dep ,
                        	t2.cd_plano ,
                        	round((valor/30)*(dbo.FF_Calculo_Prorata (t2.dt_assinaturaContrato,@dia_inicio_cobertura)),2)
                        FROM Mensalidades_Planos t1,
                        	DEPENDENTES t2
                        WHERE cd_parcela_mensalidade = @wl_cdparc
                        AND t1.cd_sequencial_dep = t2.CD_SEQUENCIAL
                        AND cd_sequencial_dep NOT IN (
                        SELECT DISTINCT
                        	   cd_sequencial_dep
                        FROM mensalidades AS m,
                        	Mensalidades_Planos AS mp,
                        	DEPENDENTES AS d
                        WHERE m.CD_PARCELA=mp.cd_parcela_mensalidade
                        AND mp.cd_sequencial_dep = d.CD_SEQUENCIAL
                        AND m.cd_tipo_parcela=1
                        AND m.CD_TIPO_RECEBIMENTO<>1
                        AND mp.dt_exclusao IS NULL
                        AND m.CD_ASSOCIADO_empresa=@codigo_PK
                        AND m.TP_ASSOCIADO_EMPRESA IN (CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                        	                                WHEN @wl_tpempresa IN (6) THEN 3
                        		                            ELSE 1 END)
                        AND m.DT_VENCIMENTO < @wl_venc
                        AND m.DT_VENCIMENTO>=d.dt_assinaturaContrato)
						OPEN GERA_MENSALIDADE_3 -- Valores dos Planos dos Usuarios
						FETCH NEXT FROM GERA_MENSALIDADE_3 INTO @cd_Ass,@cd_dep, @cd_plano, @vl_plano
						WHILE (@@FETCH_STATUS <> -1)
						BEGIN -- Calculo Pro-rata
							IF @vl_plano<>0 BEGIN

								PRINT 'pro-rata'
								PRINT @cd_dep
								PRINT @wl_cdparc

								INSERT mensalidades_planos ( cd_parcela_mensalidade,
								                             cd_sequencial_dep,
								                             cd_plano,
								                             valor,
								                             cd_tipo_parcela )
								VALUES ( @wl_cdparc,
								         @cd_dep,
								         @cd_plano,
								         @vl_plano,
								         11 )
								IF @@Rowcount = 0 BEGIN -- 6.1.1

									CLOSE GERA_MENSALIDADE
									DEALLOCATE GERA_MENSALIDADE

									CLOSE GERA_MENSALIDADE_3
									DEALLOCATE GERA_MENSALIDADE_3

									ROLLBACK TRANSACTION
									INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
									                          TP_ASSOCIADO_EMPRESA,
									                          CD_TIPO_PAGAMENTO,
									                          dt_gerado,
									                          DT_VENCIMENTO,
									                          cd_statusLog,
									                          obs,
									                          cd_parcela )
									VALUES ( @codigo_PK,
									         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
										          WHEN @wl_tpempresa IN (6) THEN 3
											      ELSE 1 END,
									         @cd_tipopagamento,
									         getdate(),
									         @wl_venc,
									         0,
									         'Erro na Geração do Pro-rata do Associado ('+ CONVERT(varchar(10),@cd_Ass) + '/' + CONVERT(varchar(10),@cd_dep) +')',
									         @wl_cdparc )
									RETURN
								END -- 6.1.1

								SELECT
                                	@wl_acumula = @wl_acumula + @vl_plano
							END
							FETCH NEXT FROM GERA_MENSALIDADE_3 INTO @cd_Ass,@cd_dep, @cd_plano, @vl_plano
						END -- Calculo Pro-rata
						CLOSE GERA_MENSALIDADE_3
						DEALLOCATE GERA_MENSALIDADE_3


					END

					-- Gerar os Lancamentos Avulsos
					IF @tp_empresa IN (2,6,7,8) BEGIN
						UPDATE Mensalidades_Avulsas SET dt_vencimento = CASE WHEN dt_vencimento IS NULL THEN @wl_venc
										                                     ELSE dt_vencimento END ,
								dt_vencimento_final = CASE WHEN dt_vencimento_final IS NOT NULL THEN dt_vencimento_final -- Se nao for null fica ele mesmo
									                       WHEN dt_vencimento IS NOT NULL THEN dt_vencimento -- Se o final for null e o inicial nao fica o inicial
										                   ELSE @wl_venc -- Data da mensalidade
								END
						FROM dependentes AS d,
							ASSOCIADOS AS a
						WHERE Mensalidades_Avulsas.cd_sequencial_dep = d.CD_SEQUENCIAL
						AND d.CD_ASSOCIADO = a.cd_associado
						AND a.cd_empresa = @codigo_PK
						AND ( dt_vencimento IS NULL
						OR dt_vencimento_final IS NULL )

						DECLARE GERA_MENSALIDADE_2 CURSOR FOR
						SELECT TOP 10000
                        	t2.cd_Associado ,
                        	t1.cd_sequencial_dep ,
                        	t2.cd_plano ,
                        	t1.valor * CONVERT(money,CASE WHEN ISNULL(t4.fl_positivo,1)=1 THEN 1
                        			                      ELSE -1 END) ,
                        	t1.cd_tipo_parcela
                        FROM Mensalidades_avulsas t1,
                        	DEPENDENTES t2,
                        	associados t3,
                        	Tipo_parcela t4,
                        	historico t5,
                        	situacao_historico t6,
                        	dependentes tt2,
                        	historico tt5,
                        	situacao_historico tt6 -- titular
                        WHERE t1.cd_sequencial_dep = t2.cd_sequencial
                        AND t1.dt_exclusao IS NULL
                        AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                        AND t2.cd_associado = t3.cd_associado
                        AND t2.cd_sequencial_historico = t5.cd_sequencial
                        AND t5.cd_situacao = t6.cd_situacao_historico
                        AND t6.fl_gera_cobranca=1
                        AND t3.cd_Associado = tt2.cd_Associado
                        AND tt2.cd_grau_parentesco = 1
                        AND tt2.cd_sequencial_historico = tt5.cd_sequencial
                        AND tt5.cd_situacao = tt6.cd_situacao_historico
                        AND tt6.fl_gera_cobranca=1
                        AND t3.cd_empresa = @codigo_PK
                        AND t1.dt_vencimento <= @wl_venc
                        AND t1.dt_vencimento_final >= @wl_venc

					END ELSE
					BEGIN
						UPDATE Mensalidades_Avulsas SET dt_vencimento = CASE WHEN dt_vencimento IS NULL THEN @wl_venc
										                                     ELSE dt_vencimento END ,
								dt_vencimento_final = CASE WHEN dt_vencimento_final IS NOT NULL THEN dt_vencimento_final -- Se nao for null fica ele mesmo
									                       WHEN dt_vencimento IS NOT NULL THEN dt_vencimento -- Se o final for null e o inicial nao fica o inicial
										                   ELSE @wl_venc -- Data da mensalidade
								END
						FROM dependentes AS d
						WHERE Mensalidades_Avulsas.cd_sequencial_dep = d.CD_SEQUENCIAL
						AND d.CD_ASSOCIADO = @codigo_PK
						AND ( dt_vencimento IS NULL
						OR dt_vencimento_final IS NULL )

						DECLARE GERA_MENSALIDADE_2 CURSOR FOR
						SELECT TOP 10000
                        	t2.cd_Associado ,
                        	t1.cd_sequencial_dep ,
                        	t2.cd_plano ,
                        	t1.valor * CONVERT(money,CASE WHEN ISNULL(t4.fl_positivo,1)=1 THEN 1
                        			                      ELSE -1 END) ,
                        	t1.cd_tipo_parcela -- * convert(money,case when ISNULL(t4.fl_positivo,1)=1 then 1 else -1 end)
                        FROM Mensalidades_avulsas t1,
                        	DEPENDENTES t2,
                        	associados t3,
                        	Tipo_parcela t4,
                        	historico t5,
                        	situacao_historico t6,
                        	dependentes tt2,
                        	historico tt5,
                        	situacao_historico tt6 -- titular
                        WHERE t1.cd_sequencial_dep = t2.cd_sequencial
                        AND t1.dt_exclusao IS NULL
                        AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                        AND t2.cd_associado = t3.cd_associado
                        AND t2.cd_sequencial_historico = t5.cd_sequencial
                        AND t5.cd_situacao = t6.cd_situacao_historico
                        AND t6.fl_gera_cobranca=1
                        AND t3.cd_Associado = tt2.cd_Associado
                        AND tt2.cd_grau_parentesco = 1
                        AND tt2.cd_sequencial_historico = tt5.cd_sequencial
                        AND tt5.cd_situacao = tt6.cd_situacao_historico
                        AND tt6.fl_gera_cobranca=1
                        AND t2.cd_associado = @codigo_PK
                        AND t1.dt_vencimento <= @wl_venc
                        AND t1.dt_vencimento_final >= @wl_venc

					END

					OPEN GERA_MENSALIDADE_2 -- Valores dos Planos dos Usuarios
					FETCH NEXT FROM GERA_MENSALIDADE_2 INTO @cd_Ass,@cd_dep, @cd_plano, @vl_plano, @cd_tipo_parcela
					WHILE (@@FETCH_STATUS <> -1)
					BEGIN -- Calculo Mensalidades Avulsas


						INSERT mensalidades_planos ( cd_parcela_mensalidade,
						                             cd_sequencial_dep,
						                             cd_plano,
						                             valor,
						                             cd_tipo_parcela )
						VALUES ( @wl_cdparc,
						         @cd_dep,
						         @cd_plano,
						         @vl_plano,
						         @cd_tipo_parcela )
						IF @@Rowcount = 0 BEGIN -- 6.1.1

							CLOSE GERA_MENSALIDADE
							DEALLOCATE GERA_MENSALIDADE

							CLOSE GERA_MENSALIDADE_2
							DEALLOCATE GERA_MENSALIDADE_2

							ROLLBACK TRANSACTION
							INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
							                          TP_ASSOCIADO_EMPRESA,
							                          CD_TIPO_PAGAMENTO,
							                          dt_gerado,
							                          DT_VENCIMENTO,
							                          cd_statusLog,
							                          obs,
							                          cd_parcela )
							VALUES ( @codigo_PK,
							         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
								          WHEN @wl_tpempresa IN (6) THEN 3
									      ELSE 1 END,
							         @cd_tipopagamento,
							         getdate(),
							         @wl_venc,
							         0,
							         'Erro na Geração da Mensalidade Avulsa do Associado ('+ CONVERT(varchar(10),@cd_Ass) + '/' + CONVERT(varchar(10),@cd_dep) +')',
							         @wl_cdparc )
							RETURN
						END -- 6.1.1

						SELECT
                        	@wl_acumula = @wl_acumula + @vl_plano

						FETCH NEXT FROM GERA_MENSALIDADE_2 INTO @cd_Ass,@cd_dep, @cd_plano, @vl_plano,@cd_tipo_parcela
					END -- Calculo Mensalidades Avulsas
					CLOSE GERA_MENSALIDADE_2
					DEALLOCATE GERA_MENSALIDADE_2
					-- Fim -- Gerar os Lancamentos Avulsos


					-- testar se o valor dos usuarios estao corretos
					PRINT '1'
					SELECT
                    	@vl_total = isnull(sum(valor),0)
                    FROM mensalidades_planos
                    WHERE cd_parcela_mensalidade = @wl_cdparc
                    AND dt_exclusao IS NULL
					IF @vl_total <> @wl_acumula BEGIN -- 7
						CLOSE GERA_MENSALIDADE
						DEALLOCATE GERA_MENSALIDADE
						ROLLBACK TRANSACTION
						INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
						                          TP_ASSOCIADO_EMPRESA,
						                          CD_TIPO_PAGAMENTO,
						                          dt_gerado,
						                          DT_VENCIMENTO,
						                          cd_statusLog,
						                          obs,
						                          cd_parcela )
						VALUES ( @codigo_PK,
						         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
							          WHEN @wl_tpempresa IN (6) THEN 3
								      ELSE 1 END,
						         @cd_tipopagamento,
						         getdate(),
						         @wl_venc,
						         0,
						         'Divergencia de valores. Acumulado (' + CONVERT(varchar(20),@wl_acumula) +') e Gerado ('+ CONVERT(varchar(10),@vl_total) +')',
						         @wl_cdparc )
						RETURN
					END -- 7
					PRINT '2'
					IF @vl_total > 0 BEGIN -- 8
						-- Atualizar o Total da Fatura. Verificar Impostos e Acrescimo/Desconto
						-- Gerar o Nosso Numero
						UPDATE mensalidades SET VL_PARCELA = @vl_total ,
								cd_usuario_alteracao = @cd_funcionario ,
								VL_Acrescimo = (CASE WHEN @ajuste>0 THEN @ajuste
										             ELSE 0 END) ,
								VL_Desconto = (CASE WHEN @ajuste<0 THEN abs(@ajuste)
										            ELSE 0 END)
						--- Falta atualizar o nosso numero
						WHERE cd_parcela = @wl_cdparc
						IF @@Rowcount = 0 BEGIN -- 8.1
							CLOSE GERA_MENSALIDADE
							DEALLOCATE GERA_MENSALIDADE
							ROLLBACK TRANSACTION
							INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
							                          TP_ASSOCIADO_EMPRESA,
							                          CD_TIPO_PAGAMENTO,
							                          dt_gerado,
							                          DT_VENCIMENTO,
							                          cd_statusLog,
							                          obs,
							                          cd_parcela )
							VALUES ( @codigo_PK,
							         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
								          WHEN @wl_tpempresa IN (6) THEN 3
									      ELSE 1 END,
							         @cd_tipopagamento,
							         getdate(),
							         @wl_venc,
							         0,
							         'Erro na atualização do valor total da fatura',
							         @wl_cdparc )
							RETURN
						END -- 8.1
						PRINT '3'
						IF @wl_percretencao>0
						AND @tp_empresa IN (2,6,7,8) BEGIN -- 8.2
							UPDATE mensalidades SET VL_Desconto = (VL_PARCELA-VL_Desconto)*(@wl_percretencao/100) ,
									cd_usuario_alteracao = @cd_funcionario
							WHERE cd_parcela = @wl_cdparc
							IF @@Rowcount = 0 BEGIN -- 8.2.1

								CLOSE GERA_MENSALIDADE
								DEALLOCATE GERA_MENSALIDADE

								ROLLBACK TRANSACTION
								INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
								                          TP_ASSOCIADO_EMPRESA,
								                          CD_TIPO_PAGAMENTO,
								                          dt_gerado,
								                          DT_VENCIMENTO,
								                          cd_statusLog,
								                          obs,
								                          cd_parcela )
								VALUES ( @codigo_PK,
								         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
									          WHEN @wl_tpempresa IN (6) THEN 3
										      ELSE 1 END,
								         @cd_tipopagamento,
								         getdate(),
								         @wl_venc,
								         0,
								         'Erro no calculo do imposto',
								         @wl_cdparc )
								RETURN
							END -- 8.2.1
						END -- 8.2

						-- Mensalidade Avulsa na empresa
						IF @wl_tpempresa IN (2,7,8) BEGIN

							UPDATE Mensalidades_Avulsas SET dt_vencimento = CASE WHEN dt_vencimento IS NULL THEN @wl_venc
											                                     ELSE dt_vencimento END ,
									dt_vencimento_final = CASE WHEN dt_vencimento_final IS NOT NULL THEN dt_vencimento_final -- Se nao for null fica ele mesmo
										                       WHEN dt_vencimento IS NOT NULL THEN dt_vencimento -- Se o final for null e o inicial nao fica o inicial
											                   ELSE @wl_venc -- Data da mensalidade
									END
							WHERE Mensalidades_Avulsas.cd_empresa = @codigo_PK
							AND ( dt_vencimento IS NULL
							OR dt_vencimento_final IS NULL )

							UPDATE mensalidades SET VL_Acrescimo = isnull(VL_Acrescimo,0)+ISNULL((SELECT
                                                                                                  	sum(t1.valor)
                                                                                                  FROM Mensalidades_avulsas t1,
                                                                                                  	Tipo_parcela t4
                                                                                                  WHERE t1.cd_empresa = @codigo_PK
                                                                                                  AND t1.dt_exclusao IS NULL
                                                                                                  AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                                                                                                  AND t4.fl_positivo = 1
                                                                                                  AND t1.dt_vencimento <= @wl_venc
                                                                                                  AND t1.dt_vencimento_final >= @wl_venc
									),0) ,
									VL_Desconto = isnull(VL_Desconto,0)+ISNULL((SELECT
                                                                                	sum(t1.valor)
                                                                                FROM Mensalidades_avulsas t1,
                                                                                	Tipo_parcela t4
                                                                                WHERE t1.cd_empresa = @codigo_PK
                                                                                AND t1.dt_exclusao IS NULL
                                                                                AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                                                                                AND t4.fl_positivo = 0
                                                                                AND t1.dt_vencimento <= @wl_venc
                                                                                AND t1.dt_vencimento_final >= @wl_venc
									),0) ,
									cd_usuario_alteracao = @cd_funcionario
							WHERE cd_parcela = @wl_cdparc


						END
						-- Fim Mensalidade Avulsa na empresa


						-- Mensalidade Avulsa na empresa
						IF @wl_tpempresa IN (2,7,8) BEGIN

							UPDATE Mensalidades_Avulsas SET dt_vencimento = CASE WHEN dt_vencimento IS NULL THEN @wl_venc
											                                     ELSE dt_vencimento END ,
									dt_vencimento_final = CASE WHEN dt_vencimento_final IS NOT NULL THEN dt_vencimento_final -- Se nao for null fica ele mesmo
										                       WHEN dt_vencimento IS NOT NULL THEN dt_vencimento -- Se o final for null e o inicial nao fica o inicial
											                   ELSE @wl_venc -- Data da mensalidade
									END
							WHERE Mensalidades_Avulsas.cd_empresa = @codigo_PK
							AND ( dt_vencimento IS NULL
							OR dt_vencimento_final IS NULL )

							UPDATE mensalidades SET VL_Acrescimo = isnull(VL_Acrescimo,0)+ISNULL((SELECT
                                                                                                  	sum(t1.valor)
                                                                                                  FROM Mensalidades_avulsas t1,
                                                                                                  	Tipo_parcela t4
                                                                                                  WHERE t1.cd_empresa = @codigo_PK
                                                                                                  AND t1.dt_exclusao IS NULL
                                                                                                  AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                                                                                                  AND t4.fl_positivo = 1
                                                                                                  AND t1.dt_vencimento <= @wl_venc
                                                                                                  AND t1.dt_vencimento_final >= @wl_venc
									),0) ,
									VL_Desconto = isnull(VL_Desconto,0)+ISNULL((SELECT
                                                                                	sum(t1.valor)
                                                                                FROM Mensalidades_avulsas t1,
                                                                                	Tipo_parcela t4
                                                                                WHERE t1.cd_empresa = @codigo_PK
                                                                                AND t1.dt_exclusao IS NULL
                                                                                AND t1.cd_tipo_parcela = t4.cd_tipo_parcela
                                                                                AND t4.fl_positivo = 0
                                                                                AND t1.dt_vencimento <= @wl_venc
                                                                                AND t1.dt_vencimento_final >= @wl_venc
									),0) ,
									cd_usuario_alteracao = @cd_funcionario
							WHERE cd_parcela = @wl_cdparc


						END

						--- Gerar Nota Fiscal
						PRINT 'Gerar Nota Fiscal'
						EXEC SP_Gerar_Imposto
							@wl_cdparc

						PRINT '4'
						-- Gravar no Log
						INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
						                          TP_ASSOCIADO_EMPRESA,
						                          CD_TIPO_PAGAMENTO,
						                          dt_gerado,
						                          DT_VENCIMENTO,
						                          cd_statusLog,
						                          obs,
						                          vl_fatura,
						                          cd_parcela )
						VALUES ( @codigo_PK,
						         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
							          WHEN @wl_tpempresa IN (6) THEN 3
								      ELSE 1 END,
						         @cd_tipopagamento,
						         getdate(),
						         @wl_venc,
						         (CASE WHEN @fl_Online=1
							AND @email IS NOT NULL THEN 2
								       ELSE 1 END),
						         (CASE WHEN @fl_Online=1
							AND @email IS NOT NULL THEN 'Fatura gerada e enviada com sucesso. Email:' + @email
								       ELSE 'Fatura Gerada sem envio/Impressão.' END),
						         @wl_acumula,
						         @wl_cdparc )
						PRINT '5'
						-- Enviar E-mail se (@fl_Online=1)
						PRINT '@fl_Online=1'
						PRINT @fl_Online
						PRINT '@email is not null'
						PRINT @email
						PRINT '@fl_envia_email_fatautomatico=1'
						PRINT @fl_envia_email_fatautomatico
						PRINT '@fl_cobranca_registrada = 0'
						PRINT @fl_cobranca_registrada

						IF @fl_Online=1
						AND @email IS NOT NULL
						AND @fl_envia_email_fatautomatico=1
						AND @fl_cobranca_registrada = 0 -- 12/04
						BEGIN
							PRINT 'E-mail'
							IF @wl_tpempresa IN (2,7,8) EXEC SP_Email_Fatura
								@email,
								@codigo_PK,
								0 ELSE
							EXEC SP_Email_Fatura
								@email,
								0,
								@codigo_PK
						END

					END -- 8
					ELSE
					BEGIN -- Valor total == 0. Excluir fatura
						--delete mensalidades_planos where cd_parcela_mensalidade = @wl_cdparc
						--delete mensalidades where cd_parcela = @wl_cdparc
						INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
						                          TP_ASSOCIADO_EMPRESA,
						                          CD_TIPO_PAGAMENTO,
						                          dt_gerado,
						                          DT_VENCIMENTO,
						                          cd_statusLog,
						                          obs,
						                          cd_parcela )
						VALUES ( @codigo_PK,
						         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
							          WHEN @wl_tpempresa IN (6) THEN 3
								      ELSE 1 END,
						         @cd_tipopagamento,
						         getdate(),
						         @wl_venc,
						         3,
						         'Fatura sem valor.',
						         @wl_cdparc )
					END -- Valor total == 0. Excluir fatura

				END -- Inicio do Laço para criar as mensalidades Boleto=1 ou Carnes=N
			--End -- 4
			END -- 3
			ELSE
			BEGIN -- 90
				PRINT 'nao envia email'
				IF @Sequencial_LogMensalidades>0 BEGIN --90.1
					SELECT TOP 1
                    	@dt_impresso = dt_impresso ,
                    	@wl_acumula = VL_PARCELA
                    FROM mensalidades
                    WHERE cd_associado_empresa = @codigo_PK
                    AND tp_associado_empresa = (CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
                    	                             WHEN @wl_tpempresa IN (6) THEN 3
                    		                         ELSE 1 END)
                    AND month(dt_vencimento) = month(@wl_venc)
                    AND year(dt_vencimento) = year(@wl_venc)
                    AND cd_tipo_parcela = 1
                    AND cd_tipo_recebimento NOT IN (1,2)

					INSERT log_mensalidades ( CD_ASSOCIADO_empresa,
					                          TP_ASSOCIADO_EMPRESA,
					                          CD_TIPO_PAGAMENTO,
					                          dt_gerado,
					                          DT_VENCIMENTO,
					                          cd_statusLog,
					                          obs,
					                          vl_fatura,
					                          cd_parcela )
					VALUES ( @codigo_PK,
					         CASE WHEN @wl_tpempresa IN (2,7,8) THEN 2
						          WHEN @wl_tpempresa IN (6) THEN 3
							      ELSE 1 END,
					         @cd_tipopagamento,
					         getdate(),
					         @wl_venc,
					         (CASE WHEN @dt_impresso IS NOT NULL THEN 4
							       ELSE 5 END),
					         (CASE WHEN @dt_impresso IS NOT NULL THEN 'Fatura já existente e impressa no Banco de Dados.'
							       ELSE 'Fatura existente no Banco de Dados sem impressão.' END),
					         @wl_acumula,
					         @wl_cdparc )

				END -- 90.1
			END -- 90

			FETCH NEXT 
            FROM GERA_MENSALIDADE INTO 
            @ajuste,@wl_percretencao, @wl_tpempresa, @grupo, @cd_tipopagamento, @fl_Online, @cd_tipo_servico_bancario, @email,@fl_calcula_prorata,@dia_inicio_cobertura,@tipo_preco,@dia_venc, @fl_cobranca_registrada
		END -- 2
		CLOSE GERA_MENSALIDADE
		DEALLOCATE GERA_MENSALIDADE

		COMMIT TRANSACTION

	END -- 1
