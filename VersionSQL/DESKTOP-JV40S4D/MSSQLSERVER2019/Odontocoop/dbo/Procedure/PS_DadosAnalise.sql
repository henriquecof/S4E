/****** Object:  Procedure [dbo].[PS_DadosAnalise]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DadosAnalise]
  (
   @DataInicial SmalldateTime,
   @DataFinal SmalldateTime,
   @Caixa Int,
   @TipoRelatorio Smallint
  )
As
Begin
    Declare @Caixa_Final Int 
    Declare @WL_SequencialMovimentacao Int
    Declare @WL_DescricaoMovimentacao Varchar(90)
    Declare @WL_DataPagamento varchar(10)
    Declare @WL_ValorPagamento Money
    Declare @WL_ValorRecebimento Money              
    Declare @WL_DescricaoConta Varchar(80)
    Declare @WL_CodigoConta varchar(6)

----------------------------------- Teste Filial -----------------------------------------------------------------
    If @Caixa = 0 
       Set @Caixa_Final  = 999999
    Else           
       Set @Caixa_Final  = @Caixa

--------------------------------- Nome da Tabela Temporaria -------------------------------------------------
-- TB_DadosAnalise_Temp   

Delete from TB_DadosAnalise_Temp   

--------------------------------- Agrupado por caixa em determinado periodo -----------------------------------
If @TipoRelatorio = 1
   Begin 
	 Insert into TB_DadosAnalise_Temp   
	 Select T1.Sequencial_movimentacao, T1.Descricao_Movimentacao, Null,null,null,
	     IsNull((Select sum(t3.valor_lancamento)
	     From TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	          TB_Conta T5, TB_ContaMae T6
	     Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And  
	           T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	           T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	           T4.Data_HoraExclusao       Is Null And   
	           T4.Tipo_Lancamento         = 1 And /* 1 - Recebimento 2 - Pagamento*/
	           T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	           t3.Data_Pagamento between  @DataInicial and @DataFinal And
	           T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	           T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	           T6.tipo_classificacao      <> 6 -- Contas de movimentacao
	           ),0) As Recebimento,
	     IsNull((Select sum(t3.valor_lancamento)
	     From TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	          TB_Conta T5, TB_ContaMae T6
	     Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And  
	           T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	           T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	           T4.Data_HoraExclusao       Is Null And   
	           T4.Tipo_Lancamento         = 2 And /* 1 - Recebimento 2 - Pagamento*/
	           T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	           t3.Data_Pagamento between  @DataInicial and @DataFinal And
	           T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	           T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	           T6.tipo_classificacao      <> 6 -- Contas de movimentacao
	           ),0) As Pagamento,null,null
	 From TB_MovimentacaoFinanceira T1
         Where T1.Sequencial_Movimentacao >= @Caixa And 
               T1.Sequencial_Movimentacao <= @Caixa_Final 
	 Order By T1.Descricao_Movimentacao
   End

-------------------------------- Agrupado por caixa e por dia ----------------------------------------------------------------------------------
If @TipoRelatorio = 2 Or @TipoRelatorio = 5
   Begin      
      -- Recebimentos 
     Insert into TB_DadosAnalise_Temp   
        (Sequencial_Movimentacao,Descricao_Caixa,Data_Pagamento,Valor_Recebimento,Valor_Pagamento)    
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao,Convert(varchar(10),T3.Data_Pagamento,103),sum(t3.valor_lancamento),0
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 1 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6 And  -- Contas de movimentacao 
           T1.Sequencial_Movimentacao >= @Caixa And 
           T1.Sequencial_Movimentacao <= @Caixa_Final 
	Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, Convert(varchar(10),T3.Data_Pagamento,103)

    -- Pagamentos
     Declare Dados_Cursor  Cursor For 
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao,Convert(varchar(10),T3.Data_Pagamento,103),0,sum(t3.valor_lancamento)
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 2 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6 And  -- Contas de movimentacao 
           T1.Sequencial_Movimentacao >= @Caixa And 
           T1.Sequencial_Movimentacao <= @Caixa_Final 
	  Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, Convert(varchar(10),T3.Data_Pagamento,103)    

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento, @WL_ValorRecebimento, @WL_ValorPagamento

      While (@@fetch_status  <> -1)
            Begin
              If (Select Count(*)
                     From TB_DadosAnalise_Temp   
                     Where Sequencial_movimentacao = @WL_SequencialMovimentacao And                   
                           Data_Pagamento = @WL_DataPagamento) > 0 
                     Begin
                       Update TB_DadosAnalise_Temp Set
                              Valor_Recebimento = Valor_Recebimento + @WL_ValorRecebimento,
                              Valor_Pagamento   = Valor_Pagamento + @WL_ValorPagamento
                       Where Sequencial_movimentacao = @WL_SequencialMovimentacao And 
                              Data_Pagamento = @WL_DataPagamento
                     End 
                  Else               
                     Begin
                        Insert into TB_DadosAnalise_Temp   
                        (Sequencial_Movimentacao,Descricao_Caixa,Data_Pagamento,Valor_Pagamento,Valor_Recebimento)    
                         Values 
                         (@WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento,@WL_ValorPagamento,@WL_ValorRecebimento)
                     End                

                Fetch next from Dados_Cursor 
                Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento, @WL_ValorRecebimento, @WL_ValorPagamento

            End
        
       CLOSE Dados_Cursor
       DEALLOCATE  Dados_Cursor    

   End
------------------------------------ Agrupado por caixa e conta ----------------------------------------------------

If @TipoRelatorio = 3
   Begin 

     -- Recebimentos 
     Insert into TB_DadosAnalise_Temp   
        (Sequencial_Movimentacao,Descricao_Caixa,Codigo_Conta,Descricao_Conta,Valor_Recebimento,Valor_Pagamento,Data_Pagamento)    
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao, T5.Codigo_Conta, T5.Descricao_Conta,sum(t3.valor_lancamento),0,null
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 1 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6 And  -- Contas de movimentacao 
               T1.Sequencial_Movimentacao >= @Caixa And 
               T1.Sequencial_Movimentacao <= @Caixa_Final 
	Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, T5.Codigo_Conta, T5.Descricao_Conta

     -- Pagamentos
     Insert into TB_DadosAnalise_Temp   
        (Sequencial_Movimentacao,Descricao_Caixa,Codigo_Conta,Descricao_Conta,Valor_Pagamento,Valor_Recebimento,Data_Pagamento)    
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao, T5.Codigo_Conta, T5.Descricao_Conta,sum(t3.valor_lancamento),0,null
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 2 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6 And -- Contas de movimentacao
               T1.Sequencial_Movimentacao >= @Caixa And 
               T1.Sequencial_Movimentacao <= @Caixa_Final 
	Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, T5.Codigo_Conta, T5.Descricao_Conta
End

------------------------------------ Agrupado por caixa,conta e data ----------------------------------------------------
If @TipoRelatorio = 4
   Begin 
     --recebimentos
     Insert into TB_DadosAnalise_Temp   
        (Sequencial_Movimentacao,Descricao_Caixa,Data_Pagamento,Codigo_Conta,Descricao_Conta,Valor_Recebimento, Valor_Pagamento)    
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao, convert(varchar(10),T3.Data_Pagamento,103),T5.Codigo_Conta, T5.Descricao_Conta,Sum(t3.valor_lancamento),0
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 1 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6  And -- Contas de movimentacao 
               T1.Sequencial_Movimentacao >= @Caixa And 
               T1.Sequencial_Movimentacao <= @Caixa_Final 
	Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao,convert(varchar(10),T3.Data_Pagamento,103),T5.Codigo_Conta, T5.Descricao_Conta

     -- pagamentos
     Declare Dados_Cursor  Cursor For 
     Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao, convert(varchar(10),T3.Data_Pagamento,103), T5.Codigo_Conta, T5.Descricao_Conta,Sum(t3.valor_lancamento),0
	 From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	      TB_Conta T5, TB_ContaMae T6
	 Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	       T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	       T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
	       T4.Data_HoraExclusao is Null And  
	       T4.Tipo_Lancamento         = 2 And /* 1 - Recebimento 2 - Pagamento*/
	       T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	       t3.Data_Pagamento between  @DataInicial and @DataFinal And
	       T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	       T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	       T6.tipo_classificacao      <> 6  And -- Contas de movimentacao 
               T1.Sequencial_Movimentacao >= @Caixa And 
            T1.Sequencial_Movimentacao <= @Caixa_Final 
	Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao,convert(varchar(10),T3.Data_Pagamento,103),T5.Codigo_Conta, T5.Descricao_Conta

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento,@WL_CodigoConta, @WL_DescricaoConta,@WL_ValorPagamento, @WL_ValorRecebimento 

      While (@@fetch_status  <> -1)
            Begin
              If (Select Count(*)
                     From TB_DadosAnalise_Temp   
                     Where Sequencial_movimentacao = @WL_SequencialMovimentacao And                   
                           Codigo_Conta   = @WL_CodigoConta And
                           Data_Pagamento = @WL_DataPagamento) > 0 
                     Begin
                       Update TB_DadosAnalise_Temp Set
                              Valor_Recebimento = Valor_Recebimento+ @WL_ValorRecebimento,
                              Valor_Pagamento   = Valor_Pagamento + @WL_ValorPagamento
                       Where Sequencial_movimentacao = @WL_SequencialMovimentacao And 
                             Codigo_Conta   = @WL_CodigoConta And
                             Data_Pagamento = @WL_DataPagamento
                     End 
                  Else               
                     Begin
                        Insert into TB_DadosAnalise_Temp   
                        (Sequencial_Movimentacao,Descricao_Caixa,Data_Pagamento,Valor_Pagamento,Valor_Recebimento,Codigo_conta,Descricao_conta)    
                         Values 
                        (@WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento,@WL_ValorPagamento,@WL_ValorRecebimento,@WL_CodigoConta,@WL_DescricaoConta)
                     End                

                Fetch next from Dados_Cursor 
                Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento,@WL_CodigoConta, @WL_DescricaoConta,@WL_ValorPagamento, @WL_ValorRecebimento 

            End
        
       CLOSE Dados_Cursor
       DEALLOCATE  Dados_Cursor    
 End
 ------------------------------------ Agrupado por caixa,conta e data com contas de Movimento ----------------------------------------------------
 If @TipoRelatorio = 5
   Begin          

       Declare Dados_Cursor  Cursor For        
       Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao,Convert(varchar(10),T3.Data_Pagamento,103),sum(t3.valor_lancamento),0
	   From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	        TB_Conta T5, TB_ContaMae T6
	   Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	         T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	         T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
             T4.Data_HoraExclusao is Null And  
	         T4.Tipo_Lancamento         = 1 And /* 1 - Recebimento 2 - Pagamento*/
	         T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	         t3.Data_Pagamento between  @DataInicial and @DataFinal And
	         T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	         T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	         T6.tipo_classificacao      = 6 And  -- Contas de movimentacao 
             T1.Sequencial_Movimentacao >= @Caixa And 
             T1.Sequencial_Movimentacao <= @Caixa_Final 
	   Group by T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, Convert(varchar(10),T3.Data_Pagamento,103)
      Union      
       Select T1.Sequencial_Movimentacao, T1.Descricao_Movimentacao,Convert(varchar(10),T3.Data_Pagamento,103),0,sum(t3.valor_lancamento)
	   From TB_MovimentacaoFinanceira T1, TB_HistoricoMovimentacao T2, TB_FormaLancamento T3, TB_Lancamento T4,
	        TB_Conta T5, TB_ContaMae T6
	   Where T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao And 
	         T2.Sequencial_Historico    = T3.Sequencial_Historico    And
	         T3.Sequencial_Lancamento   = T4.Sequencial_Lancamento   And
   	         T4.Data_HoraExclusao is Null And  
	         T4.Tipo_Lancamento         = 2 And /* 1 - Recebimento 2 - Pagamento*/
	         T3.tipo_contalancamento    = 1 And /* 1 - Realizado   2 - Previsto*/
	         t3.Data_Pagamento between  @DataInicial and @DataFinal And
	         T4.Sequencial_Conta        = T5.Sequencial_Conta And 
	         T5.Sequencial_ContaMae     = T6.Sequencial_ContaMae And 
	         T6.tipo_classificacao      = 6 And  -- Contas de movimentacao 
             T1.Sequencial_Movimentacao >= @Caixa And 
             T1.Sequencial_Movimentacao <= @Caixa_Final 
	   Group by  T1.Sequencial_Movimentacao,T1.Descricao_Movimentacao, Convert(varchar(10),T3.Data_Pagamento,103)    
     Order By 1,2

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento, @WL_ValorRecebimento, @WL_ValorPagamento

      While (@@fetch_status  <> -1)
            Begin
              If (Select Count(*)
                     From TB_DadosAnalise_Temp   
                     Where Sequencial_movimentacao = @WL_SequencialMovimentacao And                   
                           Data_Pagamento = @WL_DataPagamento) > 0 
                     Begin
                       Update TB_DadosAnalise_Temp Set
                              Valor_Recebimento_Mov = IsNull(Valor_Recebimento_Mov,0) + @WL_ValorRecebimento,
                              Valor_Pagamento_Mov   = IsNull(Valor_Pagamento_Mov,0) + @WL_ValorPagamento
                       Where Sequencial_movimentacao = @WL_SequencialMovimentacao And 
                              Data_Pagamento = @WL_DataPagamento
                     End 
                  Else               
                     Begin
                        Insert into TB_DadosAnalise_Temp   
                        (Sequencial_Movimentacao,Descricao_Caixa,Data_Pagamento,Codigo_Conta,Descricao_Conta,
                         Valor_Pagamento,Valor_Recebimento,Valor_Pagamento_Mov,Valor_Recebimento_Mov)    
                         Values 
                         (@WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento, Null, Null,
                         0,0, @WL_ValorPagamento, @WL_ValorRecebimento)
                     End                

                Fetch next from Dados_Cursor 
                Into @WL_SequencialMovimentacao, @WL_DescricaoMovimentacao, @WL_DataPagamento, @WL_ValorRecebimento, @WL_ValorPagamento

            End
        
       CLOSE Dados_Cursor
       DEALLOCATE  Dados_Cursor    
   End 
End
