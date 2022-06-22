/****** Object:  Procedure [dbo].[SP_Emprestimo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Emprestimo] (@CCOrigem int, @CCDestino int, @CaixaOrigem int,@CaixaDestino int,@dtEmprestimo date,@DtPrevisaoDevolucao date,@valor money,@nomeusuario varchar(20)=null)
as 
Begin 

  RETURN 
  
   print @CCOrigem 
   print @CCDestino 
   print @CaixaOrigem 
   print @CaixaDestino 
   print @dtEmprestimo 
   print @DtPrevisaoDevolucao 
   print @valor
   

	-------------------- Variaveis ------------------------------------      
	Declare @WL_Mensagem Varchar(1000)
	Declare @Sequencial_HistoricoOrigem Int   
	Declare @Sequencial_HistoricoDestino Int   
	Declare @Descricao_CentroCustoOrigem Varchar(200)   
	Declare @Descricao_CentroCustoDestino Varchar(200)   
 
	Declare @Sequencial_Lancamento Int
	Declare @Sequencial_FormaLancamento Int
	Declare @Historico Varchar(1500)
	Declare @Nome_Usuario Varchar(20)   
	Declare @Sequencial_Movimentacao Int      
	Declare @Descricao_Movimentacao Varchar(80)   
	Declare @Sequencial_Historico_Consulta Int
	Declare @WL_tipocontalancamento smallint

    Declare @identify int
 
    if @CCOrigem = @CCDestino 
    Begin
       Set @WL_Mensagem = 'Centro de Custo de Origem e Destino devem ser diferentes.'
       RAISERROR (@WL_Mensagem, 16, 1)
       Return
    End  
 
    select @Descricao_CentroCustoOrigem = ds_centro_custo 
	  from centro_custo 
	 where cd_centro_custo = @CCOrigem
 
    select @Descricao_CentroCustoDestino = ds_centro_custo 
	  from centro_custo 
	 where cd_centro_custo = @CCDestino

	--Descobrir se existe caixa aberto para o lançamento de origem.
        Set @Sequencial_HistoricoOrigem = 0
        Select @Sequencial_HistoricoOrigem = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaOrigem And 
                 Data_Fechamento Is Null

        If @Sequencial_HistoricoOrigem = 0 
            Begin
               Set @WL_Mensagem = 'Deve existir caixa aberto para lançamento de origem.'
               RAISERROR (@WL_Mensagem, 16, 1)
               Return
            End  


	--Descobrir se existe caixa aberto para o lançamento de destino.
        Set @Sequencial_HistoricoDestino = 0
        Select @Sequencial_HistoricoDestino = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaDestino And 
                 Data_Fechamento Is Null

        If @Sequencial_HistoricoDestino = 0 
            Begin
               Set @WL_Mensagem = 'Deve existir caixa aberto para lançamento de destino.'
               RAISERROR (@WL_Mensagem, 16, 1)
               Return
            End  
                        

     -- 051102 - Cessão de Empréstimo para quem cedeu, e 051001 -Tomada de Empréstimo, para quem recebeu;
     -- No mesmo momento são criadas a conta a pagar da clínica que recebeu do tipo 051101 -Devolução de Empréstimo Tomado e a 
     -- conta a receber para a clínica que cedeu do tipo 051002 -Devoluç?=3o de Empréstimos Cedidos.
                     
		Begin Transaction
		
		-- ********************************
		-- Lançamento Emprestimo saída
		-- ********************************
		Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, nome_outros, nome_usuario, Mensagem_Delecao)
		                    
		Select 2, 'Cessão de Empréstimo:' + @Descricao_CentroCustoDestino, Sequencial_Conta,     
		@nomeusuario, @nomeusuario, 'Somente o usuario do lancamento de saída pode excluir esse lançamento.'         
		from TB_Conta 
		where cd_centro_custo=@CCOrigem and codigo_conta like '%1102'  

		select @identify = @@IDENTITY 
		if @identify is null 
		Begin
		   Set @WL_Mensagem = 'Erro na criação do Lançamento de Saída do emprestimo.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End   
		       
		--Forma lancamento
		Insert Into TB_FormaLancamento
		(Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,Valor_Previsto, 
		 Data_Documento, Data_Pagamento, Data_lancamento,Data_HoraLancamento, 
		 Sequencial_Lancamento, Sequencial_Historico,Nome_Usuario)

		Values (1, 7, @valor, @valor, 
			@dtEmprestimo, @dtEmprestimo, @dtEmprestimo, GetDate(), 
			@@IDENTITY, @Sequencial_HistoricoOrigem, @nomeusuario )

		if @@ROWCOUNT <> 1 
		Begin
		   Set @WL_Mensagem = 'Erro na criação da Forma de Lançamento de Saída do emprestimo.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End         
				
		-- ********************************
		-- Lançamento Emprestimo Entrada
		-- ********************************
		Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta,Sequencial_Lancamento_Origem, nome_outros, nome_usuario, Mensagem_Delecao)
		                    
		Select 1, 'Tomada de Empréstimo:' + @Descricao_CentroCustoOrigem, Sequencial_Conta, @@IDENTITY,    
		@nomeusuario, @nomeusuario, 'Somente o usuario do lancamento de saída pode excluir esse lançamento.'         
		from TB_Conta 
		where cd_centro_custo=@CCDestino and codigo_conta like '%1001' 

		select @identify = @@IDENTITY 
		if @identify is null 
		Begin
		   Set @WL_Mensagem = 'Erro na criação do Lançamento de entrada do emprestimo.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End   
		       
		--Forma lancamento
		Insert Into TB_FormaLancamento
		(Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,Valor_Previsto, 
		 Data_Documento, Data_Pagamento, Data_lancamento,Data_HoraLancamento, 
		 Sequencial_Lancamento, Sequencial_Historico,Nome_Usuario)

		Values (1, 7, @valor, @valor, 
			@dtEmprestimo, @dtEmprestimo, @dtEmprestimo, GetDate(), 
			@@IDENTITY, @Sequencial_HistoricoDestino, @nomeusuario )

		if @@ROWCOUNT <> 1 
		Begin
		   Set @WL_Mensagem = 'Erro na criação da Forma de Lançamento de Entrada do emprestimo.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End         

		-- ********************************
		-- Lançamento devolucao saída - Previsto
		-- ********************************
		Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta, nome_outros, nome_usuario, Mensagem_Delecao)
		                    
		Select 2, 'Devolução de Empréstimo Tomado:' + @Descricao_CentroCustoOrigem, Sequencial_Conta,     
		@nomeusuario, @nomeusuario, 'Somente o usuario do lancamento de saída pode excluir esse lançamento.'         
		from TB_Conta 
		where cd_centro_custo=@CCDestino and codigo_conta like '%1101'

		select @identify = @@IDENTITY 
		if @identify is null 
		Begin
		   Set @WL_Mensagem = 'Erro na criação do Lançamento de devolução do emprestimo tomado.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End   
		       
		--Forma lancamento
		Insert Into TB_FormaLancamento
		(Tipo_ContaLancamento, Forma_lancamento, Valor_Previsto, 
		 Data_Documento, Data_HoraLancamento, 
		 Sequencial_Lancamento, Sequencial_Historico,Nome_Usuario)

		Values (2, 7, @valor,  
			@DtPrevisaoDevolucao, GetDate(), 
			@@IDENTITY, @Sequencial_HistoricoDestino, @nomeusuario )

		if @@ROWCOUNT <> 1 
		Begin
		   Set @WL_Mensagem = 'Erro na criação da Forma de Lançamento de devolução do emprestimo tomado.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End      

				
		-- ********************************
		-- Lançamento devolucao entrada - Previsto
		-- ********************************
		Insert Into TB_Lancamento (Tipo_Lancamento, Historico, Sequencial_Conta,Sequencial_Lancamento_Origem, nome_outros, nome_usuario, Mensagem_Delecao)
		                    
		Select 1, 'Devolução de Empréstimo Cedido:' + @Descricao_CentroCustoDestino, Sequencial_Conta, @@IDENTITY,    
		@nomeusuario, @nomeusuario, 'Somente o usuario do lancamento de saída pode excluir esse lançamento.'         
		from TB_Conta 
		where cd_centro_custo=@CCOrigem and codigo_conta like '%1002'

		select @identify = @@IDENTITY 
		if @identify is null 
		Begin
		   Set @WL_Mensagem = 'Erro na criação do Lançamento de Devolução de Empréstimo Cedido.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End   
		       
		--Forma lancamento
		Insert Into TB_FormaLancamento
		(Tipo_ContaLancamento, Forma_lancamento, Valor_Previsto, 
		 Data_Documento, Data_HoraLancamento, 
		 Sequencial_Lancamento, Sequencial_Historico,Nome_Usuario)

		Values (1, 7, @valor,  
			@DtPrevisaoDevolucao, GetDate(), 
			@@IDENTITY, @Sequencial_HistoricoOrigem, @nomeusuario )

		if @@ROWCOUNT <> 1 
		Begin
		   Set @WL_Mensagem = 'Erro na criação da Forma de Lançamento de Entrada do emprestimo.'
		   RAISERROR (@WL_Mensagem, 16, 1)
		   Return
		End  
		         
     Commit Transaction        

End 
