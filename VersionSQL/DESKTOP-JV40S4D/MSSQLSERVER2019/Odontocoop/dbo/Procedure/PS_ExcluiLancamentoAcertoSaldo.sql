/****** Object:  Procedure [dbo].[PS_ExcluiLancamentoAcertoSaldo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[PS_ExcluiLancamentoAcertoSaldo](
 @SequencialLancamento int,
 @TipoAcerto smallint --1 - exclui lancamento. 2 - volta ao previsto, 3 - altera saldo
)
As
Begin

 Declare @Mensagem varchar(500)
 Declare @sequencialhistorico int
 Declare @sequencialmovimentacao int
 Declare @tipolancamento smallint
 Declare @sequencialhistoricoConsulta int
 Declare @valorsaldofinal money
 Declare @valorlancamento money  
 Declare @Flag smallint

 If (Select count(*) 
      From TB_FormaLancamento 
      Where sequencial_lancamento = @SequencialLancamento) > 1
      begin  
           Set @Mensagem = 'A execução vai ter que ser manual. Mais de um registro na forma de lancamento.'
           raiserror(@Mensagem,16,1)			
	       return
       end  

  Select @tipolancamento = tipo_lancamento,
         @valorlancamento = valor_lancamento
     From tb_lancamento t1, TB_FormaLancamento t2    
     Where t1.sequencial_lancamento = @SequencialLancamento And
           t1.sequencial_lancamento = t2.sequencial_lancamento

  if @TipoAcerto = 1
   Begin
     update tb_lancamento
     set data_horaexclusao = getdate() 
     where sequencial_lancamento = @SequencialLancamento
   End  

 if @TipoAcerto = 2
   Begin
      --Colocando para previsto
     update tb_formalancamento set
           tipo_contalancamento = 2,
           valor_previsto       = isnull(valor_lancamento,valor_previsto),  
           valor_lancamento     = null,
           data_pagamento       = null,
           data_lancamento      = null
      where sequencial_lancamento  = @SequencialLancamento  
   End

    --Descobrindo qual e o cx e a movimentacao
   Select @sequencialhistorico    = sequencial_historico,
          @sequencialmovimentacao = sequencial_movimentacao
   From tb_historicomovimentacao where
     sequencial_historico in
       (select sequencial_historico from tb_formalancamento
          where sequencial_lancamento  = @SequencialLancamento)

   Declare  dados_Cursor  cursor for 
    Select sequencial_historico, valor_saldo_final
       from tb_historicomovimentacao 
       Where
         sequencial_historico   >= @sequencialhistorico and
         sequencial_movimentacao = @sequencialmovimentacao
    Order by 1 asc

   Open dados_Cursor
       Fetch next from dados_Cursor
       Into @sequencialhistoricoConsulta ,@valorsaldofinal

    Set @Flag = 1
    While (@@fetch_status  <> -1)
     Begin 
        if (@tipolancamento=1)
          Begin
            if @valorsaldofinal is null
               Begin
                 update tb_historicomovimentacao set
                    valor_saldo_inicial = valor_saldo_inicial - @valorlancamento
                 where sequencial_historico = @sequencialhistoricoConsulta
               End
            Else 
               Begin
                 --primeiro registro muda somente o valor final
                 if @Flag = 1
                   Begin
                       update tb_historicomovimentacao set
						valor_saldo_final   = valor_saldo_final - @valorlancamento
					   where sequencial_historico = @sequencialhistoricoConsulta
                      
                       Set @Flag = 2 
                   End
                 Else
                   Begin 
					   update tb_historicomovimentacao set
						valor_saldo_inicial = valor_saldo_inicial - @valorlancamento,
						valor_saldo_final = valor_saldo_final - @valorlancamento
					   where sequencial_historico = @sequencialhistoricoConsulta
                   End 
               End
          End
 
         Else

          Begin
            if @valorsaldofinal is null
               Begin
                 update tb_historicomovimentacao set
                    valor_saldo_inicial = valor_saldo_inicial + @valorlancamento
                 where sequencial_historico = @sequencialhistoricoConsulta
               End
            Else 
               Begin
                 update tb_historicomovimentacao set
                    valor_saldo_inicial = valor_saldo_inicial + @valorlancamento,
                    valor_saldo_final = valor_saldo_final + @valorlancamento
                 where sequencial_historico = @sequencialhistoricoConsulta
               End
           End
       
       Fetch next from dados_Cursor
       Into @sequencialhistoricoConsulta ,@valorsaldofinal

      End      

      Close dados_Cursor
	  Deallocate dados_Cursor

End
