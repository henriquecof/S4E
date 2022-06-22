/****** Object:  Procedure [dbo].[PS_DRE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DRE](
@Ano Varchar(4),
@CentroCusto Varchar(500)
)
As
Begin

---- O que precisa
--Nivel 1 - @DTI, @DTF, @CentroCusto(Não é obrigatorio), @SaldoInicial(Não é obrigatorio)

--------------------------------------------------------------------------------------
--Procedure que gera o Demonstrativo Fluxo Caixa
--Feito inicialmento : Marcio 
--Ultima Atualizações:
--Marcio   27/05/2015 Criação

--1. RECEITA BRUTA
--2. IMPOSTOS SOBRE A RECEITA
--3. DEDUÇÕES DA RECEITA
--4. RECEITA LÍQUIDA (1+2+3)
--5. CUSTOS DENTISTAS
--6. CUSTOS MATERIAIS
--7. CUSTOS DIVERSOS
--8. CUSTOS FRANQUIA
--9. RESULTADO BRUTO (4+5+6+7+8)
--10. DESPESAS COM PESSOAL
--11. DESPESAS ADMINISTRATIVAS
--12. DESPESAS COMERCIAIS
--13. RESULTADO OPERACIONAL - EBITDA (9+10+11+12)
--14. RESULTADO FINANCEIRO LÍQUIDO
--15. RESULTADO NÃO-OPERACIONAL
--16. IR E CSLL
--17. RESULTADO LIQUIDO OPERACIONAL (13+14+15+16)
--18. DEPRECIAÇÃO E AMORTIZAÇÃO
--19. RESULTADO LIQUIDO FINAL (17+18)
		--1+2+3+5+6+7+8+10+11+12+14+15+16
--Codigos Tabela Dominio
--1. RECEITA BRUTA
--2. IMPOSTOS SOBRE A RECEITA
--3. DEDUÇÕES DA RECEITA
--5. CUSTOS DENTISTAS
--6. CUSTOS MATERIAIS
--7. CUSTOS DIVERSOS
--8. CUSTOS FRANQUIA
--10. DESPESAS COM PESSOAL
--11. DESPESAS ADMINISTRATIVAS
--12. DESPESAS COMERCIAIS
--14. RESULTADO FINANCEIRO LÍQUIDO
--15. RESULTADO NÃO-OPERACIONAL
--16. IR E CSLL
--18. DEPRECIAÇÃO E AMORTIZAÇÃO
-----------------------------------------------------------------------------------------------------
-- Conta Mae : tipo_conta : 1 - Receita, 2-Despesa 

   ----------Declaração de Variaveis---------------------------------------------------------------
   Declare @CentroCustoI              Int
   Declare @CentroCustoF              Int
   Declare @DTI Varchar(10)
   Declare @DTF Varchar(10)
   set @DTI = @Ano + '-01-01 00:00:00'
   select @DTF = convert(varchar(10),dbo.UltimaDataMes(@DTI, 0),102)
  
   Declare @ReceitaBruta              Decimal(12,2)
   Declare @ImpostoReceita            Decimal(12,2)
   Declare @DeducaoReceita            Decimal(12,2)
   Declare @ReceitaLiquida            Decimal(12,2)
   
   Declare @CustosDentistas           Decimal(12,2)
   Declare @CustosMateriais           Decimal(12,2)
   Declare @CustosDiversos            Decimal(12,2)
   Declare @CustosFranquia            Decimal(12,2)   
   Declare @ResultadoBruto            Decimal(12,2)
   
   Declare @DespesasComPessoal        Decimal(12,2)
   Declare @DespesasAdministrativas   Decimal(12,2)
   Declare @DespesasComerciais        Decimal(12,2)
   Declare @ResultadoOperacional      Decimal(12,2)
   Declare @ResultadoFinanceiroLiq    Decimal(12,2)
   Declare @ResultadoNaoOperacional   Decimal(12,2)
   Declare @IR_CSLL                   Decimal(12,2)
   Declare @ResultadoLiqOperacional   Decimal(12,2)
   Declare @DepreciacaoAmortizacao    Decimal(12,2)
   Declare @ResultadoLiquiadoFinal    Decimal(12,2) 
 
   declare @Result Table( cd_centro_custo int)
   declare @sql varchar(500)
   
   declare @RelatorioDRE Table( CodigoFluxoCaixa int,DescricaoFluxoCaixa Varchar(300), 
								ValorFluxoJan Decimal(12,2), 
								ValorFluxoFev Decimal(12,2), 
								ValorFluxoMar Decimal(12,2), 
								ValorFluxoAbr Decimal(12,2), 
								ValorFluxoMai Decimal(12,2), 
								ValorFluxoJun Decimal(12,2), 
								ValorFluxoJul Decimal(12,2), 
								ValorFluxoAgo Decimal(12,2), 
								ValorFluxoSet Decimal(12,2), 
								ValorFluxoOut Decimal(12,2), 
								ValorFluxoNov Decimal(12,2), 
								ValorFluxoDez Decimal(12,2), 
								FluxoCaixa int)
   --Centro de Custo
   If @CentroCusto = ''
     Begin
       Set @CentroCustoI = 1
       Set @CentroCustoF = 99999
       
       set @sql = 'select cd_centro_custo from Centro_Custo where cd_centro_custo >= ' + @CentroCustoI + ' and cd_centro_custo <= '+ @CentroCustoF + ''
	   insert into @Result exec (@sql)
     End
   Else
    Begin
       set @sql = 'select cd_centro_custo from Centro_Custo where cd_centro_custo in (' + @CentroCusto + ')'
	   insert into @Result exec (@sql)
     End

--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--NIVEL 1
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--If @Nivel = 1
--Begin

   Set @ReceitaBruta              = 0
   Set @ImpostoReceita            = 0
   Set @DeducaoReceita            = 0
   Set @ReceitaLiquida            = 0
   Set @CustosDentistas           = 0
   Set @CustosMateriais           = 0
   Set @CustosDiversos            = 0
   Set @CustosFranquia            = 0
   Set @ResultadoBruto            = 0
   Set @DespesasComPessoal        = 0
   Set @DespesasAdministrativas   = 0
   Set @DespesasComerciais        = 0
   Set @ResultadoOperacional      = 0
   Set @ResultadoFinanceiroLiq    = 0
   Set @ResultadoNaoOperacional   = 0
   Set @IR_CSLL                   = 0
   Set @ResultadoLiqOperacional   = 0
   Set @DepreciacaoAmortizacao    = 0
   Set @ResultadoLiquiadoFinal    = 0
   
   ----------Corpo Programa--------------------------------------------------------------------------
    
   -- Receita Bruta 
   Select @ReceitaBruta =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 1 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
   
      
    -- Imposto Receita
   Select @ImpostoReceita = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 2 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   -- Dedução Receita
   Select @DeducaoReceita = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 3 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   --Receita Liquida
   Set @ReceitaLiquida = @RECEITABRUTA + @ImpostoReceita + @DEDUCAORECEITA
/*****************************************************************************************************************/            
           
   -- Custos Dentistas         
   Select @CustosDentistas = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 5 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T6.cd_centro_custo in (select cd_centro_custo from @Result)           
     
   -- Custos Materiais         
   Select @CustosMateriais = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 6 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T6.cd_centro_custo in (select cd_centro_custo from @Result)            
            
   -- Custos Diversos        
   Select @CustosDiversos = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 7 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   -- Custos Franquia        
   Select @CustosFranquia = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 8 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
   --Resultado Bruto
   Set @ResultadoBruto = @ReceitaLiquida + @CustosDentistas + @CustosMateriais + @CustosDiversos + @CustosFranquia
  /*****************************************************************************************************************/
   
   -- Despesas Com Pessoal        
   Select @DespesasComPessoal = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 10 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   -- Despesas Administrativas        
   Select @DespesasAdministrativas = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 11 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
   -- Despesas Comerciais        
   Select @DespesasComerciais = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 12 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            

   -- Resultado Operacional   
   Set @ResultadoOperacional = @ResultadoBruto + @DespesasComPessoal + @DespesasAdministrativas + @DespesasComerciais
 /*****************************************************************************************************************/
 
 
   -- Resultado Financeiro Líquido        
   Select @ResultadoFinanceiroLiq = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 14 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   -- Resultado Nao Operacional        
   Select @ResultadoNaoOperacional = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 15 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
            
   -- IR E CSLL        
   Select @IR_CSLL = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 16 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
    -- Resultado Líquido Operacional   
   Set @ResultadoLiqOperacional = @ResultadoOperacional + @ResultadoFinanceiroLiq + @ResultadoNaoOperacional + @IR_CSLL
 /*****************************************************************************************************************/
    
    -- DEPRECIAÇÃO E AMORTIZAÇÃO       
   Select @DepreciacaoAmortizacao = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE = 18 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
            Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
    -- Resultado Líquido Operacional   
   Set @ResultadoLiquiadoFinal = @ResultadoLiqOperacional + @DepreciacaoAmortizacao
 /*****************************************************************************************************************/
   
  
  --------------------------VALORES------------------------------------------------------------
  insert into @RelatorioDRE (CodigoFluxoCaixa, DescricaoFluxoCaixa, ValorFluxoJan, FluxoCaixa)
  Select 1 CodigoFluxoCaixa,'1. RECEITA BRUTA' DescricaoFluxoCaixa, CONVERT(VARCHAR,@ReceitaBruta) ValorFluxo, 1 as FluxoCaixa
  union
  Select 2,'2. IMPOSTOS SOBRE A RECEITA' , CONVERT(VARCHAR,@ImpostoReceita),2
  union
  Select 3,'3. DEDUÇÕES DA RECEITA' , CONVERT(VARCHAR,@DeducaoReceita), 3
  union
  Select 4,'4. RECEITA LÍQUIDA' , CONVERT(VARCHAR,@ReceitaLiquida),0
  union
  Select 5,'5. CUSTOS DENTISTAS' , CONVERT(VARCHAR,@CustosDentistas),5
  union
  Select 6,'6. CUSTOS MATERIAIS' , CONVERT(VARCHAR,@CustosMateriais),6
  union
  Select 7,'7. CUSTOS DIVERSOS' , CONVERT(VARCHAR,@CustosDiversos),7
  union
  Select 8,'8. CUSTOS FRANQUIA' , CONVERT(VARCHAR,@CustosFranquia),8
  union
  Select 9,'9. RESULTADO BRUTO' , CONVERT(VARCHAR,@ResultadoBruto),0
  union
  Select 10,'10. DESPESAS COM PESSOAL' , CONVERT(VARCHAR,@DespesasComPessoal),10
  union
  Select 11,'11. DESPESAS ADMINISTRATIVAS' , CONVERT(VARCHAR,@DespesasAdministrativas),11
  union
  Select 12,'12. DESPESAS COMERCIAIS' , CONVERT(VARCHAR,@DespesasComerciais),12
  union
  Select 13,'13. RESULTADO OPERACIONAL - EBITDA' , CONVERT(VARCHAR,@ResultadoOperacional),0
  union
  Select 14,'14. RESULTADO FINANCEIRO LÍQUIDO' , CONVERT(VARCHAR,@ResultadoFinanceiroLiq),14
  union
  Select 15,'15. RESULTADO NÃO-OPERACIONAL' , CONVERT(VARCHAR,@ResultadoNaoOperacional),15
  union
  Select 16,'16. IR E CSLL' , CONVERT(VARCHAR,@IR_CSLL),16
  union
  Select 17,'17. RESULTADO LIQUIDO OPERACIONAL' , CONVERT(VARCHAR,@ResultadoLiqOperacional),17
  union
  Select 18,'18. DEPRECIAÇÃO E AMORTIZAÇÃO' , CONVERT(VARCHAR,@DepreciacaoAmortizacao),18
  union
  Select 19,'19. RESULTADO LIQUIDO FINAL' , CONVERT(VARCHAR,@ResultadoLiquiadoFinal),0;
  --order by 1 
--End

	DECLARE @I INT
	SET @I = 1
	WHILE @I < 12
	BEGIN
		Print @I
		set @DTI = convert(varchar(10),dateadd(m, 1, convert(datetime, @DTI)),102)
		select @DTF = convert(varchar(10),dbo.UltimaDataMes(@DTI, 0),102)
		print '@DTI: ' + @DTI
		print '@DTF: ' + @DTF
		
		/*****************************************************************************************************************/            
	   Set @ReceitaBruta              = 0
	   Set @ImpostoReceita            = 0
	   Set @DeducaoReceita            = 0
	   Set @ReceitaLiquida            = 0
	   Set @CustosDentistas           = 0
	   Set @CustosMateriais           = 0
	   Set @CustosDiversos            = 0
	   Set @CustosFranquia            = 0
	   Set @ResultadoBruto            = 0
	   Set @DespesasComPessoal        = 0
	   Set @DespesasAdministrativas   = 0
	   Set @DespesasComerciais        = 0
	   Set @ResultadoOperacional      = 0
	   Set @ResultadoFinanceiroLiq    = 0
	   Set @ResultadoNaoOperacional   = 0
	   Set @IR_CSLL                   = 0
	   Set @ResultadoLiqOperacional   = 0
	   Set @DepreciacaoAmortizacao    = 0
	   Set @ResultadoLiquiadoFinal    = 0
	   
	   ----------Corpo Programa--------------------------------------------------------------------------
	   -- Receita Bruta 
	   Select @ReceitaBruta =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 1 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
	            
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	   
	      
		-- Imposto Receita
	   Select @ImpostoReceita = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 2 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   -- Dedução Receita
	   Select @DeducaoReceita = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 3 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   --Receita Liquida
	   Set @ReceitaLiquida = @RECEITABRUTA + @ImpostoReceita + @DEDUCAORECEITA
	/*****************************************************************************************************************/            
	           
	   -- Custos Dentistas         
	   Select @CustosDentistas = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 5 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T6.cd_centro_custo in (select cd_centro_custo from @Result)           
	     
	   -- Custos Materiais         
	   Select @CustosMateriais = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 6 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T6.cd_centro_custo in (select cd_centro_custo from @Result)            
	            
	   -- Custos Diversos        
	   Select @CustosDiversos = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 7 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   -- Custos Franquia        
	   Select @CustosFranquia = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 8 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	   --Resultado Bruto
	   Set @ResultadoBruto = @ReceitaLiquida + @CustosDentistas + @CustosMateriais + @CustosDiversos + @CustosFranquia
	  /*****************************************************************************************************************/
	   
	   -- Despesas Com Pessoal        
	   Select @DespesasComPessoal = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 10 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   -- Despesas Administrativas        
	   Select @DespesasAdministrativas = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 11 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	   -- Despesas Comerciais        
	   Select @DespesasComerciais = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 12 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            

	   -- Resultado Operacional   
	   Set @ResultadoOperacional = @ResultadoBruto + @DespesasComPessoal + @DespesasAdministrativas + @DespesasComerciais
	 /*****************************************************************************************************************/
	 
	 
	   -- Resultado Financeiro Líquido        
	   Select @ResultadoFinanceiroLiq = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 14 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   -- Resultado Nao Operacional        
	   Select @ResultadoNaoOperacional = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 15 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
	            
	   -- IR E CSLL        
	   Select @IR_CSLL = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 16 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
		-- Resultado Líquido Operacional   
	   Set @ResultadoLiqOperacional = @ResultadoOperacional + @ResultadoFinanceiroLiq + @ResultadoNaoOperacional + @IR_CSLL
	 /*****************************************************************************************************************/
	    
		-- DEPRECIAÇÃO E AMORTIZAÇÃO       
	   Select @DepreciacaoAmortizacao = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = 18 And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T6.cd_centro_custo in (select cd_centro_custo from @Result)
	            
		-- Resultado Líquido Operacional   
	   Set @ResultadoLiquiadoFinal = @ResultadoLiqOperacional + @DepreciacaoAmortizacao
	 /*****************************************************************************************************************/
	   
		
	    if @I+1 = 2
		Begin
			Print 'FEV'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoFEV = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
			  			  
		end
		if @I+1 = 3
		Begin
			Print 'MAR'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAR = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 4
		Begin
			Print 'ABR'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoABR = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 5
		Begin
			Print 'MAI'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoMAI = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 6
		Begin
			Print 'JUN'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUN = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 7
		Begin
			Print 'JUL'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoJUL = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 8
		Begin
			Print 'AGO'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoAGO = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 9
		Begin
			Print 'SET'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoSET = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 10
		Begin
			Print 'OUT'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoOUT = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 11
		Begin
			Print 'NOV'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoNOV = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		if @I+1 = 12
		Begin
			Print 'DEZ'
			--------------------------VALORES------------------------------------------------------------
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ReceitaBruta)
			  WHERE CodigoFluxoCaixa = 1;
			   
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ImpostoReceita)
			  WHERE CodigoFluxoCaixa = 2;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@DeducaoReceita)
			  WHERE CodigoFluxoCaixa = 3;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ReceitaLiquida)
			  WHERE CodigoFluxoCaixa = 4;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@CustosDentistas)
			  WHERE CodigoFluxoCaixa = 5;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@CustosMateriais)
			  WHERE CodigoFluxoCaixa = 6;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@CustosDiversos)
			  WHERE CodigoFluxoCaixa = 7;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@CustosFranquia)
			  WHERE CodigoFluxoCaixa = 8;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoBruto)
			  WHERE CodigoFluxoCaixa = 9;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@DespesasComPessoal)
			  WHERE CodigoFluxoCaixa = 10;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@DespesasAdministrativas)
			  WHERE CodigoFluxoCaixa = 11;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@DespesasComerciais)
			  WHERE CodigoFluxoCaixa = 12;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoOperacional)
			  WHERE CodigoFluxoCaixa = 13;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoFinanceiroLiq)
			  WHERE CodigoFluxoCaixa = 14;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoNaoOperacional)
			  WHERE CodigoFluxoCaixa = 15;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@IR_CSLL)
			  WHERE CodigoFluxoCaixa = 16;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoLiqOperacional)
			  WHERE CodigoFluxoCaixa = 17;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@DepreciacaoAmortizacao)
			  WHERE CodigoFluxoCaixa = 18;
			  
			  UPDATE @RelatorioDRE 
			  SET ValorFluxoDEZ = CONVERT(VARCHAR,@ResultadoLiquiadoFinal)
			  WHERE CodigoFluxoCaixa = 19;
		end
		SET @I = @I + 1
	END

	Select * From @RelatorioDRE
	order by 1
End
