/****** Object:  Procedure [dbo].[BI_ProcedimentosPendentes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_ProcedimentosPendentes]

AS
  BEGIN

-- Incluir os pendentes dos usuarios ativos  
INSERT INTO Migracao2019BI..Procedimentos_Pendentes
		(
			cd_sequencial_consulta,
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
			dt_baixa,
			CD_FUNCIONARIO,
			nm_empregado,
			cd_filial,
			nm_filial,
			nr_guia,--nr_autorizacao,
			Status,
			vl_particular,
			vl_produtividade,
			cd_sequencial_agenda,
			ufidFIL,
			nmufFil,
			cididFil,
			nmCidFil,
			BaiidFIL,
			nmBaiFil,
			ufidAss,
			nmufAss,
			cididAss,
			nmCidAss,
			BaiidAss,
			nmBaiAss,
			cd_especialidade,
			nm_especialidade,
			ano,
			mes,
			cd_tipo,
			tipo,
			cd_sequencial_exame,
			nm_dentista_exame,
			qt_proc_exames,
			nr_orcamento,
			idade
		)
	SELECT DISTINCT
			c.cd_sequencial,
			dt_pericia,
			ass.cd_associado,
			c.cd_sequencial_dep,
			ass.nm_completo,
			ass.nu_matricula,
			dep.NM_DEPENDENTE,
			ass.CD_EMPRESA,
			e.NM_RAZSOC,
			c.cd_servico,
			s.NM_SERVICO,
			c.cd_UD,
			c.oclusal,
			c.distral,
			c.mesial,
			c.vestibular,
			c.lingual,
			NULL,
			c.CD_FUNCIONARIO,
			f.nm_empregado,
			fi.cd_filial,
			fi.nm_filial,
			c.nr_numero_lote,-- c.nr_autorizacao, 
			c.Status,
			tc.vl_servico,
			(CASE
					WHEN (  SELECT
									COUNT(0)
							FROM
									PLANO_SERVICO
							WHERE
									cd_servico = c.cd_servico
									AND cd_plano = dep.cd_plano)
						> 0
						OR c.Status = 6
						THEN
						CASE
								WHEN c.vl_pago_manual IS NOT NULL
									THEN
									c.vl_pago_manual --Valor informado manualmente
								ELSE
								CASE
										WHEN ISNULL(T10.RefAtualizacaoTabelaDentista, 1) = 1
											THEN --Última tabela

											CASE
													WHEN ISNULL(T10.LocalTabelaPagamentoDentista, 1) = 1
														THEN --Tabela por dentista

														CASE
																WHEN ISNULL(T10.TipoValorCalculoProdutividadeDentista, 1) = 1
																	THEN --Valor em R$
																	ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	))
																WHEN T10.TipoValorCalculoProdutividadeDentista = 2
																	THEN --Valor em US, convertido para R$
																	ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	))
														END
													WHEN T10.LocalTabelaPagamentoDentista = 2
														THEN --Tabela por clínica

														CASE
																WHEN ISNULL(T10.TipoValorCalculoProdutividadeDentista, 1) = 1
																	THEN --Valor em R$
																	ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	))
																WHEN T10.TipoValorCalculoProdutividadeDentista = 2
																	THEN --Valor em US, convertido para R$
																	ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																		ORDER BY
																				S2.dt_inicio DESC,
																				S2.cd_tabela_referencia DESC)
																	))
														END
											END
										WHEN T10.RefAtualizacaoTabelaDentista = 2
											THEN --Tabela por data de referência x data de realização do procedimento

											CASE
													WHEN ISNULL(T10.LocalTabelaPagamentoDentista, 1) = 1
														THEN --Tabela por dentista

														CASE
																WHEN ISNULL(T10.TipoValorCalculoProdutividadeDentista, 1) = 1
																	THEN --Valor em R$
																	ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	))
																WHEN T10.TipoValorCalculoProdutividadeDentista = 2
																	THEN --Valor em US, convertido para R$
																	ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = f.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	))
														END
													WHEN T10.LocalTabelaPagamentoDentista = 2
														THEN --Tabela por clínica

														CASE
																WHEN ISNULL(T10.TipoValorCalculoProdutividadeDentista, 1) = 1
																	THEN --Valor em R$
																	ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), ISNULL(ISNULL((SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), (SELECT TOP 1
																				C1.vl_servico
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	))
																WHEN T10.TipoValorCalculoProdutividadeDentista = 2
																	THEN --Valor em US, convertido para R$
																	ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_servico = s.cd_servico
																				AND C1.cd_plano IS NULL
																				AND C1.cd_especialidade IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), ISNULL(ISNULL((SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano = dep.cd_plano
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE())), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade = s.cd_especialidadereferencia
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	), (SELECT TOP 1
																				ROUND(C1.vl_servico * s.vl_us, 2)
																		FROM
																				tabela_servicos C1,
																				tabela_referencia S2
																		WHERE
																				C1.cd_tabela_referencia = S2.cd_tabela_referencia
																				AND C1.cd_tabela = fi.cd_tabela
																				AND C1.cd_especialidade IS NULL
																				AND C1.cd_plano IS NULL
																				AND C1.cd_servico IS NULL
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) >= S2.dt_inicio
																				AND CONVERT(DATE, ISNULL(c.dt_servico, GETDATE())) <= ISNULL(S2.dt_fim, GETDATE()))
																	))
														END
											END
										ELSE
										0
								END
						END
					ELSE
					NULL --Não coberto (preço não definido)
			END)											 vl_servico,
			NULL,
			ISNULL(fi.ufId, 0)								 AS cdufFil,
			ISNULL(uff.ufSigla, 'XX')						 AS UfFil,
			ISNULL(fi.CidID, 0)								 AS cdCidFil,
			ISNULL(mf.NM_MUNICIPIO, 'Não Informado')		 AS CidFil,
			ISNULL(fi.BaiId, 0)								 AS CdBaiFil,
			ISNULL(bf.baiDescricao, 'Não Informado')		 AS BaiFil, -- Filial 
			ISNULL(ass.ufId, 0)								 AS cdufadd,
			ISNULL(ufa.ufSigla, 'XX')						 AS UfAss,
			ISNULL(ass.CidID, 0)							 AS cdCidAss,
			ISNULL(ma.NM_MUNICIPIO, 'Não Informado')		 AS CidAss,
			ISNULL(ass.BaiId, 0)							 AS cdBaiAss,
			ISNULL(ba.baiDescricao, 'Não Informado')		 AS BaiAss, -- Associados 
			ISNULL(s.cd_especialidadereferencia, 0)			 AS CdEsp,
			ISNULL(esp.nm_especialidade, 'Não Especificado') AS Especialidade,
			YEAR(CASE
					WHEN dt_pericia IS NULL
						THEN
						c.dt_cadastro
					ELSE
					dt_pericia
			END),
			MONTH(CASE
					WHEN dt_pericia IS NULL
						THEN
						c.dt_cadastro
					ELSE
					dt_pericia
			END),
			0,
			'A Executar',
			c.cd_sequencial_exame,
			CASE
					WHEN c.cd_sequencial_exame IS NULL
						THEN
						f.nm_empregado
					ELSE
					(   SELECT
								f1.nm_empregado
						FROM
								Consultas AS c1,
								FUNCIONARIO AS f1
						WHERE
								c1.cd_sequencial = c.cd_sequencial_exame
								AND c1.CD_FUNCIONARIO = f1.CD_FUNCIONARIO)
			END,
			0,
			CASE
					WHEN os.cd_orcamento IS NULL
						THEN
						0
					ELSE
					1
			END,
			dbo.FS_Idade(dep.dt_nascimento, GETDATE())
	FROM
			Consultas c
		INNER JOIN
			SERVICO s
				ON c.cd_servico = s.cd_servico
		INNER JOIN
			FILIAL fi
				ON c.cd_filial = fi.cd_filial
		INNER JOIN
			FUNCIONARIO f
				ON c.CD_FUNCIONARIO = f.CD_FUNCIONARIO
		INNER JOIN
			DEPENDENTES dep
				ON c.cd_sequencial = dep.cd_sequencial
		INNER JOIN
			HISTORICO h
				ON dep.CD_Sequencial_historico = h.cd_sequencial
		INNER JOIN
			SITUACAO_HISTORICO sh
				ON h.cd_situacao = sh.CD_SITUACAO_HISTORICO
					AND sh.fl_atendido_clinica = 1
		INNER JOIN
			ASSOCIADOS ass
				ON dep.cd_associado = ass.cd_associado
		INNER JOIN
			EMPRESA e
				ON ass.CD_EMPRESA = e.CD_EMPRESA
		LEFT JOIN
			orcamento_servico os
				ON c.cd_sequencial = os.cd_sequencial_pp
		INNER JOIN
			TIPO_PAGAMENTO t
				ON e.CD_TIPO_PAGAMENTO = t.CD_TIPO_PAGAMENTO
		LEFT JOIN
			tabela_servicos tc
				ON t.cd_tabela = tc.cd_tabela
					AND c.cd_servico = tc.cd_servico
		INNER JOIN
			Especialidade esp
				ON s.cd_especialidadereferencia = esp.cd_especialidade
		INNER JOIN
			DEPENDENTES dep1
				ON dep.cd_associado = dep1.cd_associado
		INNER JOIN
			HISTORICO h1
				ON dep1.CD_Sequencial_historico = h1.cd_sequencial
		INNER JOIN
			SITUACAO_HISTORICO sh1
				ON h1.cd_situacao = sh1.CD_SITUACAO_HISTORICO
					AND sh1.fl_atendido_clinica = 1
		INNER JOIN
			HISTORICO h2
				ON e.CD_Sequencial_historico = h2.cd_sequencial
		INNER JOIN
			SITUACAO_HISTORICO sh2
				ON h2.cd_situacao = sh2.CD_SITUACAO_HISTORICO
					AND sh2.fl_atendido_clinica = 1
		LEFT JOIN
			UF ufa
				ON ass.ufId = ufa.ufId
		LEFT JOIN
			MUNICIPIO ma
				ON ass.CidID = ma.cd_municipio
		LEFT JOIN
			Bairro ba
				ON ass.BaiId = ba.BaiId
		LEFT JOIN
			UF uff
				ON fi.ufId = uff.ufId
		LEFT JOIN
			MUNICIPIO mf
				ON fi.CidID = mf.cd_municipio
		LEFT JOIN
			Bairro bf
				ON fi.BaiId = bf.BaiId
		CROSS JOIN
			Configuracao T10

	--   consultas as C, servico as S, 
	--     filial as FI, funcionario as F, 
	--     dependentes as DEP, associados as ASS , empresa as e, historico as h, SITUACAO_HISTORICO as sh /* Historico do Dependente */, 
	--     dependentes as DEP1 , historico as h1, SITUACAO_HISTORICO as sh1 /* Historico do Titular */, 
	--     historico as h2, SITUACAO_HISTORICO as sh2 /* Historico do Empresa */, 
	--     tipo_pagamento T, tabela_servicos TC , -- Custo do Cliente
	--     --tabela_servicos TE , -- produtividade
	--     ESPECIALIDADE as esp ,orcamento_servico as OS,
	--     uf as ufF, MUNICIPIO as mF, Bairro as bF, 
	--     uf as ufA, MUNICIPIO as mA, Bairro as bA,
	--     Configuracao T10
	WHERE
			--C.cd_servico = S.cd_servico 
			--     and C.cd_filial = FI.cd_filial 
			--     and C.cd_funcionario = F.cd_funcionario 
			--     and C.cd_sequencial_dep = DEP.cd_sequencial 
			--     and dep.CD_Sequencial_historico = h.cd_sequencial 
			--     and h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and sh.fl_atendido_clinica=1 
			--     and DEP.cd_associado =  ASS.cd_associado
			--     and ass.cd_empresa = e.cd_empresa 
			--     and c.cd_Sequencial *= OS.cd_sequencial_PP and
			c.Status IN (2, 6, 7)
			AND c.dt_servico IS NULL
			--and F.cd_tabela  *= TE.cd_tabela and C.cd_servico *=TE.cd_servico 
			AND e.CD_TIPO_PAGAMENTO = t.CD_TIPO_PAGAMENTO
			--and T.cd_tabela *= TC.cd_tabela and C.cd_servico *=TC.cd_servico 
			AND s.cd_especialidadereferencia = esp.cd_especialidade

			--and dep.CD_ASSOCIADO = dep1.cd_associado 
			AND dep1.cd_grau_parentesco = 1
			--and dep1.cd_sequencial_historico = h1.cd_sequencial 
			--and h1.cd_situacao = sh1.cd_situacao_historico 
			AND sh1.fl_atendido_clinica = 1

			--and e.CD_Sequencial_historico=h2.cd_sequencial 
			--and h2.CD_SITUACAO= sh2.CD_SITUACAO_HISTORICO 
			--and sh2.fl_atendido_clinica=1 

			--and Ass.ufId *= ufA.ufId 
			--and ass.CidID *= mA.CD_MUNICIPIO 
			--and ass.BaiId *= bA.baiId 

			--and FI.ufId *= ufF.ufId 
			--and FI.CidID *= mF.CD_MUNICIPIO 
			--and FI.BaiId *= bF.baiId 

			AND fl_ContagemBaixaAgenda = 1
			AND fl_ApresentaProdutividade = 1
END
