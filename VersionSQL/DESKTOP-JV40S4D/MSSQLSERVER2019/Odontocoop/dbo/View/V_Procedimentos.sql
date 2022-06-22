/****** Object:  View [dbo].[V_Procedimentos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[V_Procedimentos]
AS
SELECT T2.dt_servico,
	T2.cd_sequencial,
	T1.nm_filial,
	T6.CD_ASSOCIADO,
	T2.cd_sequencial_dep,
	T2.dt_servico AS Data,
	T6.NM_DEPENDENTE,
	dbo.moeda(T4.vl_servico) AS vl_credenciado,
	T3.NM_SERVICO,
	'' AS aviso,
	T2.cd_servico,
	T2.cd_UD,
	(
		SELECT foto_digitalizada
		FROM TB_ConsultasDocumentacao AS t100
		WHERE (cd_sequencial = T2.cd_sequencial)
		) AS doc,
	dbo.FS_MostraFace(T2.cd_UD, T2.oclusal, T2.distral, T2.mesial, T2.vestibular, T2.lingual) AS faces,
	T2.CD_FUNCIONARIO,
	T2.cd_filial,
	T2.nr_procedimentoliberado,
	T8.STATUS,
	t9.NM_SITUACAO_HISTORICO,
	t9.fl_atendido_clinica,
	T5.cd_empresa,
	t9.CD_SITUACAO_HISTORICO,
	T2.nr_numero_lote,
	T1.cd_clinica,
	T2.STATUS AS Status_Consulta,
	T2.cd_sequencial_agenda,
	(
		SELECT ds_motivo
		FROM TB_ConsultasDocumentacao AS t100
		WHERE (cd_sequencial = T2.cd_sequencial)
		) AS ds_motivo,
	CONVERT(VARCHAR(10), T6.DT_NASCIMENTO, 103) AS dt_nascimento,
	DATEDIFF(year, T6.DT_NASCIMENTO, GETDATE()) AS idade,
	t10.vl_faixa,
	T2.cd_funcionario_analise,
	(
		SELECT COUNT(0) AS Expr1
		FROM orcamento_servico
		WHERE (cd_sequencial_pp = T2.cd_sequencial)
		) AS Orcamento,
	ISNULL(CONVERT(INT, T3.fl_ApresentaProdutividade), 0) AS fl_ApresentaProdutividade,
	0 AS sequencial_consultasglosados,
	(
		SELECT COUNT(0) AS Expr1
		FROM tabela_servicos
		WHERE (cd_tabela = T7.cd_tabela)
			AND (cd_servico = T2.cd_servico)
		) AS Cobertura
FROM tabela_servicos AS T4
INNER JOIN FILIAL AS T1
INNER JOIN Consultas AS T2 ON T1.cd_filial = T2.cd_filial
INNER JOIN FUNCIONARIO AS T7 ON T2.CD_FUNCIONARIO = T7.cd_funcionario
INNER JOIN SERVICO AS T3 ON T2.cd_servico = T3.CD_SERVICO ON T4.cd_tabela = T7.cd_tabela
	AND T4.cd_servico = T2.cd_servico INNER JOIN DEPENDENTES AS T6
INNER JOIN ASSOCIADOS AS T5 ON T6.CD_ASSOCIADO = T5.cd_associado ON T2.cd_sequencial_dep = T6.CD_SEQUENCIAL LEFT OUTER JOIN Inconsistencia_Consulta AS T8 ON T2.cd_sequencial = T8.cd_sequencial_consulta INNER JOIN HISTORICO AS t11 ON T6.CD_Sequencial_historico = t11.cd_sequencial INNER JOIN SITUACAO_HISTORICO AS t9 ON t11.CD_SITUACAO = t9.CD_SITUACAO_HISTORICO LEFT OUTER JOIN funcionario_faixa AS t10 ON T7.cd_faixa = t10.cd_faixa WHERE (T2.dt_servico IS NOT NULL)
	AND (T2.dt_cancelamento IS NULL)
	AND (
		T2.cd_sequencial NOT IN (
			SELECT cd_sequencial
			FROM TB_ConsultasGlosados AS t100
			WHERE (cd_sequencial = T2.cd_sequencial)
			)
		)

UNION

SELECT T2.dt_servico,
	T2.cd_sequencial,
	T1.nm_filial,
	T6.CD_ASSOCIADO,
	T2.cd_sequencial_dep,
	T2.dt_servico AS Data,
	T6.NM_DEPENDENTE,
	CASE T8.tipo
		WHEN 1
			THEN dbo.moeda(T4.vl_servico)
		WHEN 2
			THEN '0'
		END AS vl_credenciado,
	T3.NM_SERVICO,
	CASE T8.tipo
		WHEN 1
			THEN 'Glosa Troca Procedimento. Procedimento Antigo : <br>' + CONVERT(VARCHAR, t8.codigo_antigo_servico) + '-' + t8.descricao_antigo_servico + '<br> Motivo: ' + ISNULL(t13.mglDescricao, '') + '<br>' + T8.Descricao_Glosa
		WHEN 2
			THEN 'Glosa Total Procedimento' + '<br> Motivo: ' + ISNULL(t13.mglDescricao, '') + '<br>' + T8.Descricao_Glosa
		END AS aviso,
	T2.cd_servico,
	T2.cd_UD,
	(
		SELECT foto_digitalizada
		FROM TB_ConsultasDocumentacao AS t100
		WHERE (cd_sequencial = T2.cd_sequencial)
		) AS doc,
	dbo.FS_MostraFace(T2.cd_UD, T2.oclusal, T2.distral, T2.mesial, T2.vestibular, T2.lingual) AS faces,
	T2.CD_FUNCIONARIO,
	T2.cd_filial,
	T2.nr_procedimentoliberado,
	T9.STATUS,
	t10.NM_SITUACAO_HISTORICO,
	t10.fl_atendido_clinica,
	T5.cd_empresa,
	t10.CD_SITUACAO_HISTORICO,
	T2.nr_numero_lote,
	T1.cd_clinica,
	T2.STATUS AS Status_Consulta,
	T2.cd_sequencial_agenda,
	(
		SELECT ds_motivo
		FROM TB_ConsultasDocumentacao AS t100
		WHERE (cd_sequencial = T2.cd_sequencial)
		) AS ds_motivo,
	CONVERT(VARCHAR(10), T6.DT_NASCIMENTO, 103) AS dt_nascimento,
	DATEDIFF(year, T6.DT_NASCIMENTO, GETDATE()) AS idade,
	t11.vl_faixa,
	T2.cd_funcionario_analise,
	(
		SELECT COUNT(0) AS Expr1
		FROM orcamento_servico
		WHERE (cd_sequencial_pp = T2.cd_sequencial)
		) AS Orcamento,
	ISNULL(CONVERT(INT, T3.fl_ApresentaProdutividade), 0) AS fl_ApresentaProdutividade,
	T8.Sequencial_ConsultasGlosados,
	(
		SELECT COUNT(0) AS Expr1
		FROM tabela_servicos
		WHERE (cd_tabela = T7.cd_tabela)
			AND (cd_servico = T2.cd_servico)
		) AS Cobertura
FROM tabela_servicos AS T4
INNER JOIN FILIAL AS T1
INNER JOIN Consultas AS T2 ON T1.cd_filial = T2.cd_filial
INNER JOIN FUNCIONARIO AS T7 ON T2.CD_FUNCIONARIO = T7.cd_funcionario
INNER JOIN SERVICO AS T3 ON T2.cd_servico = T3.CD_SERVICO ON T4.cd_tabela = T7.cd_tabela
	AND T4.cd_servico = T2.cd_servico INNER JOIN DEPENDENTES AS T6
INNER JOIN ASSOCIADOS AS T5 ON T6.CD_ASSOCIADO = T5.cd_associado ON T2.cd_sequencial_dep = T6.CD_SEQUENCIAL INNER JOIN TB_ConsultasGlosados AS T8 ON T2.cd_sequencial = T8.cd_sequencial
	AND T2.cd_sequencial = T8.cd_sequencial INNER JOIN HISTORICO AS t12 ON T6.CD_Sequencial_historico = t12.cd_sequencial INNER JOIN SITUACAO_HISTORICO AS t10 ON t12.CD_SITUACAO = t10.CD_SITUACAO_HISTORICO LEFT OUTER JOIN Inconsistencia_Consulta AS T9 ON T2.cd_sequencial = T9.cd_sequencial_consulta LEFT OUTER JOIN MotivoGlosa AS t13 ON T8.mglId = t13.mglId LEFT OUTER JOIN funcionario_faixa AS t11 ON T7.cd_faixa = t11.cd_faixa WHERE (T2.dt_servico IS NOT NULL)
	AND (T2.dt_cancelamento IS NULL)
	AND (
		T2.cd_sequencial NOT IN (
			SELECT cd_sequencial_pp
			FROM orcamento_servico AS t100
			WHERE (T2.cd_sequencial = cd_sequencial_pp)
			)
		)

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[14] 4[21] 2[47] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_Procedimentos'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'V_Procedimentos'
