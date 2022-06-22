/****** Object:  Procedure [dbo].[PS_DadosContasMovimento2]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_DadosContasMovimento2]
        (
	     @Data_Inicial DateTime,
         @Data_Final   DateTime,       
         @Tipo         SmallInt,  
         @ContaMae     Varchar(04), 
         @Conta        Varchar(06),
         @TipoRel      smallint         
	    )
AS	
 Begin    
    -------------------------------------------------------------------
    -- Declaração de variaveis.
    -------------------------------------------------------------------
    Declare @WL_ContaMaeFinal Varchar(04)
    Declare @WL_ContaFinal    Varchar(06)    
    Declare @WL_Conta as varchar(06)      
    Declare @WL_Descricao As Varchar(90)      
    Declare @WL_ContaMae as varchar(04)      
    Declare @WL_DescricaoMae as varchar(90)      
    Declare @WL_Sequencial_Lancamento As Int 
    Declare @WL_Valor_Lancamento As Money     
    Declare @WL_Valor_Previsto As Money  
    Declare @WL_Historico As Varchar(1500)
    Declare @WL_DataDocumento As DateTime    
    Declare @WL_TipoContaLancamento As SmallInt
    Declare @WL_Tipo_ContaLancamento_Origem As Smallint
    Declare @WL_Tipo_ContaLancamento_Destino As Smallint
    
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

    CREATE TABLE #TB_ContaResultado_Temp
     (ContaMaeOrigem Varchar(200) Null,  
      ContaOrigem Varchar(200) Null,
      Tipo_ContaLancamento_Origem SmallInt Null,  
      Sequencial_LancamentoOrigem Int Null,  
      HistoricoOrigem Varchar(2000) Null,
      DataDocumentoOrigem DateTime Null,
      ValorRealizadoOrigem Money  Null,
      ValorPrevistoOrigem  Money  Null,
      ContaMaeDestino Varchar(200) Null,  
      ContaDestino Varchar(200) Null,  
      Tipo_ContaLancamento_Destino SmallInt Null,  
      Sequencial_LancamentoDestino Int Null,
      HistoricoDestino Varchar(2000) Null,
      DataDocumentoDestino DateTime Null,
      ValorRealizadoDestino Money Null,
      ValorPrevistoDestino  Money Null)          

    ----------------------------------------------------------------------------
    -- 1º Passo : Pegando todos os lançamentos entre as datas que 
    --            sejam de contas de movimentação, e que tenham contra-partida    
    --            pelo sequencial de movimentação.
    ----------------------------------------------------------------------------           
       Insert Into #TB_ContaResultado_Temp
              (ContaMaeOrigem, 
               ContaOrigem,               
               Tipo_ContaLancamento_Origem,
               ValorRealizadoOrigem,
               ValorPrevistoOrigem,
               Sequencial_LancamentoOrigem,  
               DataDocumentoOrigem,
               HistoricoOrigem, 
               ContaMaeDestino, 
               ContaDestino,    
               Tipo_ContaLancamento_Destino,
               ValorRealizadoDestino,
               ValorPrevistoDestino,
               Sequencial_LancamentoDestino,  
               DataDocumentoDestino,
               HistoricoDestino)          
	     Select T4.Codigo_ContaMae + '-' + T4.Descricao_ContaMae, 
               T3.Codigo_Conta + '-' + T3.Descricao_Conta, 		   
               T2.Tipo_ContaLancamento,
		       IsNull(T2.Valor_Lancamento,0), 
		       IsNull(T2.Valor_Previsto,0), 
		       T1.Sequencial_Lancamento,
		       T2.Data_Pagamento,
		       T1.Historico,     
               T40.Codigo_ContaMae + '-' + T40.Descricao_ContaMae, 
               T30.Codigo_Conta + '-' + T30.Descricao_Conta, 		 
               T20.Tipo_ContaLancamento,
		       IsNull(T20.Valor_Lancamento,0), 
		       IsNull(T20.Valor_Previsto,0), 
		       T10.Sequencial_Lancamento,
		       T20.Data_Pagamento,
		       T10.Historico 
          From  TB_Lancamento T1, TB_Formalancamento T2,
               TB_Conta T3 , TB_ContaMae T4,
               TB_Lancamento T10, TB_Formalancamento T20,
               TB_Conta T30 , TB_ContaMae T40
           Where T1.Sequencial_Lancamento = T10.Sequencial_Lancamento_Origem And
               T1.sequencial_Lancamento = T2.sequencial_Lancamento        And       
               ((T2.data_pagamento Between @Data_Inicial And @Data_Final) Or         
		       (T2.data_documento Between @Data_Inicial And @Data_Final And t2.data_pagamento is null)) And                                       
               T1.Data_HoraExclusao is Null And
               T1.Sequencial_Conta       = T3.Sequencial_Conta And
               T3.Sequencial_ContaMae   = T4.Sequencial_ContaMae And
               T4.Tipo_Classificacao     = 6 And            
               T10.sequencial_Lancamento = T20.sequencial_Lancamento And       
               T10.Sequencial_Conta      = T30.Sequencial_Conta And
               T30.Sequencial_ContaMae  = T40.Sequencial_ContaMae And
               T4.Codigo_ContaMae >= @ContaMae And   
		       T4.Codigo_ContaMae <= @WL_ContaMaeFinal And 
		       T3.Codigo_Conta    >= @Conta And   
		       T3.Codigo_Conta    <= @WL_ContaFinal         		          
 
      ----------------------------------------------------------------------------
      -- 2º Passo : Sem contas de contra-partida  - Só os recebimentos    
      --            vou olhar os lançamentos, pela sequencialcontaorigem  
      ----------------------------------------------------------------------------     
      Insert Into #TB_ContaResultado_Temp
			  (ContaMaeOrigem, 
			   ContaOrigem,            
               Tipo_ContaLancamento_Origem,   
			   ValorRealizadoOrigem,
			   ValorPrevistoOrigem,
			   Sequencial_LancamentoOrigem,  
			   DataDocumentoOrigem,
			   HistoricoOrigem, 
			   ContaMaeDestino, 
			   ContaDestino,           
               Tipo_ContaLancamento_Destino,    
			   ValorRealizadoDestino,
			   ValorPrevistoDestino,
			   Sequencial_LancamentoDestino,  
			   DataDocumentoDestino,
			   HistoricoDestino)  
	  Select   T4.Codigo_ContaMae + '-' + T4.Descricao_ContaMae, 
               T3.Codigo_Conta + '-' + T3.Descricao_Conta, 		   
               T2.Tipo_ContaLancamento,  
   		       IsNull(T2.Valor_Lancamento,0), 
		       IsNull(T2.Valor_Previsto,0), 
		       T1.Sequencial_Lancamento,
		       T2.Data_Pagamento,
		       T1.Historico,
               Null,Null,null,0,0,Null,Null,Null
     From  TB_Lancamento T1, TB_Formalancamento T2,
           TB_Conta T3 , TB_ContaMae T4           
     Where T1.Sequencial_Lancamento_Origem Is Null And
           T1.sequencial_Lancamento = T2.sequencial_Lancamento        And       
           ((T2.data_pagamento Between @Data_Inicial And @Data_Final) Or         
           (T2.data_documento Between @Data_Inicial And @Data_Final And t2.data_pagamento is null)) And                                       
           T1.Data_HoraExclusao is Null And
           T1.Sequencial_Conta      = T3.Sequencial_Conta And
           T3.Sequencial_ContaMae   = T4.Sequencial_ContaMae And
           T4.Tipo_Classificacao    = 6 And                       
           T4.Codigo_ContaMae >= @ContaMae And   
		   T4.Codigo_ContaMae <= @WL_ContaMaeFinal And 
		   T3.Codigo_Conta    >= @Conta And   
		   T3.Codigo_Conta    <= @WL_ContaFinal And
           T1.Sequencial_Lancamento Not In (
                 Select Sequencial_LancamentoOrigem From #TB_ContaResultado_Temp) And
           T1.Sequencial_Lancamento Not In (
                 Select Sequencial_LancamentoDestino From #TB_ContaResultado_Temp)              

     -- Valores pela conta mãe.
     If @Tipo = 1 And @TipoRel = 1       
       Begin
         Select ContaMaeOrigem, Min(ContaMaeDestino) as ContaMaeDestino,                                          
                Min(DataDocumentoDestino) as DataDocumentoDestino,
                Sum(isnull(ValorRealizadoOrigem,0)) as ValorRealizadoOrigem, 
                Sum(isnull(ValorPrevistoOrigem,0)) as ValorPrevistoOrigem,
                Sum(isnull(ValorRealizadoDestino,0)) as ValorRealizadoDestino, 
                Sum(isnull(ValorPrevistoDestino,0)) as ValorPrevistoDestino
         From  #TB_ContaResultado_Temp
         Where  Tipo_ContaLancamento_Origem = Tipo_ContaLancamento_Destino
         Group By ContaMaeOrigem
         Order By ContaMaeOrigem
       End       

     -- Contas.
     If @Tipo = 1 And @TipoRel = 2 
       Begin
        Select ContaDestino, Min(ContaOrigem) as ContaOrigem,  
               Min(DataDocumentoOrigem) as DataDocumentoOrigem,                                    
               Sum(ValorRealizadoOrigem) as ValorRealizadoOrigem, 
               Sum(ValorPrevistoOrigem) as ValorPrevistoOrigem,
               Sum(isnull(ValorRealizadoDestino,0)) as ValorRealizadoDestino, 
               Sum(isnull(ValorPrevistoDestino,0)) as ValorPrevistoDestino
        From  #TB_ContaResultado_Temp
        Where Sequencial_LancamentoDestino is null 
        Group By ContaDestino
        Order By ContaDestino
       End 

     If @Tipo = 1 And @TipoRel = 3       
       Begin
         Select ContaMaeOrigem, Min(ContaMaeDestino) as ContaMaeDestino,                                          
                Min(DataDocumentoDestino) as DataDocumentoDestino,
                Sum(isnull(ValorRealizadoOrigem,0)) as ValorRealizadoOrigem, 
                Sum(isnull(ValorPrevistoOrigem,0)) as ValorPrevistoOrigem,
                Sum(isnull(ValorRealizadoDestino,0)) as ValorRealizadoDestino, 
                Sum(isnull(ValorPrevistoDestino,0)) as ValorPrevistoDestino
         From  #TB_ContaResultado_Temp
         Where  Tipo_ContaLancamento_Origem = Tipo_ContaLancamento_Destino
         Group By ContaMaeOrigem
         Order By ContaMaeOrigem
       End       

    -- Todos os lançamentos
    If @Tipo = 3 And @TipoRel = 1       
      Begin
        Select ContaOrigem,                                 
               Sequencial_LancamentoOrigem,
               Sequencial_LancamentoDestino,              
               Tipo_ContaLancamento_Origem,
               Tipo_ContaLancamento_Destino,
               ValorRealizadoOrigem, ValorPrevistoOrigem,               
               HistoricoOrigem     , DataDocumentoOrigem,
               ContaDestino,Sequencial_LancamentoDestino,
               ValorRealizadoDestino, ValorPrevistoDestino,
               HistoricoDestino     , DataDocumentoDestino
        From  #TB_ContaResultado_Temp                      
        Order By ContaOrigem,DataDocumentoOrigem,ContaDestino,DataDocumentoDestino
      End

    --somente contra-partida.
    If @Tipo = 3 And @TipoRel = 2       
      Begin
        Select ContaOrigem,                                 
               Sequencial_LancamentoOrigem,
               Sequencial_LancamentoDestino,              
               Tipo_ContaLancamento_Origem,
               Tipo_ContaLancamento_Destino,
               ValorRealizadoOrigem, ValorPrevistoOrigem,               
               HistoricoOrigem     , DataDocumentoOrigem,
               ContaDestino,Sequencial_LancamentoDestino,
               ValorRealizadoDestino, ValorPrevistoDestino,
               HistoricoDestino     , DataDocumentoDestino
        From  #TB_ContaResultado_Temp              
        Where Sequencial_LancamentoDestino is null 
        Order By ContaOrigem,DataDocumentoOrigem,ContaDestino,DataDocumentoDestino
      End

    If @Tipo = 3 And @TipoRel = 3       
      Begin
        Select ContaOrigem,                                 
               Sequencial_LancamentoOrigem,
               Sequencial_LancamentoDestino,              
               Tipo_ContaLancamento_Origem,
               Tipo_ContaLancamento_Destino,
               ValorRealizadoOrigem, ValorPrevistoOrigem,               
               HistoricoOrigem     , DataDocumentoOrigem,
               ContaDestino,Sequencial_LancamentoDestino,
               ValorRealizadoDestino, ValorPrevistoDestino,
               HistoricoDestino     , DataDocumentoDestino
        From  #TB_ContaResultado_Temp              
        Where  Tipo_ContaLancamento_Origem <> Tipo_ContaLancamento_Destino
        Order By ContaOrigem,DataDocumentoOrigem,ContaDestino,DataDocumentoDestino
      End

      Drop Table #TB_ContaResultado_Temp     
End
