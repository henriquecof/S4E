/****** Object:  View [dbo].[VW_Lancamento_Visao]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE VIEW [dbo].[VW_Lancamento_Visao]
AS
SELECT T1.Sequencial_Lancamento, T1.Tipo_Lancamento, T1.Historico, T1.Sequencial_Conta, T2.Tipo_ContaLancamento, T2.Valor_Previsto, T2.Forma_Lancamento, T2.Data_Documento, 
T2.Data_HoraLancamento, T2.SequencialCartao_Car, T2.Sequencial_Historico, T2.Conta_PrevistaAparecer, T3.Sequencial_Movimentacao, T4.Descricao_Movimentacao, 1 AS PodeRealizar, 
T2.Sequencial_FormaLancamento, T1.cd_associado, T1.cd_sequencial, T1.cd_fornecedor, T1.cd_dentista, T1.cd_funcionario, T1.cd_associadoempresa, T1.nome_outros, 
T6.Descricao + ' ' + ISNULL(T5.Descricao_Car, '') AS Forma, NULL AS SequencialMovimentacaoConsulta, NULL AS Sequencial_Lancamento_Cheque, NULL Numero_Cheque, NULL 
Chave_Cheque, NULL AS Situacao_Cheque, T1.Sequencial_Aprazamento, T1.Conta_Alterada, T2.Origem_Cartao, T2.Data_Efetiva_Cartao, T2.DOC, T2.CODAUT, T2.CV, T2.Numero_Documento, 
t1.numero_NF, t1.cd_filial, T1.Sequencial_Lancamento_Origem, T13.Descricao_Movimentacao Descricao_MovimentacaoOrigem, T12.Valor_Saldo_Inicial SaldoInicialOrigem, CONVERT(varchar(10), 
isnull(T12.Data_Abertura, ''), 103) DataAberturaOrigem, t1.iss, t1.cofins, t1.csll, t1.ir, t1.pis, t1.ValorLiquido, CONVERT(int, T1.liberadoRealizacao) liberadoRealizacao, CONVERT(varchar(10), 
T1.dataLiberacao, 103) + ' ' + CONVERT(varchar(8), t1.dataLiberacao, 108) dataLiberacao, T1.motivoLiberacao, '(' + CONVERT(varchar(10), T14.cd_funcionario) 
+ ') ' + T14.nm_empregado nomeUsuarioLiberacao, T1.valorTotal, CASE WHEN T1.cd_fornecedor IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_fornecedor)
FROM fornecedores
WHERE cd_fornecedor = T1.cd_fornecedor) WHEN T1.cd_associado IS NOT NULL THEN
(SELECT nm_completo
FROM associados
WHERE cd_associado = T1.cd_associado) WHEN T1.cd_associadoempresa IS NOT NULL THEN
(SELECT nm_razsoc
FROM empresa
WHERE cd_empresa = T1.cd_associadoempresa) WHEN T1.cd_dentista IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_dentista) WHEN T1.cd_filial IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_razsoc)
FROM filial
WHERE cd_filial = T1.cd_filial) WHEN T1.cd_funcionario IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_funcionario) ELSE T1.nome_outros END UsuarioNominal
FROM dbo.TB_Lancamento AS T1 INNER JOIN
dbo.TB_FormaLancamento AS T2 ON T1.Sequencial_Lancamento = T2.Sequencial_Lancamento INNER JOIN
dbo.TB_HistoricoMovimentacao AS T3 ON T2.Sequencial_Historico = T3.Sequencial_Historico INNER JOIN
dbo.TB_MovimentacaoFinanceira AS T4 ON T3.Sequencial_Movimentacao = T4.Sequencial_Movimentacao LEFT OUTER JOIN
dbo.TB_Cartao_Car AS T5 ON T2.SequencialCartao_Car = T5.SequencialCartao_Car INNER JOIN
dbo.TB_ValorDominio AS T6 ON T2.Forma_Lancamento = T6.CodigoValorDominio LEFT JOIN
dbo.TB_Lancamento T10 ON T1.Sequencial_Lancamento_Origem = T10.Sequencial_Lancamento LEFT JOIN
dbo.TB_FormaLancamento AS T11 ON T10.Sequencial_Lancamento = T11.Sequencial_Lancamento LEFT JOIN
dbo.TB_HistoricoMovimentacao T12 ON T11.Sequencial_Historico = T12.Sequencial_Historico LEFT JOIN
dbo.TB_MovimentacaoFinanceira AS T13 ON T12.Sequencial_Movimentacao = T13.Sequencial_Movimentacao LEFT JOIN
dbo.Funcionario AS T14 ON T1.usuarioLiberacao = T14.cd_funcionario
WHERE (T2.Tipo_ContaLancamento = 2) AND (T1.Data_HoraExclusao IS NULL) AND (T6.CodigoDominio = 6) AND (T2.Forma_Lancamento <> 8) AND (T2.Sequencial_Historico_Consulta IS NULL)
UNION
SELECT T1.Sequencial_Lancamento, T1.Tipo_Lancamento, T1.Historico, T1.Sequencial_Conta, T2.Tipo_ContaLancamento, T2.Valor_Previsto, T2.Forma_Lancamento, T2.Data_Documento, 
T2.Data_HoraLancamento, T2.SequencialCartao_Car, T2.Sequencial_Historico_Consulta AS Sequencial_Historico, T2.Conta_PrevistaAparecer, T8.Sequencial_Movimentacao, 
T5.Descricao_Movimentacao, 0 AS PodeRealizar, T2.Sequencial_FormaLancamento, T1.cd_associado, T1.cd_sequencial, T1.cd_fornecedor, T1.cd_dentista, T1.cd_funcionario, 
T1.cd_associadoempresa, T1.nome_outros, T7.Descricao + ' ' + ISNULL(T6.Descricao_Car, '') AS Forma, T3.Sequencial_Movimentacao AS SequencialMovimentacaoConsulta, NULL 
AS Sequencial_Lancamento_Cheque, NULL Numero_Cheque, NULL Chave_Cheque, NULL AS Situacao_Cheque, T1.Sequencial_Aprazamento, T1.Conta_Alterada, T2.Origem_Cartao, 
T2.Data_Efetiva_Cartao, T2.DOC, T2.CODAUT, T2.CV, T2.Numero_Documento, t1.numero_NF, t1.cd_filial, T1.Sequencial_Lancamento_Origem, 
T13.Descricao_Movimentacao Descricao_MovimentacaoOrigem, T12.Valor_Saldo_Inicial SaldoInicialOrigem, CONVERT(varchar(10), isnull(T12.Data_Abertura, ''), 103) DataAberturaOrigem, t1.iss, 
t1.cofins, t1.csll, t1.ir, t1.pis, t1.ValorLiquido, CONVERT(int, T1.liberadoRealizacao) liberadoRealizacao, CONVERT(varchar(10), T1.dataLiberacao, 103) + ' ' + CONVERT(varchar(8), t1.dataLiberacao, 
108) dataLiberacao, T1.motivoLiberacao, '(' + CONVERT(varchar(10), T14.cd_funcionario) + ') ' + T14.nm_empregado nomeUsuarioLiberacao, T1.valorTotal, 
CASE WHEN T1.cd_fornecedor IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_fornecedor)
FROM fornecedores
WHERE cd_fornecedor = T1.cd_fornecedor) WHEN T1.cd_associado IS NOT NULL THEN
(SELECT nm_completo
FROM associados
WHERE cd_associado = T1.cd_associado) WHEN T1.cd_associadoempresa IS NOT NULL THEN
(SELECT nm_razsoc
FROM empresa
WHERE cd_empresa = T1.cd_associadoempresa) WHEN T1.cd_dentista IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_dentista) WHEN T1.cd_filial IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_razsoc)
FROM filial
WHERE cd_filial = T1.cd_filial) WHEN T1.cd_funcionario IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_funcionario) ELSE T1.nome_outros END UsuarioNominal
FROM dbo.TB_Lancamento AS T1 INNER JOIN
dbo.TB_FormaLancamento AS T2 ON T1.Sequencial_Lancamento = T2.Sequencial_Lancamento LEFT OUTER JOIN
dbo.TB_Cartao_Car AS T6 ON T2.SequencialCartao_Car = T6.SequencialCartao_Car INNER JOIN
dbo.TB_HistoricoMovimentacao AS T3 ON T2.Sequencial_Historico_Consulta = T3.Sequencial_Historico INNER JOIN
dbo.TB_MovimentacaoFinanceira AS T4 ON T3.Sequencial_Movimentacao = T4.Sequencial_Movimentacao INNER JOIN
dbo.TB_ValorDominio AS T7 ON T2.Forma_Lancamento = T7.CodigoValorDominio INNER JOIN
dbo.TB_HistoricoMovimentacao AS T8 ON T2.Sequencial_Historico = T8.Sequencial_Historico INNER JOIN
dbo.TB_MovimentacaoFinanceira AS T5 ON T8.Sequencial_Movimentacao = T5.Sequencial_Movimentacao LEFT JOIN
dbo.TB_Lancamento T10 ON T1.Sequencial_Lancamento_Origem = T10.Sequencial_Lancamento LEFT JOIN
dbo.TB_FormaLancamento AS T11 ON T10.Sequencial_Lancamento = T11.Sequencial_Lancamento LEFT JOIN
dbo.TB_HistoricoMovimentacao T12 ON T11.Sequencial_Historico = T12.Sequencial_Historico LEFT JOIN
dbo.TB_MovimentacaoFinanceira AS T13 ON T12.Sequencial_Movimentacao = T13.Sequencial_Movimentacao LEFT JOIN
dbo.Funcionario AS T14 ON T1.usuarioLiberacao = T14.cd_funcionario
WHERE (T2.Tipo_ContaLancamento = 2) AND (T1.Data_HoraExclusao IS NULL) AND (T7.CodigoDominio = 6) AND (T2.Forma_Lancamento <> 8)
UNION
SELECT T1.Sequencial_Lancamento, T1.Tipo_Lancamento, T1.Historico, T1.Sequencial_Conta, T2.Tipo_ContaLancamento, T2.Valor_Previsto, T2.Forma_Lancamento, T2.Data_Documento, 
T2.Data_HoraLancamento, NULL AS SequencialCartao_Car, T2.Sequencial_Historico, T2.Conta_PrevistaAparecer, T3.Sequencial_Movimentacao, T4.Descricao_Movimentacao, 1 AS PodeRealizar, 
T2.Sequencial_FormaLancamento, T1.cd_associado, T1.cd_sequencial, T1.cd_fornecedor, T1.cd_dentista, T1.cd_funcionario, T1.cd_associadoempresa, T1.nome_outros, 
T6.Descricao AS Forma, NULL AS SequencialMovimentacaoConsulta, T5.Sequencial_Lancamento_Cheque, T5.Numero_Cheque, T5.chave Chave_Cheque, T5.Situacao_Cheque, 
T1.Sequencial_Aprazamento, T1.Conta_Alterada, T2.Origem_Cartao, T2.Data_Efetiva_Cartao, T2.DOC, T2.CODAUT, T2.CV, T2.Numero_Documento, t1.numero_NF, t1.cd_filial, 
T1.Sequencial_Lancamento_Origem, T13.Descricao_Movimentacao Descricao_MovimentacaoOrigem, T12.Valor_Saldo_Inicial SaldoInicialOrigem, CONVERT(varchar(10), isnull(T12.Data_Abertura, 
''), 103) DataAberturaOrigem, t1.iss, t1.cofins, t1.csll, t1.ir, t1.pis, t1.ValorLiquido, CONVERT(int, T1.liberadoRealizacao) liberadoRealizacao, CONVERT(varchar(10), T1.dataLiberacao, 103) 
+ ' ' + CONVERT(varchar(8), t1.dataLiberacao, 108) dataLiberacao, T1.motivoLiberacao, '(' + CONVERT(varchar(10), T14.cd_funcionario) + ') ' + T14.nm_empregado nomeUsuarioLiberacao, 
T1.valorTotal, CASE WHEN T1.cd_fornecedor IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_fornecedor)
FROM fornecedores
WHERE cd_fornecedor = T1.cd_fornecedor) WHEN T1.cd_associado IS NOT NULL THEN
(SELECT nm_completo
FROM associados
WHERE cd_associado = T1.cd_associado) WHEN T1.cd_associadoempresa IS NOT NULL THEN
(SELECT nm_razsoc
FROM empresa
WHERE cd_empresa = T1.cd_associadoempresa) WHEN T1.cd_dentista IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_dentista) WHEN T1.cd_filial IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_razsoc)
FROM filial
WHERE cd_filial = T1.cd_filial) WHEN T1.cd_funcionario IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_funcionario) ELSE T1.nome_outros END UsuarioNominal
FROM dbo.TB_Lancamento AS T1 INNER JOIN
dbo.TB_FormaLancamento AS T2 ON T1.Sequencial_Lancamento = T2.Sequencial_Lancamento INNER JOIN
dbo.TB_HistoricoMovimentacao AS T3 ON T2.Sequencial_Historico = T3.Sequencial_Historico INNER JOIN
dbo.TB_MovimentacaoFinanceira AS T4 ON T3.Sequencial_Movimentacao = T4.Sequencial_Movimentacao INNER JOIN
dbo.TB_LancamentoCheque AS T5 ON T2.Sequencial_FormaLancamento = T5.Sequencial_FormaLancamento INNER JOIN
dbo.TB_ValorDominio AS T6 ON T5.Situacao_Cheque = T6.CodigoValorDominio LEFT JOIN
dbo.TB_Lancamento T10 ON T1.Sequencial_Lancamento_Origem = T10.Sequencial_Lancamento LEFT JOIN
dbo.TB_FormaLancamento AS T11 ON T10.Sequencial_Lancamento = T11.Sequencial_Lancamento LEFT JOIN
dbo.TB_HistoricoMovimentacao T12 ON T11.Sequencial_Historico = T12.Sequencial_Historico LEFT JOIN
dbo.TB_MovimentacaoFinanceira AS T13 ON T12.Sequencial_Movimentacao = T13.Sequencial_Movimentacao LEFT JOIN
dbo.Funcionario AS T14 ON T1.usuarioLiberacao = T14.cd_funcionario
WHERE (T1.Data_HoraExclusao IS NULL) AND (T2.Forma_Lancamento = 8) AND (T2.Tipo_ContaLancamento = 2) AND (T2.Sequencial_Historico_Consulta IS NULL) AND (T6.CodigoDominio = 7)
UNION
SELECT T1.Sequencial_Lancamento, T1.Tipo_Lancamento, T1.Historico, T1.Sequencial_Conta, T2.Tipo_ContaLancamento, T2.Valor_Previsto, T2.Forma_Lancamento, T2.Data_Documento, 
T2.Data_HoraLancamento, NULL AS SequencialCartao_Car, T2.Sequencial_Historico_Consulta AS Sequencial_Historico, T2.Conta_PrevistaAparecer, T8.Sequencial_Movimentacao, 
T5.Descricao_Movimentacao, 0 AS PodeRealizar, T2.Sequencial_FormaLancamento, T1.cd_associado, T1.cd_sequencial, T1.cd_fornecedor, T1.cd_dentista, T1.cd_funcionario, 
T1.cd_associadoempresa, T1.nome_outros, T7.Descricao AS Forma, T3.Sequencial_Movimentacao AS SequencialMovimentacaoConsulta, T6.Sequencial_Lancamento_Cheque, T6.Numero_Cheque, 
T6.chave Chave_Cheque, T6.Situacao_Cheque, T1.Sequencial_Aprazamento, T1.Conta_Alterada, T2.Origem_Cartao, T2.Data_Efetiva_Cartao, T2.DOC, T2.CODAUT, T2.CV, T2.Numero_Documento, 
t1.numero_NF, t1.cd_filial, T1.Sequencial_Lancamento_Origem, T13.Descricao_Movimentacao Descricao_MovimentacaoOrigem, T12.Valor_Saldo_Inicial SaldoInicialOrigem, CONVERT(varchar(10), 
isnull(T12.Data_Abertura, ''), 103) DataAberturaOrigem, t1.iss, t1.cofins, t1.csll, t1.ir, t1.pis, t1.ValorLiquido, CONVERT(int, T1.liberadoRealizacao) liberadoRealizacao, CONVERT(varchar(10), 
T1.dataLiberacao, 103) + ' ' + CONVERT(varchar(8), t1.dataLiberacao, 108) dataLiberacao, T1.motivoLiberacao, '(' + CONVERT(varchar(10), T14.cd_funcionario) 
+ ') ' + T14.nm_empregado nomeUsuarioLiberacao, T1.valorTotal, CASE WHEN T1.cd_fornecedor IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_fornecedor)
FROM fornecedores
WHERE cd_fornecedor = T1.cd_fornecedor) WHEN T1.cd_associado IS NOT NULL THEN
(SELECT nm_completo
FROM associados
WHERE cd_associado = T1.cd_associado) WHEN T1.cd_associadoempresa IS NOT NULL THEN
(SELECT nm_razsoc
FROM empresa
WHERE cd_empresa = T1.cd_associadoempresa) WHEN T1.cd_dentista IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_dentista) WHEN T1.cd_filial IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_razsoc)
FROM filial
WHERE cd_filial = T1.cd_filial) WHEN T1.cd_funcionario IS NOT NULL THEN
(SELECT isnull(nm_titular_cta, nm_empregado)
FROM funcionario
WHERE cd_funcionario = T1.cd_funcionario) ELSE T1.nome_outros END UsuarioNominal
FROM dbo.TB_Lancamento AS T1 INNER JOIN
dbo.TB_FormaLancamento AS T2 ON T1.Sequencial_Lancamento = T2.Sequencial_Lancamento INNER JOIN
dbo.TB_HistoricoMovimentacao AS T3 ON T2.Sequencial_Historico_Consulta = T3.Sequencial_Historico INNER JOIN
dbo.TB_LancamentoCheque AS T6 ON T2.Sequencial_FormaLancamento = T6.Sequencial_FormaLancamento INNER JOIN
dbo.TB_ValorDominio AS T7 ON T6.Situacao_Cheque = T7.CodigoValorDominio INNER JOIN
dbo.TB_HistoricoMovimentacao AS T8 ON T2.Sequencial_Historico = T8.Sequencial_Historico INNER JOIN
dbo.TB_MovimentacaoFinanceira AS T5 ON T8.Sequencial_Movimentacao = T5.Sequencial_Movimentacao LEFT JOIN
dbo.TB_Lancamento T10 ON T1.Sequencial_Lancamento_Origem = T10.Sequencial_Lancamento LEFT JOIN
dbo.TB_FormaLancamento AS T11 ON T10.Sequencial_Lancamento = T11.Sequencial_Lancamento LEFT JOIN
dbo.TB_HistoricoMovimentacao T12 ON T11.Sequencial_Historico = T12.Sequencial_Historico LEFT JOIN
dbo.TB_MovimentacaoFinanceira AS T13 ON T12.Sequencial_Movimentacao = T13.Sequencial_Movimentacao LEFT JOIN
dbo.Funcionario AS T14 ON T1.usuarioLiberacao = T14.cd_funcionario
WHERE (T1.Data_HoraExclusao IS NULL) AND (T2.Tipo_ContaLancamento = 2) AND (T2.Forma_Lancamento = 8) AND (T7.CodigoDominio = 7)

EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Configuration = "(H (4[30] 2[40] 3) )"
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
      ActivePaneConfig = 3
   End
   Begin DiagramPane = 
      PaneHidden = 
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Lancamento_Visao'
EXECUTE sys.sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = N'1', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'VW_Lancamento_Visao'
