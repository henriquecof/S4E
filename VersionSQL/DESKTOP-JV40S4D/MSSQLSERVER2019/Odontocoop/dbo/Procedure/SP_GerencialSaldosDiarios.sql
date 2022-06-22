/****** Object:  Procedure [dbo].[SP_GerencialSaldosDiarios]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_GerencialSaldosDiarios](
@dataInicial varchar(10),
@datafinal varchar(10),
@CentroCusto Varchar(500)
)
As
Begin

declare @Result Table( cd_centro_custo int)
declare @sql varchar(500)
Declare @CentroCustoI varchar(5)
Declare @CentroCustoF varchar(5)
   
--Centro de Custo
   If @CentroCusto = ''
     Begin
       Set @CentroCustoI = '1'
       Set @CentroCustoF = '99999'
       
       set @sql = 'select cd_centro_custo from Centro_Custo where cd_centro_custo >= ' + @CentroCustoI + ' and cd_centro_custo <= '+ @CentroCustoF + ''
	   insert into @Result exec (@sql)
     End
   Else
    Begin
       set @sql = 'select cd_centro_custo from Centro_Custo where cd_centro_custo in (' + @CentroCusto + ')'
	   insert into @Result exec (@sql)
     End
	   
	   
CREATE TABLE #relatorioEvolucao ( cd_centro_custo int, ds_Centro_Custo varchar(50), data varchar(10), dia_semana tinyint, recebidoRealizado money, recebidoPrevisto money, pagamentoRealizado money, pagamentoPrevisto money)
declare @dtIni as datetime = @dataInicial + ' 00:00:00'
declare @dtFin as datetime = @datafinal + ' 23:59:59'

declare @dtControlIni as datetime = @dtIni
declare @dtControlFin as datetime = DATEADD(SECOND, -1,DATEADD(day, 1,@dtIni))

while @dtControlIni <= @dtFin
begin

	Insert Into #relatorioEvolucao
	(cd_centro_custo, ds_Centro_Custo, data, dia_semana, recebidoRealizado, recebidoPrevisto, pagamentoRealizado, pagamentoPrevisto)
	Select  T7.cd_centro_custo, T7.ds_centro_custo, convert(varchar(10),case when t4.tipo_ContaLancamento = 1 then t4.data_pagamento else t4.data_documento end,103) as dt, datepart(dw,case when t4.tipo_ContaLancamento = 1 then t4.data_pagamento else t4.data_documento end),      
	  --Recebimento Realizado
	  sum (case when t3.Tipo_Lancamento = 1 and t4.tipo_ContaLancamento = 1 
				then T4.Valor_Lancamento else 0 end) recebidoRealizado,
				
	  --Recebimento Previsto
	  sum (case when t3.Tipo_Lancamento = 1 and t4.tipo_ContaLancamento = 2 
				then T4.Valor_Previsto else 0 end) recebidoPrevisto,
	  --Pagamento Realizado
	  sum (case when t3.Tipo_Lancamento = 2 and t4.tipo_ContaLancamento = 1 
				then T4.Valor_Lancamento else 0 end) pagamentoRealizado,
	  --Pagamento Previsto
	  sum (case when t3.Tipo_Lancamento = 2 and t4.tipo_ContaLancamento = 2 
				then T4.Valor_Previsto else 0 end) pagamentoPrevisto
				     
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6, Centro_Custo T7
		 Where  T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				T4.Sequencial_Historico    = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao = T6.Sequencial_Movimentacao And
				T6.cd_centro_custo = T7.cd_centro_custo and 
				T1.Tipo_Classificacao <> 6 and  
				--T6.cd_centro_custo in (1) and 
				--(case when @CentroCusto > -1 then T6.cd_centro_custo else -1 end) = @CentroCusto and
				T6.cd_centro_custo in (select cd_centro_custo from @Result) and

			 case when  T4.Tipo_ContaLancamento = 1 then T4.data_pagamento 
					 when  T4.Tipo_ContaLancamento = 2 then T4.data_documento 
				end >= @dtControlIni and
			 case when  T4.Tipo_ContaLancamento = 1 then T4.data_pagamento 
					 when  T4.Tipo_ContaLancamento = 2 then T4.data_documento 
				end < @dtControlFin 
	group by T7.cd_centro_custo, T7.ds_centro_custo, convert(varchar(10),case when t4.tipo_ContaLancamento = 1 then t4.data_pagamento else t4.data_documento end,103), datepart(dw,case when t4.tipo_ContaLancamento = 1 then t4.data_pagamento else t4.data_documento end)
	order by T7.ds_centro_custo
	
	set @dtControlIni = DATEADD(day, 1, @dtControlIni)
	set @dtControlFin = DATEADD(day, 1, @dtControlFin)
	
	print @dtControlIni 
	print @dtControlFin 
end

select cd_centro_custo, ds_Centro_Custo, data, dia_semana, recebidoRealizado, recebidoPrevisto, pagamentoRealizado, pagamentoPrevisto 
from #relatorioEvolucao

End 
