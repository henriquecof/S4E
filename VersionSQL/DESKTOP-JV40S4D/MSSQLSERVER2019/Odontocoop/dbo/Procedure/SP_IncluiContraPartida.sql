/****** Object:  Procedure [dbo].[SP_IncluiContraPartida]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_IncluiContraPartida]
       (@Sequencial_Lancamento Int,
        @Sequencial_Caixa_Destino Int)   
AS 
BEGIN	
   SET NOCOUNT ON;

   ------------------ Variaveis ------------------------------------      
   Declare @Sequencial_FormaLancamento Int
   Declare @Sequencial_Conta Int
   Declare @Codigo_Conta Varchar(6)
   Declare @Codigo_Conta_Destino Varchar(6)
   Declare @Sequencial_Conta_Destino Int
   Declare @Historico Varchar(1500)
   Declare @Nome_Usuario Varchar(20)   
   Declare @Sequencial_Movimentacao Int      
   Declare @Sequencial_Historico Int   
   Declare @Descricao_Movimentacao Varchar(80)   
   Declare @WL_Mensagem Varchar(1000)
   Declare @Sequencial_Historico_Consulta Int
   Declare @WL_tipocontalancamento smallint

   ---------- Buscando informações --------------------------------
   Select @Sequencial_FormaLancamento = Sequencial_FormaLancamento,
          @Sequencial_Conta           = T2.Sequencial_Conta,          
          @Historico                  = T2.Historico, 
          @Nome_Usuario               = T2.Nome_Usuario,
          @Codigo_Conta               = T3.Codigo_Conta,
          @Sequencial_Lancamento      = T1.Sequencial_Lancamento,
          @Sequencial_Historico_Consulta = IsNull(Sequencial_Historico_Consulta,0)
        From TB_FormaLancamento T1, TB_Lancamento T2, TB_Conta T3
        Where T1.Sequencial_Lancamento = T2.Sequencial_Lancamento And 
              T2.Sequencial_Conta = T3.Sequencial_Conta And
              T2.Sequencial_Lancamento = @Sequencial_Lancamento

    -- 1º)Passo : --------------------------------------------------------
    -- Saber se o lançamento é da conta 35 ou 46
    If Substring(@Codigo_Conta,3,2) In ('35','46')
      Begin
         -- 2º) Passo : --------------------------------------------------------
         -- Descobrir qual é o codigo destino para o lancamento.         
         If Substring(@Codigo_Conta,3,2) = '35'
            Set @Codigo_Conta_Destino = Substring(@Codigo_Conta,1,2) + '47' + Substring(@Codigo_Conta,5,2)
         Else
            Set @Codigo_Conta_Destino = Substring(@Codigo_Conta,1,2) + '66' + Substring(@Codigo_Conta,5,2)

         -- 3º) Passo : --------------------------------------------------------
         -- Descobrir se existe caixa de destino cadastrado.
         If @Codigo_Conta <> '013503' 
            Begin 
              Set @Sequencial_Movimentacao = 0 
              Select @Sequencial_Movimentacao = IsNull(T1.Sequencial_Movimentacao,0),
                     @Descricao_Movimentacao = T2.Descricao_Movimentacao
                  From TB_Conta T1, TB_MovimentacaoFinanceira T2
                  Where T1.Codigo_Conta =  @Codigo_Conta And 
                        T1.Sequencial_Movimentacao = T2.Sequencial_Movimentacao
             End
          Else 
             Begin
               Set @Sequencial_Movimentacao = @Sequencial_Caixa_Destino
             End  
        
         If @Sequencial_Movimentacao = 0 
            Begin
               RAISERROR ('Deve existir um caixa de destino cadastro para o lançamento de contrapartida que está sendo feito. Por favor entrar em contato com o administrador do sistema.', 16, 1)
               Return
            End          

        If (Select Sequencial_Agencia
             From  tb_movimentacaofinanceira
             Where Sequencial_Movimentacao = @Sequencial_Movimentacao) is null
           Begin
             --Lancamento entra como realizado para cxs que nao sao bancos
             Set @WL_tipocontalancamento = 1
           End
         Else
           Begin
             --Lancamento entra como previsto para cxs que sao bancos
             Set @WL_tipocontalancamento = 2
           End 

        -- 4º) Passo : --------------------------------------------------------
        -- Descobrir se existe caixa aberto para o lançamento de destino.
        Set @Sequencial_Historico = 0
        Select @Sequencial_Historico = Max(Sequencial_Historico)
           From TB_HistoricoMovimentacao
           Where Sequencial_Movimentacao = @Sequencial_Movimentacao And 
                 Data_Fechamento Is Null

        If @Sequencial_Historico = 0 
            Begin
               Set @WL_Mensagem = 'Deve existir caixa aberto para lançamento de contrapartida. Caixa que deveria está aberto : ' + @Descricao_Movimentacao
               RAISERROR (@WL_Mensagem, 16, 1)
               Return
            End             

        -- 5º) Passo : --------------------------------------------------------
        -- Lancamentos de contrapartida
         Begin Transaction

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 1, 'REC. SUPRIMENTO :' + @Historico, Sequencial_Conta,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @Sequencial_Lancamento,
           'Somente o usuario do lancamento de saída pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario
         From TB_Conta 
         Where Codigo_Conta = @Codigo_Conta_Destino         

         -- Tabela de Forma Lancamento.
         if @WL_tipocontalancamento = 1 
           Begin
				 Insert Into TB_FormaLancamento
				   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
					Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
					 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
					  Nome_Usuario,Conta_PrevistaAparecer)
				 Select 1, Forma_lancamento, IsNull(Valor_Previsto,Valor_Lancamento),
					  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Data_Documento, Data_Documento,
					  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
					  @Nome_Usuario,1
				 From TB_FormaLancamento
				 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento
           End
          Else
           Begin
				 Insert Into TB_FormaLancamento
				   (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
					Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
					 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
					  Nome_Usuario,Conta_PrevistaAparecer)
				 Select 2, Forma_lancamento, Null,
					  IsNull(Valor_Previsto,Valor_Lancamento), Data_Documento, Null, Null,
					  getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico,
					  @Nome_Usuario,1
				 From TB_FormaLancamento
				 Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento
           End
              
		        
        -- Se lançamento for em cheque , replicar registro.
        if (Select Forma_Lancamento  
                  From TB_FormaLancamento
                  Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento) = 2
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
    --6ºPasso: Caso seja uma conta 014701
    -- Nesse caso vai ser gerado um lançamento de entrada, a partir de uma lançamento de saida.
    If @Codigo_Conta = '014701'
      Begin
         -- 7º) Passo : --------------------------------------------------------
         -- Descrobrir qual é o codigo destino para o lancamento.                  
         Set @Codigo_Conta_Destino = '013501'          

         -- 8º) Passo : --------------------------------------------------------
         -- O caixa de destino vai vim no campo Sequencial_Historico_Consulta                 
         If @Sequencial_Historico_Consulta = 0 
            Begin
               Set @WL_Mensagem = 'Deve existir caixa aberto para lançamento de contrapartida. Caixa que deveria está aberto. Entre em contato com o administrador do sistema.' 
               RAISERROR (@WL_Mensagem, 16, 1)
               Return
            End                                  

        -- 9º) Passo : --------------------------------------------------------
        -- Lancamentos de contrapartida
         Begin Transaction

         -- Tabela de Lancamento.
         Insert Into TB_Lancamento 
           (Tipo_Lancamento, Historico, Sequencial_Conta,nome_outros, 
            nome_usuario, Sequencial_Lancamento_Origem,Mensagem_Delecao)         
         Select 2, 'ENVIO SUPRIMENTO :' + @Historico, Sequencial_Conta,     
           'Lancamento feito por ' + @Nome_Usuario, @Nome_Usuario,
           @Sequencial_Lancamento,
           'Somente o usuario do lancamento de entrada pode excluir esse lançamento. Nome do usuario : ' + @Nome_Usuario
         From TB_Conta 
         Where Codigo_Conta = @Codigo_Conta_Destino

         -- Tabela de Forma Lancamento.
         Insert Into TB_FormaLancamento
           (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
            Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
             Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
              Nome_Usuario,Conta_PrevistaAparecer)
         Select 2, Forma_lancamento, Null,
              Valor_Lancamento, Data_Documento, Null, Null,
              getdate(), (Select Max(Sequencial_Lancamento) From TB_Lancamento), @Sequencial_Historico_Consulta,
              @Nome_Usuario,1
         From TB_FormaLancamento
         Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento  

        -- 10º) Passo : --------------------------------------------------------
        -- Se lançamento for em cheque , replicar lançamento.
        if (Select Forma_Lancamento  
                  From TB_FormaLancamento
                  Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento) = 2
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

        -- 11º) Passo : --------------------------------------------------------
        -- Deixar nulo a variavel Sequencial_Historico_Consulta no lançamento inicial.
         Update TB_FormaLancamento Set 
              Sequencial_Historico_Consulta = Null
          Where Sequencial_FormaLancamento = @Sequencial_FormaLancamento 

         Commit Transaction              
    End

End
