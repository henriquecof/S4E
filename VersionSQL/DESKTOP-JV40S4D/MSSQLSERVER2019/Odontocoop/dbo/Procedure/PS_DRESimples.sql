/****** Object:  Procedure [dbo].[PS_DRESimples]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DRESimples](
@DTI Varchar(10),
@DTF Varchar(10),
@CentroCusto Varchar(100),
@SaldoInicial decimal(12,2),
@Nivel smallint,
@Codigo_FluxoCaixa smallint = 0,
@Sequencial_ContaMae int = 0,
@Sequencial_Conta int = 0,
@receita money = 0,
@valor_nivel money = 0, 
@TipoCaixa smallint = 0
)
As
Begin

---- O que precisa
--Nivel 1 - @DTI, @DTF, @CentroCusto(Não é obrigatorio), @SaldoInicial(Não é obrigatorio)
--Nivel 2 - @DTI, @DTF, @CentroCusto(Não é obrigatorio), @Codigo_FluxoCaixa (TB_CONTAMAE)
--Nivel 3 - @DTI, @DTF, @CentroCusto(Não é obrigatorio), @Sequencial_ContaMae (TB_CONTAMAE)
--Nivel 4 - @DTI, @DTF, @CentroCusto(Não é obrigatorio), @Sequencial_Conta (TB_CONTA)

--------------------------------------------------------------------------------------
--Procedure que gera o Demonstrativo Fluxo Caixa
--Feito inicialmento : Marcio 
--Ultima Atualizações:
-- Marcio   27/05/2015 Criação

--1. RECEITA BRUTA R$ 850,000.00 100% -
--2. DEDUÇÕES DA RECEITA -R$ 207,000.00 -24% -
--3. RECEITA LÍQUIDA (1-2) R$ 643,000.00 76% -
--4. CUSTOS -R$ 300,000.00 -35% -
--5. RESULTADO BRUTO (3-4) R$ 343,000.00 40% -
--6. DESPESAS  OPERACIONAIS -R$ 93,000.00 -11% -
--7. RESULTADO OPERACIONAL (5-6) R$ 250,000.00 29% -
--8. RESULTADO NÂO-OPERACIONAL R$ 3000,00
--9. RESULTADO LÍQUIDO (7+8) R$ 253,000.00 30% -
--10. INVESTIMENTOS -R$ 13,000.00 -2% -
--11. CAIXA OPERACIONAL LIVRE (9+10) R$ 240,000.00 28% -
--13. CAIXA GERAL LIVRE (11+12) R$ 240,062.00 28% -
--14. SALDO INICIAL (vem do saldo final do dia anterior ao solicitado no filtro) R$ 400,000.00 47% -
--15. SALDO FINAL (14+13) R$ 640,062.00 75% -

--Codigos Tabela Dominio
--13	1	RECEITA BRUTA	
--13	2	DEDUÇÕES DA RECEITA	
--13	3	CUSTOS	
--13	4	DESPESAS OPERACIONAIS	
--13	5	INVESTIMENTOS	
--13    6   RESULTADO NÂO-OPERACIONAL
--13    7   MOVIMENTACAO FINANCEIRA PATRIMONIAL
-----------------------------------------------------------------------------------------------------
-- Conta MAe : tipo_conta : 1 - Receita, 2-Despesa 

   ----------Declaração de Variaveis---------------------------------------------------------------
   Declare @CentroCustoI              varchar(5)
   Declare @CentroCustoF              varchar(5)
   Declare @ReceitaBruta              Decimal(12,2)
   Declare @DeducaoReceita            Decimal(12,2) 
   Declare @Custos                    Decimal(12,2)
   Declare @ReceitaLiquida            Decimal(12,2)
   Declare @ResultadoBruto            Decimal(12,2)
   Declare @DespesasOperacionais      Decimal(12,2)
   Declare @ResultadoOperacional      Decimal(12,2)
   Declare @ResultadoNaoOperacional   Decimal(12,2)
   Declare @ResultadoLiquiado         Decimal(12,2)
   Declare @Investimentos             Decimal(12,2)
   Declare @CaixaOperacionalLivre     Decimal(12,2)
   Declare @MovimentacaoFiananceiraPatrimonial Decimal(12,2)
   Declare @CaixaGeralLivre                    Decimal(12,2)
   Declare @SaldoFinal                         Decimal(12,2)
   
   Declare @ResultadoLiqOperacional   Decimal(12,2)
   Declare @DepreciacaoAmortizacao    Decimal(12,2)
 
 
 --------------------------------------------------------------------
 
   Declare @ReceitaBrutaCaixa              Decimal(12,2)
   Declare @DeducaoReceitaCaixa            Decimal(12,2) 
   Declare @CustosCaixa                    Decimal(12,2)
   Declare @ReceitaLiquidaCaixa            Decimal(12,2)
   Declare @ResultadoBrutoCaixa            Decimal(12,2)
   Declare @DespesasOperacionaisCaixa      Decimal(12,2)
   Declare @ResultadoOperacionalCaixa      Decimal(12,2)
   Declare @ResultadoNaoOperacionalCaixa   Decimal(12,2)
   Declare @ResultadoLiquiadoCaixa         Decimal(12,2)
   Declare @InvestimentosCaixa             Decimal(12,2)
   Declare @CaixaOperacionalLivreCaixa     Decimal(12,2)
   Declare @MovimentacaoFiananceiraPatrimonialCaixa Decimal(12,2)
   Declare @CaixaGeralLivreCaixa                    Decimal(12,2)
   Declare @SaldoFinalCaixa                         Decimal(12,2)
   Declare @SaldoInicialCaixa						Decimal(12,2)
   
   Declare @ResultadoLiqOperacionalCaixa   Decimal(12,2)
   Declare @DepreciacaoAmortizacaoCaixa    Decimal(12,2)
   
   Declare @ReceitaBrutaBanco              Decimal(12,2)
   Declare @DeducaoReceitaBanco            Decimal(12,2) 
   Declare @CustosBanco                    Decimal(12,2)
   Declare @ReceitaLiquidaBanco            Decimal(12,2)
   Declare @ResultadoBrutoBanco            Decimal(12,2)
   Declare @DespesasOperacionaisBanco      Decimal(12,2)
   Declare @ResultadoOperacionalBanco      Decimal(12,2)
   Declare @ResultadoNaoOperacionalBanco   Decimal(12,2)
   Declare @ResultadoLiquiadoBanco         Decimal(12,2)
   Declare @InvestimentosBanco             Decimal(12,2)
   Declare @CaixaOperacionalLivreBanco     Decimal(12,2)
   Declare @MovimentacaoFiananceiraPatrimonialBanco Decimal(12,2)
   Declare @CaixaGeralLivreBanco                    Decimal(12,2)
   Declare @SaldoFinalBanco                         Decimal(12,2)
   Declare @SaldoInicialBanco						Decimal(12,2)
   
   Declare @ResultadoLiqOperacionalBanco   Decimal(12,2)
   Declare @DepreciacaoAmortizacaoBanco    Decimal(12,2)
 
 --------------------------------------------------------------------
 
 
   declare @Result Table( cd_centro_custo int)
   declare @sql varchar(500)
   
   --Centro de Custo
   If @CentroCusto = ''
     Begin
       Set @CentroCustoI = '1'
       Set @CentroCustoF = '99999'

       print @CentroCustoF     
  
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
If @Nivel = 1
Begin

   Set @ReceitaBruta              = 0 
   Set @DeducaoReceita            = 0  
   Set @Custos                    = 0 
   Set @ReceitaLiquida            = 0 
   Set @ResultadoBruto            = 0 
   Set @DespesasOperacionais      = 0 
   Set @ResultadoOperacional      = 0 
   Set @ResultadoNaoOperacional   = 0 
   Set @ResultadoLiquiado         = 0 
   Set @Investimentos             = 0 
   Set @CaixaOperacionalLivre     = 0 
   Set @MovimentacaoFiananceiraPatrimonial = 0 
   Set @CaixaGeralLivre			  = 0 
   set @ResultadoLiqOperacional	  = 0
   set @DepreciacaoAmortizacao	  = 0
   
   -------------------------------------------------------------
   Set @ReceitaBrutaCaixa              = 0 
   Set @DeducaoReceitaCaixa            = 0  
   Set @CustosCaixa                    = 0 
   Set @ReceitaLiquidaCaixa            = 0 
   Set @ResultadoBrutoCaixa            = 0 
   Set @DespesasOperacionaisCaixa      = 0 
   Set @ResultadoOperacionalCaixa      = 0 
   Set @ResultadoNaoOperacionalCaixa   = 0 
   Set @ResultadoLiquiadoCaixa         = 0 
   Set @InvestimentosCaixa             = 0 
   Set @CaixaOperacionalLivreCaixa     = 0 
   Set @MovimentacaoFiananceiraPatrimonialCaixa = 0 
   Set @CaixaGeralLivreCaixa		   = 0 
   set @ResultadoLiqOperacionalCaixa   = 0
   set @DepreciacaoAmortizacaoCaixa	   = 0
   
   
   Set @ReceitaBrutaBanco              = 0 
   Set @DeducaoReceitaBanco            = 0  
   Set @CustosBanco                    = 0 
   Set @ReceitaLiquidaBanco            = 0 
   Set @ResultadoBrutoBanco            = 0 
   Set @DespesasOperacionaisBanco      = 0 
   Set @ResultadoOperacionalBanco      = 0 
   Set @ResultadoNaoOperacionalBanco   = 0 
   Set @ResultadoLiquiadoBanco         = 0 
   Set @InvestimentosBanco             = 0 
   Set @CaixaOperacionalLivreBanco     = 0 
   Set @MovimentacaoFiananceiraPatrimonialBanco = 0 
   Set @CaixaGeralLivreBanco           = 0    
   set @ResultadoLiqOperacionalBanco   = 0
   set @DepreciacaoAmortizacaoBanco	   = 0
   ---------------------------------------------------------------
   
   ----------Corpo Programa--------------------------------------------------------------------------
    
   -- Receita Bruta 
   Select @ReceitaBruta =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 1 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
   
   -- Receita BrutaCaixa 
   Select @ReceitaBrutaCaixa =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 1 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
            -- Receita BrutaBanco 
   Select @ReceitaBrutaBanco =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 1 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
   
   -- Dedução Receita
   Select @DeducaoReceita = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 2 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
           --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- Dedução ReceitaCaixa
   Select @DeducaoReceitaCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 2 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- Dedução ReceitaBanco
   Select @DeducaoReceitaBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 2 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)

            
   --Receita Liquida
   Set @ReceitaLiquida = @RECEITABRUTA + @DEDUCAORECEITA         
   Set @ReceitaLiquidaCaixa = @RECEITABRUTACaixa + @DEDUCAORECEITACaixa         
   Set @ReceitaLiquidaBanco = @RECEITABRUTABanco + @DEDUCAORECEITABanco         
           
   -- Custos         
   Select @Custos = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 3 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
                
   -- CustosCaixa         
   Select @CustosCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 3 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
        
   -- CustosBanco         
   Select @CustosBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 3 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
                      
                
   --Resultado Bruto
   Set @ResultadoBruto = @ReceitaLiquida + @Custos
   Set @ResultadoBrutoCaixa = @ReceitaLiquidaCaixa + @CustosCaixa
   Set @ResultadoBrutoBanco = @ReceitaLiquidaBanco + @CustosBanco
   
   -- Despesas Operacionais         
   Select @DespesasOperacionais = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 4 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- Despesas OperacionaisCaixa         
   Select @DespesasOperacionaisCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 4 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
   
   -- Despesas OperacionaisBanco        
   Select @DespesasOperacionaisBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 4 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)

   -- Resultado Operacional   
   Set @ResultadoOperacional = @ResultadoBruto + @DespesasOperacionais
   Set @ResultadoOperacionalCaixa = @ResultadoBrutoCaixa + @DespesasOperacionaisCaixa
   Set @ResultadoOperacionalBanco = @ResultadoBrutoBanco + @DespesasOperacionaisBanco
  
   -- Resultado Não Operacional         
   Select @ResultadoNaoOperacional = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 6 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
           --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result)  --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- Resultado Não OperacionalCaixa         
   Select @ResultadoNaoOperacionalCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 6 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
           --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result)  --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- Resultado Não OperacionalBanco         
   Select @ResultadoNaoOperacionalBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 6 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
            T2.cd_centro_custo in (select cd_centro_custo from @Result)  --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)



   -- Resultado Liquido   
   Set @ResultadoLiquiado = @ResultadoOperacional + @ResultadoNaoOperacional
   Set @ResultadoLiquiadoCaixa = @ResultadoOperacionalCaixa + @ResultadoNaoOperacionalCaixa
   Set @ResultadoLiquiadoBanco = @ResultadoOperacionalBanco + @ResultadoNaoOperacionalBanco
   
   -- Investimentos         
   Select @Investimentos = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 5 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)

   -- InvestimentosCaixa        
   Select @InvestimentosCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 5 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
   -- InvestimentosBanco         
   Select @InvestimentosBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 5 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)

   -- Caixa Operacional Livre         
   Select @CaixaOperacionalLivre = @ResultadoLiquiado + @Investimentos
   Select @CaixaOperacionalLivreCaixa = @ResultadoLiquiadoCaixa + @InvestimentosCaixa
   Select @CaixaOperacionalLivreBanco = @ResultadoLiquiadoBanco + @InvestimentosBanco
   
   -- Movimentacao Financeira e Patrimonial         
   Select @MovimentacaoFiananceiraPatrimonial = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 7 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
            
    -- Movimentacao Financeira e PatrimonialCaixa         
   Select @MovimentacaoFiananceiraPatrimonialCaixa = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 7 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
            
    -- Movimentacao Financeira e PatrimonialBanco         
   Select @MovimentacaoFiananceiraPatrimonialBanco = Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_FluxoCaixa = 7 And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            T6.Sequencial_Agencia is not null And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)

    -- Caixa Geral Livre
  Select @CaixaGeralLivre = @CaixaOperacionalLivre + @MovimentacaoFiananceiraPatrimonial
  Select @CaixaGeralLivreCaixa = @CaixaOperacionalLivreCaixa + @MovimentacaoFiananceiraPatrimonialCaixa
  Select @CaixaGeralLivreBanco = @CaixaOperacionalLivreBanco + @MovimentacaoFiananceiraPatrimonialBanco
  
  
  
   Select @ResultadoLiqOperacional =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE in (1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 14, 15, 16) And
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
   
   
    Select @ResultadoLiqOperacionalCaixa =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE in (1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 14, 15, 16) And
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
            T6.Sequencial_Agencia is null And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
  
   Select @ResultadoLiqOperacionalBanco =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
     From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Codigo_DRE in (1, 2, 3, 5, 6, 7, 8, 10, 11, 12, 14, 15, 16) And
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
            T6.Sequencial_Agencia is not null And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
            
   
   Select @DepreciacaoAmortizacao =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
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
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And            
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
  
  
   Select @DepreciacaoAmortizacaoCaixa =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
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
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            T6.Sequencial_Agencia is null And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
  

   Select @DepreciacaoAmortizacaoBanco =  Isnull(SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End),0)--Isnull(SUM(T4.Valor_Lancamento*case when t1.tipo_conta=1 then 1 else -1 End),0)
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
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            T6.Sequencial_Agencia is not null And
            T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T6.cd_centro_custo in (select cd_centro_custo from @Result)
  
  
  
  
  
  --- Saldo Inicial Caixa
  select @SaldoInicialCaixa = isnull(sum(valor_saldo_final),0) --,  @data Data   
  from tb_historicoMovimentacao as a ,    
  ( select t4.Sequencial_movimentacao, max(t5.Sequencial_historico) as Sequencial     
  from tb_MovimentacaoFinanceira T4  , tb_historicoMovimentacao t5     
  where t4.Sequencial_movimentacao = t5.Sequencial_movimentacao     
  and cd_centro_custo in (select cd_centro_custo from @Result)     
  and isnull(Movimentacao_Valida, 0) = 1     
  and t5.data_fechamento < @DTI 
  and t4.Sequencial_Agencia is null    
  group by t4.Sequencial_movimentacao  
  ) as x  
  where a.Sequencial_historico = x.Sequencial
  
    --- Saldo Inicial Banco
  select @SaldoInicialBanco = isnull(sum(valor_saldo_final),0) --,  @data Data   
  from tb_historicoMovimentacao as a ,    
  ( select t4.Sequencial_movimentacao, max(t5.Sequencial_historico) as Sequencial     
  from tb_MovimentacaoFinanceira T4  , tb_historicoMovimentacao t5     
  where t4.Sequencial_movimentacao = t5.Sequencial_movimentacao     
  and cd_centro_custo in (select cd_centro_custo from @Result)     
  and isnull(Movimentacao_Valida, 0) = 1     
  and t5.data_fechamento < @DTI 
  and t4.Sequencial_Agencia is not null    
  group by t4.Sequencial_movimentacao  
  ) as x  
  where a.Sequencial_historico = x.Sequencial
  
   -- Saldo Final
  Select @SaldoFinal = @CaixaGeralLivre  + @SaldoInicial
  Select @SaldoFinalCaixa = @CaixaGeralLivreCaixa  + @SaldoInicial
  Select @SaldoFinalBanco = @CaixaGeralLivreBanco  + @SaldoInicial
  
  --------------------------VALORES------------------------------------------------------------
  
  Select 1 CodigoFluxoCaixa,'1. RECEITA BRUTA : ' DescricaoFluxoCaixa, CONVERT(VARCHAR,@ReceitaBruta) ValorFluxo, CONVERT(VARCHAR,@ReceitaBrutaCaixa) ValorFluxoCaixa, CONVERT(VARCHAR,@ReceitaBrutaBanco) ValorFluxoBanco, 1 as FluxoCaixa, 100 as Perc_R
  union
  Select 2,'2. DEDUÇÃO RECEITA : ' , CONVERT(VARCHAR,@DeducaoReceita), CONVERT(VARCHAR,@DeducaoReceitaCaixa), CONVERT(VARCHAR,@DeducaoReceitaBanco),2, dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @DeducaoReceita/@ReceitaBruta end*100,2)),2)
  union
  Select 3,'3. (1+2) RECEITA LÍQUIDA : ' , CONVERT(VARCHAR,@ReceitaLiquida), CONVERT(VARCHAR,@ReceitaLiquidaCaixa), CONVERT(VARCHAR,@ReceitaLiquidaBanco), 0, dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ReceitaLiquida/@ReceitaBruta end*100,2)),2)
  union
  Select 4,'4. CUSTOS : ' , CONVERT(money,@Custos), CONVERT(money,@CustosCaixa), CONVERT(money,@CustosBanco),3,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @Custos/@ReceitaBruta end*100,2)),2)
  union
  Select 5,'5. (3-4) RESULTADO BRUTO : ' , CONVERT(VARCHAR,@ResultadoBruto), CONVERT(VARCHAR,@ResultadoBrutoCaixa), CONVERT(VARCHAR,@ResultadoBrutoBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ResultadoBruto/@ReceitaBruta end*100,2)),2)
  union
  Select 6,'6. DESPESAS OPERACIONAIS : ' , CONVERT(VARCHAR,@DespesasOperacionais), CONVERT(VARCHAR,@DespesasOperacionaisCaixa), CONVERT(VARCHAR,@DespesasOperacionaisBanco),4,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @DespesasOperacionais/@ReceitaBruta end*100,2)),2)
  union
  Select 7,'7. (5+6) RESULTADO OPERACIONAL : ' , CONVERT(VARCHAR,@ResultadoOperacional), CONVERT(VARCHAR,@ResultadoOperacionalCaixa), CONVERT(VARCHAR,@ResultadoOperacionalBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ResultadoOperacional/@ReceitaBruta end*100,2)),2)
  union
  Select 8,'8. RESULTADO NÃO OPERACIONAL : ' , CONVERT(VARCHAR,@ResultadoNaoOperacional), CONVERT(VARCHAR,@ResultadoNaoOperacionalCaixa), CONVERT(VARCHAR,@ResultadoNaoOperacionalBanco),6,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ResultadoNaoOperacional/@ReceitaBruta end*100,2)),2)
  union
  Select 9,'9. (7+8) RESULTADO LÍQUIDO : ' , CONVERT(VARCHAR,@ResultadoLiquiado), CONVERT(VARCHAR,@ResultadoLiquiadoCaixa), CONVERT(VARCHAR,@ResultadoLiquiadoBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ResultadoLiquiado/@ReceitaBruta end*100,2)),2)
  union
  --@DepreciacaoAmortizacaoBanco  @ResultadoLiqOperacionalBanco
  Select 10,'10. RESULTADO LIQUIDO OPERACIONAL : ' , CONVERT(VARCHAR,@ResultadoLiqOperacional), CONVERT(VARCHAR,@ResultadoLiqOperacionalCaixa), CONVERT(VARCHAR,@ResultadoLiqOperacionalBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @ResultadoLiqOperacional/@ReceitaBruta end*100,2)),2)
  union
  Select 11,'11. DEPRECIAÇÃO E AMORTIZAÇÃO : ' , CONVERT(VARCHAR,@DepreciacaoAmortizacao), CONVERT(VARCHAR,@DepreciacaoAmortizacaoCaixa), CONVERT(VARCHAR,@DepreciacaoAmortizacaoBanco),18,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @DepreciacaoAmortizacao/@ReceitaBruta end*100,2)),2)
  
  --Select 10,'10. INVESTIMENTOS : ' , CONVERT(VARCHAR,@Investimentos), CONVERT(VARCHAR,@InvestimentosCaixa), CONVERT(VARCHAR,@InvestimentosBanco),5,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @Investimentos/@ReceitaBruta end*100,2)),2)
  --union
  --Select 11,'11. (9+10)CAIXA OPERACIONAL LIVRE : ' , CONVERT(VARCHAR,@CaixaOperacionalLivre), CONVERT(VARCHAR,@CaixaOperacionalLivreCaixa), CONVERT(VARCHAR,@CaixaOperacionalLivreBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @CaixaOperacionalLivre/@ReceitaBruta end*100,2)),2)
  --union
  --Select 12,'12. MOVIMENTAÇÃO FINANCEIRA E PATRIMONIAL : ' , CONVERT(VARCHAR,@MovimentacaoFiananceiraPatrimonial), CONVERT(VARCHAR,@MovimentacaoFiananceiraPatrimonialCaixa), CONVERT(VARCHAR,@MovimentacaoFiananceiraPatrimonialBanco),7,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @MovimentacaoFiananceiraPatrimonial/@ReceitaBruta end*100,2)),2)
  --union
  --Select 13,'13. (11+12)CAIXA GERAL LIVRE : ' , CONVERT(VARCHAR,@CaixaGeralLivre), CONVERT(VARCHAR,@CaixaGeralLivreCaixa), CONVERT(VARCHAR,@CaixaGeralLivreBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @CaixaGeralLivre/@ReceitaBruta end*100,2)),2)
  --union
  --Select 14,'14. SALDO INICIAL : ' , CONVERT(VARCHAR,@SaldoInicial), CONVERT(VARCHAR,@SaldoInicialCaixa), CONVERT(VARCHAR,@SaldoInicialBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @SaldoInicial/@ReceitaBruta end*100,2)),2)
  --union
  --Select 15,'15. (13+14) SALDO FINAL : ' , CONVERT(VARCHAR,@SaldoFinal), CONVERT(VARCHAR,@SaldoFinalCaixa), CONVERT(VARCHAR,@SaldoFinalBanco),0,dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else @SaldoFinal/@ReceitaBruta end*100,2)),2)
  order by 1 
End

--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--NIVEL 2
--Contas Mãe
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
If @Nivel = 2
Begin
   if @Codigo_FluxoCaixa = 18
   begin
	   Select cm.Codigo_ContaMae, cm.Descricao_ContaMae, isnull(sum(x.valor), 0) valor, isnull(sum(x.valorCaixa),0) valorCaixa, isnull(sum(x.valorBanco),0) valorBanco, 
	   isnull(cm.Sequencial_ContaMae,0) Sequencial_ContaMae, isnull(sum(x.Per_R),0) Per_R, isnull(sum(x.Per_G),0) Per_G
	   From TB_ContaMae Cm
	   Left Join (Select  T1.Codigo_ContaMae, T1.Descricao_ContaMae, SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) AS valor, 
			   case when T6.Sequencial_Agencia is null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorCaixa,
			   case when T6.Sequencial_Agencia is not null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorBanco,
			   T1.Sequencial_ContaMae,
			   dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@receita end*100,2)),2) as Per_R,
			   dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@valor_nivel end*100,2)),2) as Per_G
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_DRE = @Codigo_FluxoCaixa And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
			   --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T2.cd_centro_custo in (select cd_centro_custo from @Result)  --and 
				--(
				--   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
				--)  
		Group By T1.Codigo_ContaMae, T1.Descricao_ContaMae, T1.Sequencial_ContaMae,T6.Sequencial_Agencia
		)  as x on cm.Codigo_ContaMae = x.Codigo_ContaMae
		where cm.Codigo_FluxoCaixa = @Codigo_FluxoCaixa
		Group By cm.Codigo_ContaMae, cm.Descricao_ContaMae, x.Codigo_ContaMae, x.Descricao_ContaMae, cm.Sequencial_ContaMae, x.Sequencial_ContaMae
		Order By cm.Codigo_ContaMae, x.Descricao_ContaMae
   end
   
   else
   begin
	   Select cm.Codigo_ContaMae, cm.Descricao_ContaMae, isnull(sum(x.valor), 0) valor, isnull(sum(x.valorCaixa),0) valorCaixa, isnull(sum(x.valorBanco),0) valorBanco, 
	   isnull(cm.Sequencial_ContaMae,0) Sequencial_ContaMae, isnull(sum(x.Per_R),0) Per_R, isnull(sum(x.Per_G),0) Per_G
	   From TB_ContaMae Cm
	   Left Join (Select  T1.Codigo_ContaMae, T1.Descricao_ContaMae, SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) AS valor, 
			   case when T6.Sequencial_Agencia is null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorCaixa,
			   case when T6.Sequencial_Agencia is not null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorBanco,
			   T1.Sequencial_ContaMae,
			   dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@receita end*100,2)),2) as Per_R,
			   dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@valor_nivel end*100,2)),2) as Per_G
		 From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
				TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T1.Codigo_FluxoCaixa = @Codigo_FluxoCaixa And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
			   --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And
				T2.cd_centro_custo in (select cd_centro_custo from @Result)  --and 
				--(
				--   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
				--)  
		Group By T1.Codigo_ContaMae, T1.Descricao_ContaMae, T1.Sequencial_ContaMae,T6.Sequencial_Agencia
		)  as x on cm.Codigo_ContaMae = x.Codigo_ContaMae
		where cm.Codigo_FluxoCaixa = @Codigo_FluxoCaixa
		Group By cm.Codigo_ContaMae, cm.Descricao_ContaMae, x.Codigo_ContaMae, x.Descricao_ContaMae, cm.Sequencial_ContaMae, x.Sequencial_ContaMae
		Order By cm.Codigo_ContaMae, x.Descricao_ContaMae 
	end
End
 
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--NIVEL 3
--Contas Filhas
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
If @Nivel = 3
Begin
   Select c.sequencial_conta, c.Descricao_Conta, isnull(sum(x.Valor),0) Valor, isnull(sum(x.valorCaixa),0) valorCaixa, isnull(sum(x.valorBanco),0) valorBanco, c.Codigo_Conta, isnull(sum(x.Per_R), 0) Per_R, isnull(sum(x.Per_G),0) Per_G
   From TB_Conta c
   Left Join (
   Select  substring(T2.Codigo_Conta,3,10) sequencial_conta, T2.Descricao_Conta, SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) As Valor, substring(T2.Codigo_Conta,3,10) Codigo_Conta, -- T2.Sequencial_Conta,
           case when T6.Sequencial_Agencia is null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorCaixa,
           case when T6.Sequencial_Agencia is not null then SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End) else 0 end valorBanco,
           
           dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@receita end*100,2)),2) as Per_R,
           dbo.FS_FormataFloat(abs(round(case when @ReceitaBruta<=0 then 0 else SUM(case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end*case when t1.tipo_conta=1 then 1 else -1 End)/@valor_nivel end*100,2)),2) as Per_G
		   , T1.Sequencial_ContaMae, T2.Sequencial_Conta idConta
   From   TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
            TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
     Where  T1.Sequencial_ContaMae = @Sequencial_ContaMae And
            T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
            T2.Conta_Valida = 1 And
            T2.Sequencial_Conta = T3.Sequencial_Conta And
            T3.Data_HoraExclusao Is Null And
            T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
            --T4.Tipo_ContaLancamento = 1 And
            --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
            --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
            Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
			Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
			T4.Sequencial_Historico          = T5.Sequencial_Historico    And
            T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
            T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
            --(
            --   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
            --or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
            --)
    Group By substring(T2.Codigo_Conta,3,10), T2.Descricao_Conta,T6.Sequencial_Agencia, T1.Sequencial_ContaMae, T2.Sequencial_Conta    
    ) as x on c.Sequencial_Conta = x.idConta
    where c.Sequencial_ContaMae = @Sequencial_ContaMae
    and c.cd_centro_custo in (select cd_centro_custo from @Result)
    Group By c.sequencial_conta, c.Descricao_Conta,c.Sequencial_ContaMae, x.sequencial_conta, x.Descricao_Conta, c.Codigo_Conta, x.Codigo_Conta
    Order By 1 --, T2.Descricao_Conta 

End

--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
--NIVEL 4
--Contas 
--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*--*
If @Nivel = 4
Begin
   If @TipoCaixa = 0
   Begin
	   Select  substring(T2.Codigo_Conta,3,10) Codigo_Conta, T2.Descricao_Conta, case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end As Valor, t3.Historico , T3.Sequencial_Lancamento, 
			   CONVERT(VARCHAR(10), case when t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) then T4.Data_Efetiva_Cartao  
										 when t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) then T4.Data_Lancamento
										 else t4.Data_Documento end ,103) Data_pagamento, 
			   t6.Descricao_Movimentacao, convert(varchar(10),T4.Data_Documento,103) Data_Documento, t3.Tipo_Lancamento
		 From  TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
			   TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T2.Sequencial_Conta = @Sequencial_Conta And
		  --Where  T1.Sequencial_ContaMae = @Sequencial_ContaMae And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				--T4.Tipo_ContaLancamento = 1 And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
				--(
				--   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
				--)
		--Group By substring(T2.Codigo_Conta,3,10), T2.Descricao_Conta 
		Order By T2.Codigo_Conta, T2.Descricao_Conta, t6.Descricao_Movimentacao 
   End
   
   If @TipoCaixa = 1
   Begin
	   Select  substring(T2.Codigo_Conta,3,10) Codigo_Conta, T2.Descricao_Conta, case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end As Valor, t3.Historico , T3.Sequencial_Lancamento, 
			   CONVERT(VARCHAR(10), case when t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) then T4.Data_Efetiva_Cartao  
										 when t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) then T4.Data_Lancamento
										 else t4.Data_Documento end ,103) Data_pagamento, 
			   t6.Descricao_Movimentacao, convert(varchar(10),T4.Data_Documento,103) Data_Documento, t3.Tipo_Lancamento
		 From  TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
			   TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T2.Sequencial_Conta = @Sequencial_Conta And
		 --Where  T1.Sequencial_ContaMae = @Sequencial_ContaMae And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				T6.Sequencial_Agencia is null And
				T4.Tipo_ContaLancamento = 1 And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
			
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
				--(
				--   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
				--)
		--Group By substring(T2.Codigo_Conta,3,10), T2.Descricao_Conta 
		Order By T2.Codigo_Conta, T2.Descricao_Conta, t6.Descricao_Movimentacao 
   End
   
   If @TipoCaixa = 2
   Begin
	   Select  substring(T2.Codigo_Conta,3,10) Codigo_Conta, T2.Descricao_Conta, case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end As Valor, t3.Historico , T3.Sequencial_Lancamento, 
			   CONVERT(VARCHAR(10), case when t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) then T4.Data_Efetiva_Cartao  
										 when t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) then T4.Data_Lancamento
										 else t4.Data_Documento end ,103) Data_pagamento, 
			   t6.Descricao_Movimentacao, convert(varchar(10),T4.Data_Documento,103) Data_Documento, t3.Tipo_Lancamento
		 From  TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
			   TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
		 Where  T2.Sequencial_Conta = @Sequencial_Conta And
		  --Where  T1.Sequencial_ContaMae = @Sequencial_ContaMae And
				T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
				T2.Conta_Valida = 1 And
				T2.Sequencial_Conta = T3.Sequencial_Conta And
				T3.Data_HoraExclusao Is Null And
				T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
				T6.Sequencial_Agencia is not null And
				T4.Tipo_ContaLancamento = 1 And
				--Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
				--Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
				Cast(T4.Data_HoraLancamento as date) >= Cast(@DTI as date) And
				Cast(T4.Data_HoraLancamento as date) <= Cast(@DTF as date) And
				
				T4.Sequencial_Historico          = T5.Sequencial_Historico    And
				T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
				T2.cd_centro_custo in (select cd_centro_custo from @Result) --and 
				--(
				--   (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
				--or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
				--)
		--Group By substring(T2.Codigo_Conta,3,10), T2.Descricao_Conta 
		Order By T2.Codigo_Conta, T2.Descricao_Conta, t6.Descricao_Movimentacao 
   End
   
   --Select  substring(T2.Codigo_Conta,3,10) Codigo_Conta, T2.Descricao_Conta, case when t4.Tipo_ContaLancamento = 1 then T4.Valor_Lancamento else t4.Valor_Previsto end As Valor, t3.Historico , T3.Sequencial_Lancamento, 
   --        CONVERT(VARCHAR(10), case when t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) then T4.Data_Efetiva_Cartao  
   --                                  when t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) then T4.Data_Lancamento
   --                                  else t4.Data_Documento end ,103) Data_pagamento, 
   --        t6.Descricao_Movimentacao, convert(varchar(10),T4.Data_Documento,103) Data_Documento, t3.Tipo_Lancamento
   --  From  TB_ContaMae T1, TB_Conta T2, TB_Lancamento T3, TB_FormaLancamento T4, 
   --        TB_HistoricoMovimentacao T5, TB_MovimentacaoFinanceira T6
   --  --Where  T2.Sequencial_Conta = @Sequencial_Conta And
   --   Where  T1.Sequencial_ContaMae = @Sequencial_ContaMae And
   --         T1.Sequencial_ContaMae = T2.Sequencial_ContaMae And
   --         T2.Conta_Valida = 1 And
   --         T2.Sequencial_Conta = T3.Sequencial_Conta And
   --         T3.Data_HoraExclusao Is Null And
   --         T3.Sequencial_Lancamento = T4.Sequencial_Lancamento And
   --         --T4.Tipo_ContaLancamento = 1 And
   --         --Cast(T5.Data_Fechamento as date) >= Cast(@DTI as date) And
   --         --Cast(T5.Data_Fechamento as date) <= Cast(@DTF as date) And
   --         T4.Sequencial_Historico          = T5.Sequencial_Historico    And
   --         T5.Sequencial_Movimentacao       = T6.Sequencial_Movimentacao And 
   --         T2.cd_centro_custo in (select cd_centro_custo from @Result) and 
   --         (
   --            (t3.Tipo_Lancamento = 1 and t4.forma_lancamento in (6,9) and Cast(T4.Data_Efetiva_Cartao as date) >= Cast(@DTI as date) And Cast(T4.Data_Efetiva_Cartao as date) <= Cast(@DTF as date) )
   --         or (t3.Tipo_Lancamento = 1 and t4.forma_lancamento not in (6,9) and Cast(T4.Data_Lancamento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Lancamento as date) <= Cast(@DTF as date) )
   --         or (t3.Tipo_Lancamento = 2 and Cast(T4.Data_Documento  as date) >= Cast(@DTI as date) And Cast(T4.Data_Documento as date) <= Cast(@DTF as date) )
   --         )
   -- --Group By substring(T2.Codigo_Conta,3,10), T2.Descricao_Conta 
   -- Order By T2.Codigo_Conta, T2.Descricao_Conta, t6.Descricao_Movimentacao 

End


End
