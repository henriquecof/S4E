/****** Object:  Procedure [dbo].[SP_IncluiContraPartidaCaixa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_IncluiContraPartidaCaixa]
   (@SequencialLancamento int,
    @CaixaDestino int,
    @ContaAtual varchar(6))
As
Begin

   --VARIAVEIS---------------------------------------------------------------
   Declare @Sequencial_FormaLancamento Int
   Declare @Sequencial_Conta_Destino Int
   Declare @Historico Varchar(1500)
   Declare @Nome_Usuario Varchar(20)   
   Declare @Sequencial_Historico Int   
   Declare @Descricao_Movimentacao Varchar(80)   
   Declare @WL_Mensagem Varchar(1000)
   Declare @Forma_Lancamento smallint

   --DEPOSITO--------------------------------------------------------------
   If substring(@ContaAtual,3,2) = '40' --DEPOSITO
     Begin

       Set @Sequencial_Conta_Destino = null

       --Saber se a conta de contra-partida existe
       Select @Sequencial_Conta_Destino = Sequencial_Conta
         From TB_Conta where codigo_conta = '018201'      
     
       if @Sequencial_Conta_Destino is null 
         Begin
            RAISERROR ('Conta de recebimento de deposito não foi criada.', 16, 1)
            Return
         End       

         -- Lancamento de contrapartida
         Begin Transaction

        ---------- Buscando informações Lancamento atual --------------------------------
	     Select @Sequencial_FormaLancamento = Sequencial_FormaLancamento,
              @Forma_Lancamento           = Forma_Lancamento,
              @Historico                  = T2.Historico, 
			  @Nome_Usuario               = T2.Nome_Usuario
			From TB_FormaLancamento T1, TB_Lancamento T2, TB_Conta T3
			Where T1.Sequencial_Lancamento = T2.Sequencial_Lancamento And 
				  T2.Sequencial_Conta = T3.Sequencial_Conta And
				  T2.Sequencial_Lancamento = @SequencialLancamento

         ---------- Buscando informações do caixa especificado -------------------------
         Select @Sequencial_Historico = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaDestino
                 And Valor_Saldo_Final is null

         Set @Historico = 'REC. DEPOSITO : ' + @Historico  

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 1, @Historico, @Sequencial_Conta_Destino,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @SequencialLancamento,
           'Somente o usuario do lancamento de saída pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario

         --Tabela Forma de Lancamento. VAI FICAR PREVISTO     
		 Insert Into TB_FormaLancamento
		   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
			Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
			 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
			  Nome_Usuario,Conta_PrevistaAparecer)
		 Select 2, @Forma_Lancamento, Null,
			  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Null, Null,
			  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
			  @Nome_Usuario,1
		 From TB_FormaLancamento
		 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento

         --Se for cheque , replicar dados do cheque.
         If @Forma_Lancamento = 8
            Begin
 				  Insert Into TB_LancamentoCheque 
				  (Sequencial_FormaLancamento, Sequencial_Agencia, Numero_Cheque,  
				   Situacao_Cheque, nome_usuario,codigo_banco, codigo_agencia,numero_conta) 
				  Select (Select Max(Sequencial_FormaLancamento) From TB_FormaLancamento),
						  Sequencial_Agencia, Numero_Cheque,Situacao_Cheque, nome_usuario,  
						  codigo_banco, codigo_agencia,numero_conta
				  From TB_LancamentoCheque 
				  Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento
			End 
         
          Commit Transaction

     End

   --TRANSFERENCIA ENTRE CC --------------------------------------------------------------
   If substring(@ContaAtual,3,2) = '80' 
     Begin

       Set @Sequencial_Conta_Destino = null

       --Saber se a conta de contra-partida existe
       Select @Sequencial_Conta_Destino = Sequencial_Conta
         From TB_Conta where codigo_conta = '018301'      
     
       if @Sequencial_Conta_Destino is null 
         Begin
            RAISERROR ('Conta de recebimento de transferencia não foi criada.', 16, 1)
            Return
         End       

         -- Lancamento de contrapartida
         Begin Transaction

        ---------- Buscando informações Lancamento atual --------------------------------
	     Select @Sequencial_FormaLancamento = Sequencial_FormaLancamento,
              @Forma_Lancamento           = Forma_Lancamento,
              @Historico                  = T2.Historico, 
			  @Nome_Usuario               = T2.Nome_Usuario
			From TB_FormaLancamento T1, TB_Lancamento T2, TB_Conta T3
			Where T1.Sequencial_Lancamento = T2.Sequencial_Lancamento And 
				  T2.Sequencial_Conta = T3.Sequencial_Conta And
				  T2.Sequencial_Lancamento = @SequencialLancamento

         ---------- Buscando informações do caixa especificado -------------------------
         Select @Sequencial_Historico = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaDestino
                 And Valor_Saldo_Final is null

         Set @Historico = 'REC. TRANSFERENCIA : ' + @Historico  

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 1, @Historico, @Sequencial_Conta_Destino,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @SequencialLancamento,
           'Somente o usuario do lancamento de saída pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario

         --Tabela Forma de Lancamento. VAI FICAR PREVISTO     
		 Insert Into TB_FormaLancamento
		   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
			Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
			 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
			  Nome_Usuario,Conta_PrevistaAparecer)
		 Select 2, @Forma_Lancamento, Null,
			  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Null, Null,
			  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
			  @Nome_Usuario,1
		 From TB_FormaLancamento
		 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento

         --Se for cheque , replicar dados do cheque.
         If @Forma_Lancamento = 8
            Begin
 				  Insert Into TB_LancamentoCheque 
				  (Sequencial_FormaLancamento, Sequencial_Agencia, Numero_Cheque,  
				   Situacao_Cheque, nome_usuario,codigo_banco, codigo_agencia,numero_conta) 
				  Select (Select Max(Sequencial_FormaLancamento) From TB_FormaLancamento),
						  Sequencial_Agencia, Numero_Cheque,Situacao_Cheque, nome_usuario,  
						  codigo_banco, codigo_agencia,numero_conta
				  From TB_LancamentoCheque 
				  Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento
			End 
         
          Commit Transaction

     End


   --RETIRADA DE BANCO PARA CAIXA --------------------------------------------------------------
   If substring(@ContaAtual,3,2) = '81' 
     Begin

       Set @Sequencial_Conta_Destino = null

       --Saber se a conta de contra-partida existe
       Select @Sequencial_Conta_Destino = Sequencial_Conta
         From TB_Conta where codigo_conta = '018401'      
     
       if @Sequencial_Conta_Destino is null 
         Begin
            RAISERROR ('Conta de recebimento de retirada não foi criada.', 16, 1)
            Return
         End       

         -- Lancamento de contrapartida
         Begin Transaction

        ---------- Buscando informações Lancamento atual --------------------------------
	     Select @Sequencial_FormaLancamento = Sequencial_FormaLancamento,
                @Forma_Lancamento           = 7, --TEM QUE SER EM DINHEIRO
                @Historico                  = T2.Historico, 
			    @Nome_Usuario               = T2.Nome_Usuario
			From TB_FormaLancamento T1, TB_Lancamento T2, TB_Conta T3
			Where T1.Sequencial_Lancamento = T2.Sequencial_Lancamento And 
				  T2.Sequencial_Conta = T3.Sequencial_Conta And
				  T2.Sequencial_Lancamento = @SequencialLancamento

         ---------- Buscando informações do caixa especificado -------------------------
         Select @Sequencial_Historico = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaDestino
                 And Valor_Saldo_Final is null

         Set @Historico = 'REC. RETIRADA : ' + @Historico  

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 1, @Historico, @Sequencial_Conta_Destino,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @SequencialLancamento,
           'Somente o usuario do lancamento de saída pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario

         --Tabela Forma de Lancamento. VAI FICAR PREVISTO     
		 Insert Into TB_FormaLancamento
		   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
			Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
			 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
			  Nome_Usuario,Conta_PrevistaAparecer)
		 Select 2, @Forma_Lancamento, Null,
			  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Null, Null,
			  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
			  @Nome_Usuario,1
		 From TB_FormaLancamento
		 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento
         
          Commit Transaction

     End

   --RETIRADA DE BANCO PARA CAIXA --------------------------------------------------------------
   If substring(@ContaAtual,3,2) = '46' 
     Begin

       Set @Sequencial_Conta_Destino = null

       --Saber se a conta de contra-partida existe
       Select @Sequencial_Conta_Destino = Sequencial_Conta
         From TB_Conta where codigo_conta = '014701'      
     
       if @Sequencial_Conta_Destino is null 
         Begin
            RAISERROR ('Conta de recebimento de transferência não foi criada.', 16, 1)
            Return
         End       

         -- Lancamento de contrapartida
         Begin Transaction

        ---------- Buscando informações Lancamento atual --------------------------------
	     Select @Sequencial_FormaLancamento = Sequencial_FormaLancamento,
              @Forma_Lancamento           = Forma_Lancamento,
              @Historico                  = T2.Historico, 
			  @Nome_Usuario               = T2.Nome_Usuario
			From TB_FormaLancamento T1, TB_Lancamento T2, TB_Conta T3
			Where T1.Sequencial_Lancamento = T2.Sequencial_Lancamento And 
				  T2.Sequencial_Conta = T3.Sequencial_Conta And
				  T2.Sequencial_Lancamento = @SequencialLancamento

         ---------- Buscando informações do caixa especificado -------------------------
         Select @Sequencial_Historico = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @CaixaDestino
                 And Valor_Saldo_Final is null

         Set @Historico = 'REC. TRANSFERENCIA : ' + @Historico  

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 1, @Historico, @Sequencial_Conta_Destino,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @SequencialLancamento,
           'Somente o usuario do lancamento de saída pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario

         --Tabela Forma de Lancamento. VAI FICAR PREVISTO     
		 Insert Into TB_FormaLancamento
		   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
			Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
			 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
			  Nome_Usuario,Conta_PrevistaAparecer)
		 Select 2, @Forma_Lancamento, Null,
			  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Null, Null,
			  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
			  @Nome_Usuario,1
		 From TB_FormaLancamento
		 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento

         
          Commit Transaction

     End


END
