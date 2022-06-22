/****** Object:  Procedure [dbo].[SP_EncerrarCaixaAutomatico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_EncerrarCaixaAutomatico]
AS
BEGIN
	SET NOCOUNT ON;

Declare @valorFinal money
  Declare @Sequencial_Historico integer
  Declare @Usuario varchar(40)
  Declare @NmCaixa varchar(100)
  Declare @diasAberto integer
  Declare @DataLancamentoFinal DATETIME
    
  set @Usuario = '9717'

  DECLARE cursor_CaixasFechar CURSOR FOR  
		Select T1.Descricao_Movimentacao, T2.Sequencial_Historico, 
		DateDiff(day,Data_Hora_Abertura,getdate()) as dias_aberto,  
		(t2.Valor_Saldo_Inicial+(Select IsNull(Sum(T10.Valor_Lancamento),0) As SaldoRecebimento From TB_FormaLancamento T10, TB_Lancamento T20 Where T10.Sequencial_Lancamento = T20.Sequencial_Lancamento And T10.Tipo_ContaLancamento = 1 And T20.Tipo_Lancamento = 1 And T20.Data_HoraExclusao     is null And T10.Sequencial_Historico = T2.Sequencial_Historico)-(Select IsNull(Sum(T10.Valor_Lancamento),0) As SaldoPagamento From TB_FormaLancamento T10, TB_Lancamento T20 Where T10.Sequencial_Lancamento = T20.Sequencial_Lancamento And T10.Tipo_ContaLancamento = 1 And  t20.Tipo_Lancamento   = 2 And  T20.Data_HoraExclusao is null And    T10.Sequencial_Historico = T2.Sequencial_Historico)) Valor_SaldoAtual, 
		
		(Select case when max(T10.Data_pagamento) is null then convert(varchar(10),getdate(),101) else convert(varchar(10),max(T10.Data_pagamento),101) end Data_pagamentoFinal 
			From TB_FormaLancamento T10, TB_Lancamento T20 
			Where T10.Sequencial_Lancamento = T20.Sequencial_Lancamento And 
			T10.Tipo_ContaLancamento = 1 And  
			T20.Data_HoraExclusao is null And 
			T10.Sequencial_Historico = T2.Sequencial_Historico ) Data_pagamentoFinal
		
		From  TB_HistoricoMovimentacao T2, TB_MovimentacaoFinanceira T1 
		Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao 
		And T2.Data_Fechamento is Null 
		And T1.Movimentacao_Valida = 1 
		and t1.fecha_automatico is not null
		and DATEDIFF (HOUR , Data_Hora_Abertura , getdate() ) >= (t1.fecha_automatico * 24) - 1
		and T2.Sequencial_Movimentacao = T1.Sequencial_Movimentacao
		order by t2.Data_Hora_Abertura Asc 

	open cursor_CaixasFechar
	FETCH NEXT FROM cursor_CaixasFechar into @NmCaixa, @Sequencial_Historico, @diasAberto, @valorFinal, @DataLancamentoFinal
			WHILE (@@FETCH_STATUS <> -1)
				BEGIN
				
				print 'Caixa: ' + @NmCaixa
				print 'Dias Aberto: ' + convert(varchar(10),@diasAberto)
				print 'Valor Final: ' + convert(varchar(20), @valorFinal)
				print 'Data lanc Final'
				print @DataLancamentoFinal
				
				Execute PS_AbreFechaCaixa  @valorFinal, @Sequencial_Historico, @Usuario, @DataLancamentoFinal, @DataLancamentoFinal
								
				fetch next from cursor_CaixasFechar into @NmCaixa, @Sequencial_Historico, @diasAberto, @valorFinal, @DataLancamentoFinal
				END
	close cursor_CaixasFechar
	DEALLOCATE cursor_CaixasFechar

END
