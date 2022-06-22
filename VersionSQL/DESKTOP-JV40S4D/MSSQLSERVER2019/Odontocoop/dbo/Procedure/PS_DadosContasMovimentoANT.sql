/****** Object:  Procedure [dbo].[PS_DadosContasMovimentoANT]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DadosContasMovimentoANT]
        (
	     @Data_Inicial DateTime,
         @Data_Final   DateTime,       
         @Tipo         SmallInt,  
         @ContaMae     Varchar(04), 
         @Conta        Varchar(06)         
	    )
AS	
 Begin    


/*

declare @Data_Inicial datetime
declare @Data_Final datetime 

set @Data_Inicial='10/01/2007'
set @Data_Final='11/23/2007'

select t1.sequencial_lancamento 
 from tb_lancamento as t1 , tb_formalancamento as t3, tb_conta t4, tb_contamae t5
where t1.sequencial_lancamento_origem is null and
      t1.sequencial_lancamento = t3.sequencial_lancamento and 
     ((T3.data_pagamento Between @Data_Inicial And @Data_Final) Or         
     (T3.data_documento Between @Data_Inicial And @Data_Final And t3.data_pagamento is null)) and 
      T1.sequencial_conta        = t4.sequencial_conta And  
      T4.sequencial_contamae     = t5.sequencial_contamae And         
      T1.Data_HoraExclusao is Null And         
      T5.Tipo_Classificacao      = 6 and 
      t1.sequencial_lancamento not in 
(
select t1.sequencial_lancamento 
 from tb_lancamento as t1 , tb_formalancamento as t3,
      tb_lancamento as t2
where t1.sequencial_lancamento = t2.sequencial_lancamento_origem
  and t1.sequencial_lancamento = t3.sequencial_lancamento and 
     ((T3.data_pagamento Between @Data_Inicial And @Data_Final) Or         
     (T3.data_documento Between @Data_Inicial And @Data_Final And t3.data_pagamento is null)) 
) and 
     t1.sequencial_lancamento not in 
(
select t2.sequencial_lancamento
 from tb_lancamento as t1 , tb_formalancamento as t3,
      tb_lancamento as t2
where t1.sequencial_lancamento = t2.sequencial_lancamento_origem
  and t1.sequencial_lancamento = t3.sequencial_lancamento and 
     ((T3.data_pagamento Between @Data_Inicial And @Data_Final) Or         
     (T3.data_documento Between @Data_Inicial And @Data_Final And t3.data_pagamento is null)) 
)



select t1.sequencial_lancamento , t2.sequencial_lancamento, t2.sequencial_lancamento_origem 
 from tb_lancamento as t1 , tb_formalancamento as t3,
      tb_lancamento as t2
where t1.sequencial_lancamento = t2.sequencial_lancamento_origem
  and t1.sequencial_lancamento = t3.sequencial_lancamento and 
     ((T3.data_pagamento Between @Data_Inicial And @Data_Final) Or         
     (T3.data_documento Between @Data_Inicial And @Data_Final And t3.data_pagamento is null)) 

*/

    -------------------------------------------------------------------
    -- Declaração de variaveis.
    -------------------------------------------------------------------
    Declare @WL_ContaMaeFinal Varchar(04)
    Declare @WL_ContaFinal    Varchar(06)
    
    Declare @WL_Conta_Origem as varchar(06)      
    Declare @WL_Descricao_Origem As Varchar(90)      
    Declare @WL_ContaMae_Origem as varchar(04)      
    Declare @WL_DescricaoMae_Origem as varchar(90)      
    Declare @WL_Sequencial_Lancamento_Origem As Int 
    Declare @WL_Valor_Lancamento_Origem As Money     
    Declare @WL_Valor_Previsto_Origem As Money  
    Declare @WL_Historico_Origem As Varchar(1500)
    Declare @WL_DataDocumento_Origem As DateTime

    Declare @WL_Conta_Destino as varchar(06)      
    Declare @WL_Descricao_Destino As Varchar(90)      
    Declare @WL_ContaMae_Destino as varchar(04)      
    Declare @WL_DescricaoMae_Destino as varchar(90)      
    Declare @WL_Sequencial_Lancamento_Destino As Int 
    Declare @WL_Valor_Lancamento_Destino As Money     
    Declare @WL_Valor_Previsto_Destino As Money  
    Declare @WL_Historico_Destino As Varchar(1500)
    Declare @WL_DataDocumento_Destino As DateTime 
    
    if @ContaMae = ''
       Begin 
         Set @ContaMae = '0000'
         Set @WL_ContaMaeFinal = '9999'
       End
    else
       Begin
         Set @WL_ContaMaeFinal = @ContaMae
       End  

    if @Conta = ''
       Begin 
         Set @Conta = '000000'
       Set @WL_ContaFinal = '999999'
       End
    else
       Begin
         Set @WL_ContaFinal = @Conta
       End  

   -----------------------------------------------------------------------------
   -- Criando tabela temporaria
   -- Tabela temporario para quardar valores do resultado do procedimento.
   -----------------------------------------------------------------------------
    IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[#TB_ContaResultado]') AND type in (N'U'))
      drop table #TB_ContaResultado

    CREATE TABLE #TB_ContaResultado
     (ContaMaeOrigem Varchar(90) Null,  
      ContaOrigem Varchar(90) Null,
      Sequencial_LancamentoOrigem Int Null,  
      HistoricoOrigem Varchar(1500) Null,
      DataDocumentoOrigem DateTime Null,
      ValorRealizadoOrigem Money  Null,
      ValorPrevistoOrigem  Money  Null,
      ContaMaeDestino Varchar(90) Null,  
      ContaDestino Varchar(90) Null,  
      Sequencial_LancamentoDestino Int Null,
      HistoricoDestino Varchar(1500) Null,
      DataDocumentoDestino DateTime Null,
      ValorRealizadoDestino Money Null,
      ValorPrevistoDestino  Money Null)          

    ----------------------------------------------------------------------------
    -- 1º Passo : Pegando todos os lançamentos entre as datas que 
    --            sejam de contas de movimentação, e que tenham contra-partida    
    --            pelo sequencial de movimentação.
    ----------------------------------------------------------------------------           
        Declare Dados_Cursor  Cursor For 
		Select   T1.Codigo_Conta,
						T1.Descricao_Conta, 
						T4.Codigo_ContaMae, 
						T4.Descricao_ContaMae, 
						IsNull(T2.Valor_Lancamento,0), 
						IsNull(T2.Valor_Previsto,0), 
						T2.Sequencial_Lancamento,
						T2.Data_Pagamento,
						T3.Historico     
		from   TB_Conta t1, tb_lancamento t3, 
			   TB_ContaMae t4, TB_FormaLancamento t2  
		where  t1.sequencial_conta        = t3.sequencial_conta And         
			   t2.sequencial_lancamento   = t3.sequencial_lancamento and         
			   t1.sequencial_contamae     = t4.sequencial_contamae And         
			   t3.Data_HoraExclusao is Null And         
			   T4.Tipo_Classificacao      = 6 And            
			   --T1.Conta_Valida            = 1 And    
			  ((t2.data_pagamento Between @Data_Inicial And @Data_Final) Or         
			   (t2.data_documento Between @Data_Inicial And @Data_Final And t2.data_pagamento is null)) And                      
				T4.Codigo_ContaMae >= @ContaMae And   
			    T4.Codigo_ContaMae <= @WL_ContaMaeFinal And 
				T1.Codigo_Conta >= @Conta And   
				T1.Codigo_Conta <= @WL_ContaFinal And
                T3.Sequencial_Lancamento In (
                    Select Sequencial_Lancamento_Origem
                       From TB_Lancamento T100 
                       Where T100.Sequencial_Lancamento_Origem = T3.Sequencial_Lancamento)		  
		  Order By 1 Asc 

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_Conta_Origem,@WL_Descricao_Origem,@WL_ContaMae_Origem,@WL_DescricaoMae_Origem,
              @WL_Valor_Lancamento_Origem,@WL_Valor_Previsto_Origem,@WL_Sequencial_Lancamento_Origem,
              @WL_DataDocumento_Origem, @WL_Historico_Origem               

      While (@@fetch_status  <> -1)
         Begin
              Set @WL_Conta_Destino          = Null
              Set @WL_Descricao_Destino      = Null
              Set @WL_ContaMae_Destino       = Null
              Set @WL_DescricaoMae_Destino   = Null
              Set @WL_Valor_Lancamento_Destino = 0
              Set @WL_Valor_Previsto_Destino = 0
              Set @WL_Sequencial_Lancamento_Destino = Null
              Set @WL_DataDocumento_Destino  = Null 
              Set @WL_Historico_Destino      = Null         

              If @WL_Valor_Lancamento_Origem is not Null
                 Set @WL_Valor_Previsto_Origem = 0
              Else
                 Set @WL_Valor_Lancamento_Origem = 0

              -- Buscando lançamento de destino entre as datas.
 Select  @WL_Conta_Destino        = T1.Codigo_Conta,
                      @WL_Descricao_Destino    = T1.Descricao_Conta,
                      @WL_ContaMae_Destino     = T4.Codigo_ContaMae,
                      @WL_DescricaoMae_Destino = T4.Descricao_ContaMae,                      
                      @WL_Valor_Lancamento_Destino   = isnull(T2.Valor_Lancamento,0), 
                      @WL_Valor_Previsto_Destino     = isnull(T2.Valor_Previsto,0),
                      @WL_Sequencial_Lancamento_Destino = T2.Sequencial_Lancamento,
                      @WL_DataDocumento_Destino      = T2.Data_Pagamento,
                      @WL_Historico_Destino          = T3.Historico       
              From    TB_Conta T1, TB_FormaLancamento T2, TB_Lancamento T3,
                      TB_ContaMae T4 
              Where   T1.Sequencial_Conta      = T3.Sequencial_Conta And 
                      T3.Sequencial_Lancamento = T2.Sequencial_Lancamento And
                      T1.Sequencial_ContaMae   = T4.Sequencial_ContaMae And                      
                      T3.Sequencial_Lancamento_Origem = @WL_Sequencial_Lancamento_Origem And 
                      T3.Data_HoraExclusao is Null     

               If @WL_Valor_Lancamento_Destino  > 0 
                  Set @WL_Valor_Previsto_Destino = 0
               Else
                  Set @WL_Valor_Lancamento_Destino = 0        

             -- Incluindo informações.
             Insert Into #tb_contaresultado
              (ContaMaeOrigem, ContaOrigem,
               Sequencial_LancamentoOrigem,  
               HistoricoOrigem     , DataDocumentoOrigem,
               ValorRealizadoOrigem, ValorPrevistoOrigem,
               ContaMaeDestino     , ContaDestino,  
               Sequencial_LancamentoDestino,
               HistoricoDestino,
               DataDocumentoDestino,
               ValorRealizadoDestino,
          ValorPrevistoDestino)      
             Values   
               (@WL_ContaMae_Origem + ' ' + @WL_DescricaoMae_Origem,
                @WL_Conta_Origem    + ' ' + @WL_Descricao_Origem,                
                @WL_Sequencial_Lancamento_Origem,
                @WL_Historico_Origem,
                @WL_DataDocumento_Origem,
                @WL_Valor_Lancamento_Origem,
                @WL_Valor_Previsto_Origem,
                @WL_ContaMae_Destino + ' ' + @WL_DescricaoMae_Destino,
                @WL_Conta_Destino    + ' ' + @WL_Descricao_Destino,
                @WL_Sequencial_Lancamento_Destino,
                @WL_Historico_Destino,
                @WL_DataDocumento_Destino,
                @WL_Valor_Lancamento_Destino,
                @WL_Valor_Previsto_Destino)  
               
                Fetch next from Dados_Cursor 
                Into @WL_Conta_Origem,@WL_Descricao_Origem,@WL_ContaMae_Origem,@WL_DescricaoMae_Origem,
                     @WL_Valor_Lancamento_Origem,@WL_Valor_Previsto_Origem,@WL_Sequencial_Lancamento_Origem,
                     @WL_DataDocumento_Origem, @WL_Historico_Origem                                               
         End 
     Close Dados_Cursor
     DEALLOCATE Dados_Cursor 

    ----------------------------------------------------------------------------
    -- 2º Passo : Sem contas de contra-partida  - Só os recebimentos    
    --            vou olhar os lançamentos, pela sequencialcontaorigem  
    ----------------------------------------------------------------------------     
   Declare Dados_Cursor  Cursor For 
	  Select   T1.Codigo_Conta,
						T1.Descricao_Conta, 
						T4.Codigo_ContaMae, 
						T4.Descricao_ContaMae, 
						IsNull(T2.Valor_Lancamento,0), 
						IsNull(T2.Valor_Previsto,0), 
						T2.Sequencial_Lancamento,
						T2.Data_Pagamento,
						T3.Historico     
		From   TB_Conta t1, tb_lancamento t3, 
			   TB_ContaMae t4, TB_FormaLancamento t2  
		Where  T1.sequencial_conta        = t3.sequencial_conta And         
			   T2.sequencial_lancamento   = t3.sequencial_lancamento and         
			   T1.sequencial_contamae     = t4.sequencial_contamae And         
			   T3.Data_HoraExclusao is Null And         
			   T4.Tipo_Classificacao      = 6 And            
			   --T1.Conta_Valida            = 1 And    
               T3.Tipo_Lancamento         = 1 And
			 ((T2.data_pagamento Between @Data_Inicial And @Data_Final) Or         
			  (T2.data_documento Between @Data_Inicial And @Data_Final And t2.data_pagamento is null)) And                                       
               --T1.Codigo_Conta <> '013501' And
			   T4.Codigo_ContaMae >= @ContaMae And   
			   T4.Codigo_ContaMae <= @WL_ContaMaeFinal And 
			   T1.Codigo_Conta >= @Conta And   
			   T1.Codigo_Conta <= @WL_ContaFinal And
               T3.Sequencial_Lancamento_Origem Is Null And
               t3.Sequencial_lancamento Not In (
                    Select Sequencial_LancamentoOrigem From #TB_ContaResultado) And
               t3.Sequencial_lancamento Not In (
                    Select Sequencial_LancamentoDestino From #TB_ContaResultado)
         Order By 1 Asc 

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_Conta_Destino,@WL_Descricao_Destino,@WL_ContaMae_Destino,@WL_DescricaoMae_Destino,
              @WL_Valor_Lancamento_Destino,@WL_Valor_Previsto_Destino,@WL_Sequencial_Lancamento_Destino,
              @WL_DataDocumento_Destino, @WL_Historico_Destino               

      While (@@fetch_status  <> -1)
         Begin
              Set @WL_Conta_Origem            = Null
              Set @WL_Descricao_Origem        = Null
              Set @WL_ContaMae_Origem         = Null
              Set @WL_DescricaoMae_Origem     = Null
              Set @WL_Valor_Lancamento_Origem = 0
              Set @WL_Valor_Previsto_Origem   = 0
              Set @WL_Sequencial_Lancamento_Origem = Null
              Set @WL_DataDocumento_Origem    = Null 
              Set @WL_Historico_Origem        = Null        

              If @WL_Valor_Lancamento_Destino is not Null
                 Set @WL_Valor_Previsto_Destino = 0
              Else
                 Set @WL_Valor_Lancamento_Destino = 0
      
             -- Incluindo informações.
             Insert Into #tb_contaresultado
              (ContaMaeOrigem, ContaOrigem,
               Sequencial_LancamentoOrigem,  
               HistoricoOrigem     , DataDocumentoOrigem,
               ValorRealizadoOrigem, ValorPrevistoOrigem,
               ContaMaeDestino     , ContaDestino,  
               Sequencial_LancamentoDestino,
               HistoricoDestino,
               DataDocumentoDestino,
               ValorRealizadoDestino,
               ValorPrevistoDestino)      
             Values   
               (@WL_ContaMae_Origem + ' ' + @WL_DescricaoMae_Origem,
                @WL_Conta_Origem    + ' ' + @WL_Descricao_Origem,                
                @WL_Sequencial_Lancamento_Origem,
                @WL_Historico_Origem,
                @WL_DataDocumento_Origem,
                @WL_Valor_Lancamento_Origem,
                @WL_Valor_Previsto_Origem,
                @WL_ContaMae_Destino + ' ' + @WL_DescricaoMae_Destino,
                @WL_Conta_Destino    + ' ' + @WL_Descricao_Destino,
                @WL_Sequencial_Lancamento_Destino,
                @WL_Historico_Destino,
                @WL_DataDocumento_Destino,
                @WL_Valor_Lancamento_Destino,
                @WL_Valor_Previsto_Destino)  
               
                Fetch next from Dados_Cursor 
                   Into @WL_Conta_Destino,@WL_Descricao_Destino,@WL_ContaMae_Destino,@WL_DescricaoMae_Destino,
                        @WL_Valor_Lancamento_Destino,@WL_Valor_Previsto_Destino,@WL_Sequencial_Lancamento_Destino,
                        @WL_DataDocumento_Destino, @WL_Historico_Destino               
         End 
     Close Dados_Cursor
     DEALLOCATE Dados_Cursor 

    ----------------------------------------------------------------------------
    -- 3º Passo : Sem contas de contra-partida  - Primeiro só os pagamentos    
    ----------------------------------------------------------------------------     
      Declare Dados_Cursor  Cursor For 
	  Select   T1.Codigo_Conta,
						T1.Descricao_Conta, 
						T4.Codigo_ContaMae, 
						T4.Descricao_ContaMae, 
						IsNull(T2.Valor_Lancamento,0), 
						IsNull(T2.Valor_Previsto,0), 
						T2.Sequencial_Lancamento,
						T2.Data_Pagamento,
						T3.Historico     
		from   TB_Conta t1, tb_lancamento t3, 
			   TB_ContaMae t4, TB_FormaLancamento t2  
		where  t1.sequencial_conta        = t3.sequencial_conta And         
			   t2.sequencial_lancamento   = t3.sequencial_lancamento and         
			   t1.sequencial_contamae     = t4.sequencial_contamae And         
			   t3.Data_HoraExclusao is Null And         
			   T4.Tipo_Classificacao      = 6 And            
			   --T1.Conta_Valida            = 1 And    
               t3.Tipo_Lancamento         = 2 And
			  ((t2.data_pagamento Between @Data_Inicial And @Data_Final) Or         
			   (t2.data_documento Between @Data_Inicial And @Data_Final And t2.data_pagamento is null)) And                                                    
                --T1.Codigo_Conta <> '013501' And                
                T3.Sequencial_Lancamento Not In (
                   Select Sequencial_Lancamento_Origem
                        From TB_Lancamento T100 
                        Where T100.Sequencial_Lancamento_Origem Is Not Null) And		  
				T4.Codigo_ContaMae >= @ContaMae And   
			    T4.Codigo_ContaMae <= @WL_ContaMaeFinal And 
				T1.Codigo_Conta >= @Conta And   
				T1.Codigo_Conta <= @WL_ContaFinal /*And
                t3.Sequencial_lancamento Not In (
                    Select Sequencial_LancamentoOrigem From #TB_ContaResultado) And
                t3.Sequencial_lancamento Not In (
                    Select Sequencial_LancamentoDestino From #TB_ContaResultado)*/
		  Order By 1 Asc 

      Open Dados_Cursor
         Fetch next from Dados_Cursor 
         Into @WL_Conta_Origem,@WL_Descricao_Origem,@WL_ContaMae_Origem,@WL_DescricaoMae_Origem,
              @WL_Valor_Lancamento_Origem,@WL_Valor_Previsto_Origem,@WL_Sequencial_Lancamento_Origem,
              @WL_DataDocumento_Origem, @WL_Historico_Origem               

      While (@@fetch_status  <> -1)
         Begin
              Set @WL_Conta_Destino          = Null
              Set @WL_Descricao_Destino      = Null
              Set @WL_ContaMae_Destino       = Null
              Set @WL_DescricaoMae_Destino   = Null
              Set @WL_Valor_Lancamento_Destino = 0
              Set @WL_Valor_Previsto_Destino = 0
              Set @WL_Sequencial_Lancamento_Destino = Null
              Set @WL_DataDocumento_Destino  = Null 
              Set @WL_Historico_Destino      = Null        

              If @WL_Valor_Lancamento_Origem is not Null
                 Set @WL_Valor_Previsto_Origem = 0
              Else
                 Set @WL_Valor_Lancamento_Origem = 0
      
             -- Incluindo informações.
             Insert Into #tb_contaresultado
              (ContaMaeOrigem, ContaOrigem,
               Sequencial_LancamentoOrigem,  
               HistoricoOrigem     , DataDocumentoOrigem,
               ValorRealizadoOrigem, ValorPrevistoOrigem,
               ContaMaeDestino     , ContaDestino,  
               Sequencial_LancamentoDestino,
               HistoricoDestino,
               DataDocumentoDestino,
               ValorRealizadoDestino,
               ValorPrevistoDestino)      
             Values   
               (@WL_ContaMae_Origem + ' ' + @WL_DescricaoMae_Origem,
                @WL_Conta_Origem    + ' ' + @WL_Descricao_Origem,                
                @WL_Sequencial_Lancamento_Origem,
                @WL_Historico_Origem,
                @WL_DataDocumento_Origem,
                @WL_Valor_Lancamento_Origem,
                @WL_Valor_Previsto_Origem,
                @WL_ContaMae_Destino + ' ' + @WL_DescricaoMae_Destino,
                @WL_Conta_Destino    + ' ' + @WL_Descricao_Destino,
                @WL_Sequencial_Lancamento_Destino,
                @WL_Historico_Destino,
                @WL_DataDocumento_Destino,
                @WL_Valor_Lancamento_Destino,
                @WL_Valor_Previsto_Destino)  
               
                Fetch next from Dados_Cursor 
                Into @WL_Conta_Origem,@WL_Descricao_Origem,@WL_ContaMae_Origem,@WL_DescricaoMae_Origem,
                     @WL_Valor_Lancamento_Origem,@WL_Valor_Previsto_Origem,@WL_Sequencial_Lancamento_Origem,
                     @WL_DataDocumento_Origem, @WL_Historico_Origem                                               
         End 
     Close Dados_Cursor
     DEALLOCATE Dados_Cursor 

     -- Valores pela conta mãe.
     If @Tipo = 1
       Begin
         Select ContaMaeOrigem, Min(ContaMaeDestino) as ContaMaeDestino,                                          
                Min(DataDocumentoDestino) as DataDocumentoDestino,
                Sum(isnull(ValorRealizadoOrigem,0)) as ValorRealizadoOrigem, 
                Sum(isnull(ValorPrevistoOrigem,0)) as ValorPrevistoOrigem,
                Sum(isnull(ValorRealizadoDestino,0)) as ValorRealizadoDestino, 
                Sum(isnull(ValorPrevistoDestino,0)) as ValorPrevistoDestino
         From  #tb_contaresultado
         Group By ContaMaeOrigem
         Order By ContaMaeOrigem
       End       

     -- Contas.
     If @Tipo = 2
       Begin
        Select ContaDestino, Min(ContaOrigem) as ContaOrigem,  
               Min(DataDocumentoOrigem) as DataDocumentoOrigem,                                    
               Sum(ValorRealizadoOrigem) as ValorRealizadoOrigem, 
               Sum(ValorPrevistoOrigem) as ValorPrevistoOrigem,
               Sum(isnull(ValorRealizadoDestino,0)) as ValorRealizadoDestino, 
               Sum(isnull(ValorPrevistoDestino,0)) as ValorPrevistoDestino
        From  #tb_contaresultado
        Group By ContaDestino
        Order By ContaDestino
       End 

    -- Todos os lançamentos
    If @Tipo = 3
      Begin
        Select ContaOrigem,                                 
               Sequencial_LancamentoOrigem,
               Sequencial_LancamentoDestino,              
               ValorRealizadoOrigem, ValorPrevistoOrigem,               
               HistoricoOrigem     , DataDocumentoOrigem,
               ContaDestino,Sequencial_LancamentoDestino,
               ValorRealizadoDestino, ValorPrevistoDestino,
               HistoricoDestino     , DataDocumentoDestino
        From  #tb_contaresultado              
        Order By ContaOrigem,ContaDestino, DataDocumentoOrigem, DataDocumentoDestino
      End
     Drop Table #TB_ContaResultado
End
