/****** Object:  Procedure [dbo].[PS_UltimosLancamentoPrevisto]    Committed by VersionSQL https://www.versionsql.com ******/

/* 
 
    <alt>alteração</alt>
    <doc>
        <titulo>Colocar título</titulo>
        <descricao>motivo</descricao>
        <chamado>chamado ##</chamado>
    </doc>
 
*/
CREATE PROCEDURE [dbo].[PS_UltimosLancamentoPrevisto] (
	@Sequencial_Movimentacao INT,
	@Sequencial_Historico INT
	)
AS
BEGIN
	SELECT TOP (10) T10.Sequencial_Lancamento,
		T10.Tipo_Lancamento,
		t1.Data_Documento,
		'<A href=# onclick="MM_openBrWindow(''ConsultaDadosGerais2.aspx?Contalancamento=2&SequencialFormaLancamento=' + CONVERT(VARCHAR, t1.Sequencial_FormaLancamento) + ''',''mailto'',''width=550,height=500,scrollbars=yes,toolbar=no,location=no,status=no,menubar=no,resizable=no,left=50,top=100'');return false;">' + T10.Historico + '</A>' AS Historico,
		CONVERT(VARCHAR, t1.Data_Documento, 103) AS Data_Documento1,
		'Não pode realizar' AS Realizar,
		t2.Descricao + ' ' + ISNULL(T5.Descricao_Car, '') AS Forma,
		CASE IsNull(CONVERT(VARCHAR, t10.cd_associado), '0') + IsNull(CONVERT(VARCHAR, t10.cd_sequencial), '0') + IsNull(CONVERT(VARCHAR, t10.cd_fornecedor), '0') + IsNull(CONVERT(VARCHAR, t10.cd_dentista), '0') + IsNull(CONVERT(VARCHAR, T10.cd_funcionario), '0') + IsNull(CONVERT(VARCHAR, T10.cd_associadoempresa), '0') + IsNull(T10.nome_outros, '0')
			WHEN '0000000'
				THEN ''
			ELSE '<A href=#><IMG onclick="SF_Imprime(' + CONVERT(VARCHAR, isnull(t10.cd_associado, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_sequencial, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_fornecedor, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_funcionario, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_dentista, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_associadoempresa, 0)) + ',' + CONVERT(VARCHAR, T1.Sequencial_Lancamento) + ',' + CONVERT(VARCHAR, T10.tipo_lancamento) + ',' + CONVERT(VARCHAR, T1.forma_lancamento) + ',''' + isnull(Rtrim(t3.codigo_conta), '0') + ''');return false;"  src="../../img/icon_impressora.gif" border=0></A>'
			END AS Impressora,
		t3.Codigo_Conta + ' - ' + t3.Descricao_Conta AS codigo_conta,
		t1.Valor_Previsto,
		'<A href=#><IMG onclick=SF_Exclui(2,' + CONVERT(VARCHAR, t1.Sequencial_Lancamento) + ') src="../../img/icone_lixeira.gif" border=0></A>' AS Exclui,
		t6.Descricao_Movimentacao AS caixa
	FROM TB_FormaLancamento AS t1
	INNER JOIN TB_Lancamento AS T10 ON t1.Sequencial_Lancamento = T10.Sequencial_Lancamento
	INNER JOIN TB_ValorDominio AS t2 ON t1.Forma_Lancamento = t2.CodigoValorDominio
	INNER JOIN TB_Conta AS t3 ON T10.Sequencial_Conta = t3.Sequencial_Conta
	INNER JOIN TB_HistoricoMovimentacao AS T4 ON t1.Sequencial_Historico = T4.Sequencial_Historico
	LEFT OUTER JOIN TB_Cartao_Car AS T5 ON t1.SequencialCartao_Car = T5.SequencialCartao_Car
	INNER JOIN TB_MovimentacaoFinanceira AS t6 ON T4.Sequencial_Movimentacao = t6.Sequencial_Movimentacao
	WHERE (t2.CodigoDominio = 6)
		AND (T10.Data_HoraExclusao IS NULL)
		AND (t6.Sequencial_Movimentacao = @Sequencial_Movimentacao)
		AND (t1.Sequencial_Historico = @Sequencial_Historico)
	
	UNION
	
	SELECT TOP (10) T10.Sequencial_Lancamento,
		T10.Tipo_Lancamento,
		t1.Data_Documento,
		'<A href=# onclick="MM_openBrWindow(''ConsultaDadosGerais2.aspx?Contalancamento=2&SequencialFormaLancamento=' + CONVERT(VARCHAR, t1.Sequencial_FormaLancamento) + ''',''mailto'',''width=550,height=500,scrollbars=yes,toolbar=no,location=no,status=no,menubar=no,resizable=no,left=50,top=100'');return false;">' + T10.Historico + '</A>' AS Historico,
		CONVERT(VARCHAR, t1.Data_Documento, 103) AS Data_Documento1,
		'Não pode realizar' AS Realizar,
		t2.Descricao + ' ' + ISNULL(T5.Descricao_Car, '') AS Forma,
		CASE IsNull(CONVERT(VARCHAR, t10.cd_associado), '0') + IsNull(CONVERT(VARCHAR, t10.cd_sequencial), '0') + IsNull(CONVERT(VARCHAR, t10.cd_fornecedor), '0') + IsNull(CONVERT(VARCHAR, t10.cd_dentista), '0') + IsNull(CONVERT(VARCHAR, T10.cd_funcionario), '0') + IsNull(CONVERT(VARCHAR, T10.cd_associadoempresa), '0') + IsNull(T10.nome_outros, '0')
			WHEN '0000000'
				THEN ''
			ELSE '<A href=#><IMG onclick="SF_Imprime(' + CONVERT(VARCHAR, isnull(t10.cd_associado, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_sequencial, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_fornecedor, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_funcionario, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_dentista, 0)) + ',' + CONVERT(VARCHAR, isnull(t10.cd_associadoempresa, 0)) + ',' + CONVERT(VARCHAR, T1.Sequencial_Lancamento) + ',' + CONVERT(VARCHAR, T10.tipo_lancamento) + ',' + CONVERT(VARCHAR, T1.forma_lancamento) + ',''' + isnull(Rtrim(t3.codigo_conta), '0') + ''');return false;"  src="../../img/icon_impressora.gif" border=0></A>'
			END AS Impressora,
		t3.Codigo_Conta + ' - ' + t3.Descricao_Conta AS codigo_conta,
		t1.Valor_Previsto,
		'<A href=#><IMG onclick=SF_Exclui(2,' + CONVERT(VARCHAR, t1.Sequencial_Lancamento) + ') src="../../img/icone_lixeira.gif" border=0></A>' AS Exclui,
		t6.Descricao_Movimentacao AS caixa
	FROM TB_FormaLancamento AS t1
	INNER JOIN TB_Lancamento AS T10 ON t1.Sequencial_Lancamento = T10.Sequencial_Lancamento
	INNER JOIN TB_ValorDominio AS t2 ON t1.Forma_Lancamento = t2.CodigoValorDominio
	INNER JOIN TB_Conta AS t3 ON T10.Sequencial_Conta = t3.Sequencial_Conta
	INNER JOIN TB_HistoricoMovimentacao AS T4 ON t1.Sequencial_Historico = T4.Sequencial_Historico
		AND t1.Sequencial_Historico_Consulta = T4.Sequencial_Historico
	LEFT OUTER JOIN TB_Cartao_Car AS T5 ON t1.SequencialCartao_Car = T5.SequencialCartao_Car
	INNER JOIN TB_MovimentacaoFinanceira AS t6 ON T4.Sequencial_Movimentacao = t6.Sequencial_Movimentacao
	WHERE (t2.CodigoDominio = 6)
		AND (T10.Data_HoraExclusao IS NULL)
		AND (t6.Sequencial_Movimentacao = @Sequencial_Movimentacao)
		AND (t1.Sequencial_Historico_Consulta = @Sequencial_Historico)
	ORDER BY T10.Sequencial_Lancamento DESC
END
