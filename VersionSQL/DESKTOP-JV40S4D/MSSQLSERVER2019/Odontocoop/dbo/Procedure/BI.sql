/****** Object:  Procedure [dbo].[BI]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI]
AS BEGIN

		DECLARE @dtref INT = -90

		IF DATEPART(DW, GETDATE()) = 1 SET @dtref = -10000

		DECLARE @i INTEGER = 1
		DECLARE @c_emp INTEGER

		DECLARE @qtde VARCHAR(10)

		--SELECT
		--	@qtde = CONVERT(VARCHAR(10), COUNT(0))
		--FROM dbo.EMPRESA t1,
		--	dbo.HISTORICO t2
		--WHERE t1.CD_Sequencial_historico = t2.cd_sequencial
		--AND ( t2.cd_situacao <> 2
		--OR ( t2.cd_situacao = 2
		--AND t2.dt_situacao >= DATEADD(DAY, @dtref, GETDATE()) ) )

		SELECT
        	@qtde = CONVERT(VARCHAR(10), COUNT(0))
        FROM dbo.EMPRESA t1
        	INNER JOIN dbo.HISTORICO t2 ON t1.cd_sequencial_historico=t2.cd_sequencial
        WHERE ( t2.cd_situacao <> 2
        OR ( t2.cd_situacao = 2
        AND t2.dt_situacao >= DATEADD(DAY, @dtref, GETDATE()) ) )

		DECLARE CUR_EMP CURSOR FOR
		--select cd_empresa from empresa -- where cd_situacao=1  order by cd_empresa
		--SELECT
		--      	t1.CD_EMPRESA
		--      FROM dbo.EMPRESA t1,
		--      	dbo.HISTORICO t2
		--      WHERE t1.CD_Sequencial_historico = t2.cd_sequencial
		--      AND t1.TP_EMPRESA < 10
		--      AND ( t2.cd_situacao <> 2
		--      OR ( t2.cd_situacao = 2
		--      AND t2.dt_situacao >= DATEADD(DAY, @dtref, GETDATE()) ) )

		SELECT
        	t1.CD_EMPRESA
        FROM dbo.EMPRESA t1
        	INNER JOIN dbo.HISTORICO t2 ON t1.cd_sequencial_historico = t2.cd_sequencial
        WHERE t1.TP_EMPRESA < 10
        AND ( t2.cd_situacao <> 2
        OR ( t2.cd_situacao = 2
        AND t2.dt_situacao >= DATEADD(DAY, @dtref, GETDATE()) ) )


		OPEN CUR_EMP
		FETCH NEXT FROM CUR_EMP INTO @c_emp

		WHILE (@@fetch_status <> -1)
		BEGIN

			PRINT 'Empresa: ' + CONVERT(VARCHAR(10), @c_emp) + ' Indicador:' + CONVERT(VARCHAR(10), @i) + '/' + @qtde
			SET @i = @i + 1

			INSERT INTO S4EBI..PROCEDIMENTOS ( CD_SEQUENCIAL_CONSULTA,
			                                   dt_servico,
			                                   cd_associado,
			                                   cd_sequencial_dep,
			                                   nm_responsavel,
			                                   nu_matricula,
			                                   NM_DEPENDENTE,
			                                   CD_EMPRESA,
			                                   NM_RAZSOC,
			                                   cd_servico,
			                                   NM_SERVICO,
			                                   cd_UD,
			                                   oclusal,
			                                   distral,
			                                   mesial,
			                                   vestibular,
			                                   lingual,
			                                   CD_FUNCIONARIO,
			                                   nm_empregado,
			                                   cd_filial,
			                                   nm_filial,
			                                   dt_baixa,
			                                   NR_GUIA,
			                                   FL_ANALISA,
			                                   VL_CLIENTE,
			                                   VL_CUSTO,
			                                   VL_CREDENCIADO,
			                                   cd_sequencial_agenda,
			                                   UFIDFIL,
			                                   CIDIDFIL,
			                                   BAIIDFIL,
			                                   UFIDASS,
			                                   CIDIDASS,
			                                   BAIIDASS,
			                                   cd_especialidade,
			                                   nm_especialidade )
				SELECT
                	C.cd_sequencial ,
                	C.dt_servico ,
                	ASS.cd_associado ,
                	C.cd_sequencial_dep ,
                	ASS.nm_completo ,
                	ASS.nu_matricula ,
                	DEP.NM_DEPENDENTE ,
                	ASS.CD_EMPRESA ,
                	E.NM_RAZSOC ,
                	C.cd_servico ,
                	S.NM_SERVICO ,
                	C.cd_UD ,
                	C.oclusal ,
                	C.distral ,
                	C.mesial ,
                	C.vestibular ,
                	C.lingual ,
                	C.CD_FUNCIONARIO ,
                	F.nm_empregado ,
                	FI.cd_filial ,
                	FI.nm_filial ,
                	C.dt_baixa ,
                	C.nr_numero_lote ,
                	C.Status ,
                	TC.vl_servico ,
                	TE.vl_servico ,
                	TE.vl_servico ,
                	C.cd_sequencial_agenda ,
                	ISNULL(FI.ufId, 0) ,
                	ISNULL(FI.CidID, 0) ,
                	ISNULL(FI.BaiId, 0) ,
                	-- Filial
                	ISNULL(ASS.ufId, 0) ,
                	ISNULL(ASS.CidID, 0) ,
                	ISNULL(ASS.BaiId, 0) ,
                	-- Associados
                	ISNULL(S.cd_especialidade, 0) ,
                	ISNULL(ESP.nm_especialidade, 'Não Especificado')
                -- TRECHO COMENTADO PARA CORREÇÃO JOINS
				/*
					FROM dbo.Consultas AS C
						,(SELECT
								 cd_servico
								,NM_SERVICO
								,(SELECT TOP 1
										 SEINT.CD_ESPECIALIDADE
									 FROM dbo.ServicoEspecialidade AS SEINT
									 WHERE SEINT.cd_servico = SERVICO.cd_servico
									 ORDER BY CD_ESPECIALIDADE)
								 CD_ESPECIALIDADE
							 FROM dbo.SERVICO) AS S
						,dbo.FILIAL AS FI
						,dbo.FUNCIONARIO AS F
						,dbo.DEPENDENTES AS DEP
						,dbo.ASSOCIADOS AS ASS
						,dbo.EMPRESA AS E
						,dbo.TIPO_PAGAMENTO T
						,dbo.tabela_servicos TC
						, -- Custo do Cliente
						 dbo.tabela_servicos TE
						, -- produtividade
						 dbo.ESPECIALIDADE AS ESP
					WHERE
					 C.cd_servico = S.cd_servico
					 AND C.CD_filial = FI.CD_filial
					 AND C.CD_FUNCIONARIO = F.CD_FUNCIONARIO
					 AND C.cd_sequencial_dep = DEP.cd_sequencial
					 AND DEP.cd_associado = ASS.cd_associado
					 AND ASS.cd_empresa = E.cd_empresa
					 AND C.Status IN (3, 6, 7) -- Remover os inconsistentes 
					 AND C.dt_servico IS NOT NULL
					 AND E.cd_empresa = @c_emp
					 AND F.cd_tabela = TE.cd_tabela
					 AND C.cd_servico = TE.cd_servico
					 AND E.cd_tipo_pagamento = T.cd_tipo_pagamento
					 AND T.cd_tabela = TC.cd_tabela
					 AND C.cd_servico = TC.cd_servico
					 AND S.CD_ESPECIALIDADE *= ESP.CD_ESPECIALIDADE
					 AND C.cd_sequencial NOT IN (SELECT
							 CD_SEQUENCIAL_CONSULTA
						 FROM S4EBI..PROCEDIMENTOS
						 WHERE cd_empresa = @c_emp)
						 */

                FROM Consultas AS C
                	INNER JOIN (SELECT
                                	cd_servico ,
                                	NM_SERVICO ,
                                	(SELECT TOP (1)
                                     	cd_especialidade
                                     FROM ServicoEspecialidade AS SEINT
                                     WHERE (cd_servico = SERVICO.cd_servico)
                                     ORDER BY cd_especialidade)
                                	cd_especialidade
                                FROM SERVICO) AS S ON C.cd_servico = S.cd_servico
                	INNER JOIN FILIAL AS FI ON C.cd_filial = FI.cd_filial
                	INNER JOIN FUNCIONARIO AS F ON C.CD_FUNCIONARIO = F.CD_FUNCIONARIO
                	INNER JOIN DEPENDENTES AS DEP ON C.cd_sequencial_dep = DEP.cd_sequencial
                	INNER JOIN ASSOCIADOS AS ASS ON DEP.cd_associado = ASS.cd_associado
                	INNER JOIN EMPRESA AS E ON ASS.CD_EMPRESA = E.CD_EMPRESA
                	INNER JOIN tabela_servicos AS TE ON F.cd_tabela = TE.cd_tabela
                		AND C.cd_servico = TE.cd_servico
                	INNER JOIN TIPO_PAGAMENTO AS T ON E.cd_tipo_pagamento = T.cd_tipo_pagamento
                	INNER JOIN tabela_servicos AS TC ON T.cd_tabela = TC.cd_tabela
                		AND C.cd_servico = TC.cd_servico
                	LEFT OUTER JOIN ESPECIALIDADE AS ESP ON S.cd_especialidade = ESP.cd_especialidade
                WHERE (C.Status IN (3, 6, 7))
                AND (C.dt_servico IS NOT NULL)
                AND (E.CD_EMPRESA = @c_emp)
                AND (C.cd_sequencial NOT IN (SELECT
                                             	CD_SEQUENCIAL_CONSULTA
                                             FROM S4EBI.dbo.PROCEDIMENTOS
                                             WHERE (ASS.CD_EMPRESA = @c_emp))
                )



			IF @dtref <> -10000 -- Excluir os procedimentos q nao estao + pendentes
			BEGIN
				DELETE S4EBI..PROCEDIMENTOS_PENDENTES
				WHERE CD_EMPRESA = @c_emp
				AND CD_SEQUENCIAL_CONSULTA NOT IN (SELECT
                                                   	C.cd_sequencial
                                                   FROM dbo.Consultas AS C,
                                                   	dbo.DEPENDENTES AS D,
                                                   	dbo.ASSOCIADOS AS a
                                                   WHERE C.cd_sequencial_dep = D.cd_sequencial
                                                   AND D.cd_associado = a.cd_associado
                                                   AND a.CD_EMPRESA = @c_emp
                                                   AND C.Status IN (2, 6, 7)
                                                   AND C.dt_servico IS NULL)
			END

			-- Incluir os pendentes dos usuarios ativos
			INSERT INTO S4EBI..PROCEDIMENTOS_PENDENTES ( CD_SEQUENCIAL_CONSULTA,
			                                             dt_impressao_guia,
			                                             cd_associado,
			                                             cd_sequencial_dep,
			                                             nm_responsavel,
			                                             nu_matricula,
			                                             NM_DEPENDENTE,
			                                             CD_EMPRESA,
			                                             NM_RAZSOC,
			                                             cd_servico,
			                                             NM_SERVICO,
			                                             cd_UD,
			                                             oclusal,
			                                             distral,
			                                             mesial,
			                                             vestibular,
			                                             lingual,
			                                             CD_FUNCIONARIO,
			                                             nm_empregado,
			                                             cd_filial,
			                                             nm_filial,
			                                             NR_GUIA,
			                                             nr_autorizacao,
			                                             FL_ANALISA,
			                                             VL_CLIENTE,
			                                             VL_CUSTO,
			                                             VL_CREDENCIADO,
			                                             UFIDFIL,
			                                             CIDIDFIL,
			                                             BAIIDFIL,
			                                             UFIDASS,
			                                             CIDIDASS,
			                                             BAIIDASS,
			                                             cd_especialidade,
			                                             nm_especialidade )
				SELECT
                	C.cd_sequencial ,
                	C.dt_impressao_guia ,
                	ASS.cd_associado ,
                	C.cd_sequencial_dep ,
                	ASS.nm_completo ,
                	ASS.nu_matricula ,
                	DEP.NM_DEPENDENTE ,
                	ASS.CD_EMPRESA ,
                	E.NM_RAZSOC ,
                	C.cd_servico ,
                	S.NM_SERVICO ,
                	C.cd_UD ,
                	C.oclusal ,
                	C.distral ,
                	C.mesial ,
                	C.vestibular ,
                	C.lingual ,
                	C.CD_FUNCIONARIO ,
                	F.nm_empregado ,
                	FI.cd_filial ,
                	FI.nm_filial ,
                	C.nr_numero_lote ,
                	C.nr_autorizacao ,
                	C.Status ,
                	TC.vl_servico ,
                	TE.vl_servico ,
                	TE.vl_servico ,
                	ISNULL(FI.ufId, 0) ,
                	ISNULL(FI.CidID, 0) ,
                	ISNULL(FI.BaiId, 0) ,
                	-- Filial
                	ISNULL(ASS.ufId, 0) ,
                	ISNULL(ASS.CidID, 0) ,
                	ISNULL(ASS.BaiId, 0) ,
                	-- Associados
                	ISNULL(S.cd_especialidade, 0) ,
                	ISNULL(ESP.nm_especialidade, 'Não Especificado')
                -- TRECHO COMENTADO PARA CORREÇÃO JOINS
				/*
					FROM dbo.Consultas AS C
						,(SELECT
								 cd_servico
								,NM_SERVICO
								,(SELECT TOP 1
										 SEINT.CD_ESPECIALIDADE
									 FROM dbo.ServicoEspecialidade AS SEINT
									 WHERE SEINT.cd_servico = SERVICO.cd_servico
									 ORDER BY CD_ESPECIALIDADE)
								 CD_ESPECIALIDADE
							 FROM dbo.SERVICO) AS S
						,dbo.FILIAL AS FI
						,dbo.FUNCIONARIO AS F
						,dbo.DEPENDENTES AS DEP
						,dbo.ASSOCIADOS AS ASS
						,dbo.EMPRESA AS E
						,dbo.HISTORICO AS H
						,dbo.SITUACAO_HISTORICO AS SH /* Historico do Dependente */
						,dbo.TIPO_PAGAMENTO T
						,dbo.tabela_servicos TC
						, -- Custo do Cliente
						 dbo.tabela_servicos TE
						, -- produtividade
						 dbo.ESPECIALIDADE AS ESP
					WHERE
					 C.cd_servico = S.cd_servico
					 AND C.CD_filial = FI.CD_filial
					 AND C.CD_FUNCIONARIO = F.CD_FUNCIONARIO
					 AND C.cd_sequencial_dep = DEP.cd_sequencial
					 AND DEP.CD_Sequencial_historico = H.cd_sequencial
					 AND H.cd_situacao = SH.CD_SITUACAO_HISTORICO
					 AND SH.fl_atendido_clinica = 1
					 AND DEP.cd_associado = ASS.cd_associado
					 AND ASS.cd_empresa = E.cd_empresa
					 AND C.Status IN (2, 6, 7)
					 AND C.dt_servico IS NULL
					 AND E.cd_empresa = @c_emp
					 AND F.cd_tabela = TE.cd_tabela
					 AND C.cd_servico = TE.cd_servico
					 AND E.cd_tipo_pagamento = T.cd_tipo_pagamento
					 AND T.cd_tabela = TC.cd_tabela
					 AND C.cd_servico = TC.cd_servico
					 AND S.CD_ESPECIALIDADE *= ESP.CD_ESPECIALIDADE
					 AND C.cd_sequencial NOT IN (SELECT
							 CD_SEQUENCIAL_CONSULTA
						 FROM S4EBI..PROCEDIMENTOS_PENDENTES
						 WHERE cd_empresa = @c_emp)
						 */

                FROM Consultas AS C
                	INNER JOIN (SELECT
                                	cd_servico ,
                                	NM_SERVICO ,
                                	(SELECT TOP (1)
                                     	cd_especialidade
                                     FROM ServicoEspecialidade AS SEINT
                                     WHERE (cd_servico = SERVICO.cd_servico)
                                     ORDER BY cd_especialidade)
                                	cd_especialidade
                                FROM SERVICO) AS S ON C.cd_servico = S.cd_servico
                	INNER JOIN FILIAL AS FI ON C.cd_filial = FI.cd_filial
                	INNER JOIN FUNCIONARIO AS F ON C.CD_FUNCIONARIO = F.CD_FUNCIONARIO
                	INNER JOIN DEPENDENTES AS DEP ON C.cd_sequencial_dep = DEP.cd_sequencial
                	INNER JOIN HISTORICO AS H ON DEP.CD_Sequencial_historico = H.cd_sequencial
                	INNER JOIN SITUACAO_HISTORICO AS SH ON H.cd_situacao = SH.CD_SITUACAO_HISTORICO
                	INNER JOIN ASSOCIADOS AS ASS ON DEP.cd_associado = ASS.cd_associado
                	INNER JOIN EMPRESA AS E ON ASS.CD_EMPRESA = E.CD_EMPRESA
                	INNER JOIN tabela_servicos AS TE ON F.cd_tabela = TE.cd_tabela
                		AND C.cd_servico = TE.cd_servico
                	INNER JOIN TIPO_PAGAMENTO AS T ON E.cd_tipo_pagamento = T.cd_tipo_pagamento
                	INNER JOIN tabela_servicos AS TC ON T.cd_tabela = TC.cd_tabela
                		AND C.cd_servico = TC.cd_servico
                	LEFT OUTER JOIN ESPECIALIDADE AS ESP ON S.cd_especialidade = ESP.cd_especialidade
                WHERE (SH.fl_atendido_clinica = 1)
                AND (C.Status IN (2, 6, 7))
                AND (C.dt_servico IS NULL)
                AND (E.CD_EMPRESA = @c_emp)
                AND (C.cd_sequencial NOT IN (SELECT
                                             	CD_SEQUENCIAL_CONSULTA
                                             FROM S4EBI.dbo.PROCEDIMENTOS_PENDENTES
                                             WHERE (H.CD_EMPRESA = @c_emp))
                )


			INSERT S4EBI..agenda ( cd_sequencial,
			                       dt_compromisso,
			                       hr_compromisso,
			                       CD_FUNCIONARIO,
			                       nm_empregado,
			                       cd_associado,
			                       cd_sequencial_dep,
			                       nm_responsavel,
			                       nu_matricula,
			                       NM_DEPENDENTE,
			                       CD_EMPRESA,
			                       NM_RAZSOC,
			                       dt_marcado,
			                       cd_sequencial_atuacao_dent,
			                       cd_filial,
			                       nm_filial,
			                       UFIDFIL,
			                       CIDIDFIL,
			                       BAIIDFIL,
			                       UFIDASS,
			                       CIDIDASS,
			                       BAIIDASS,
			                       cd_especialidade,
			                       nm_especialidade )
				--SELECT
				--            	a.cd_sequencial ,
				--            	a.dt_compromisso ,
				--            	a.hr_compromisso ,
				--            	a.CD_FUNCIONARIO ,
				--            	F.nm_empregado ,
				--            	a.cd_associado ,
				--            	a.cd_sequencial_dep ,
				--            	ASS.nm_completo ,
				--            	ASS.nu_matricula ,
				--            	DEP.NM_DEPENDENTE ,
				--            	ASS.CD_EMPRESA ,
				--            	E.NM_RAZSOC ,
				--            	a.dt_marcado ,
				--            	a.cd_sequencial_atuacao_dent ,
				--            	a.cd_filial ,
				--            	FI.nm_filial ,
				--            	ISNULL(FI.ufId, 0) ,
				--            	ISNULL(FI.CidID, 0) ,
				--            	ISNULL(FI.BaiId, 0) ,
				--            	-- Filial
				--            	ISNULL(ASS.ufId, 0) ,
				--            	ISNULL(ASS.CidID, 0) ,
				--            	ISNULL(ASS.BaiId, 0) ,
				--            	-- Associados
				--            	ESP.cd_especialidade ,
				--            	ESP.nm_especialidade
				--            FROM dbo.agenda AS a,
				--            	dbo.FUNCIONARIO AS F,
				--            	dbo.DEPENDENTES DEP,
				--            	dbo.FILIAL AS FI,
				--            	dbo.ASSOCIADOS AS ASS,
				--            	dbo.EMPRESA AS E,
				--            	dbo.atuacao_dentista AS AD,
				--            	dbo.ESPECIALIDADE AS ESP
				--            WHERE a.CD_FUNCIONARIO = F.CD_FUNCIONARIO
				--            AND a.cd_filial = FI.cd_filial
				--            AND a.cd_associado = ASS.cd_associado
				--            AND a.cd_sequencial_dep = DEP.cd_sequencial
				--            AND ASS.CD_EMPRESA = E.CD_EMPRESA
				--            AND a.dt_compromisso >= GETDATE()
				--            AND a.cd_sequencial_atuacao_dent = AD.cd_sequencial
				--            AND AD.cd_especialidade = ESP.cd_especialidade
				--            AND ASS.CD_EMPRESA = @c_emp
				--            AND a.cd_sequencial NOT IN
				--            (SELECT
				--             	cd_sequencial
				--             FROM S4EBI..agenda
				--             WHERE CD_EMPRESA = @c_emp)

				SELECT
                	a.cd_sequencial ,
                	a.dt_compromisso ,
                	a.hr_compromisso ,
                	a.cd_funcionario ,
                	F.nm_empregado ,
                	a.cd_associado ,
                	a.cd_sequencial_dep ,
                	ASS.nm_completo ,
                	ASS.nu_matricula ,
                	DEP.NM_DEPENDENTE ,
                	ASS.cd_empresa ,
                	E.NM_RAZSOC ,
                	a.dt_marcado ,
                	a.cd_sequencial_atuacao_dent ,
                	a.cd_filial ,
                	FI.nm_filial ,
                	ISNULL(FI.ufId, 0) ,
                	ISNULL(FI.CidID, 0) ,
                	ISNULL(FI.BaiId, 0) ,
                	ISNULL(ASS.ufId, 0) ,
                	ISNULL(ASS.CidID, 0) ,
                	ISNULL(ASS.BaiId, 0) ,
                	ESP.cd_especialidade ,
                	ESP.nm_especialidade
                FROM agenda AS a
                	INNER JOIN FUNCIONARIO AS F ON a.cd_funcionario = F.cd_funcionario
                	INNER JOIN FILIAL AS FI ON a.cd_filial = FI.cd_filial
                	INNER JOIN ASSOCIADOS AS ASS ON a.cd_associado = ASS.cd_associado
                	INNER JOIN DEPENDENTES AS DEP ON a.cd_sequencial_dep = DEP.CD_SEQUENCIAL
                	INNER JOIN EMPRESA AS E ON ASS.cd_empresa = E.CD_EMPRESA
                	INNER JOIN atuacao_dentista AS AD ON a.cd_sequencial_atuacao_dent = AD.cd_sequencial
                	INNER JOIN ESPECIALIDADE AS ESP ON AD.cd_especialidade = ESP.cd_especialidade
                WHERE (a.dt_compromisso >= GETDATE())
                AND ASS.CD_EMPRESA = @c_emp
                AND a.cd_sequencial NOT IN
                (SELECT
                 	cd_sequencial
                 FROM S4EBI..agenda
                 WHERE CD_EMPRESA = @c_emp)

			FETCH NEXT FROM CUR_EMP
			INTO @c_emp
		END

		CLOSE CUR_EMP
		DEALLOCATE CUR_EMP


	END
