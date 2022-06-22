/****** Object:  Procedure [dbo].[PS_GeraLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_GeraLancamento]
As
Begin
    -------------------------------------------------------------------
    -- Declaração de variaveis.
    -------------------------------------------------------------------        
	Declare @Sequencial_Aprazamento Int	
    Declare @Data_Documento Varchar(10)
    Declare @Valor_Lancamento decimal(18, 2)
	Declare @Historico Varchar(500)
	Declare @Tempo_Lancamento SmallInt	
	Declare @CD_Fornecedor Int
	Declare @CD_Funcionario Int
	Declare @CD_Associado Int 
	Declare @CD_Sequencial Int 
	Declare @CD_Dentista Int  
	Declare @CD_AssociadoEmpresa Int 
	Declare @Nome_Outros varchar(50)
	Declare @Numero_Prestacao smallint
	Declare @Numero_Atual_Prestacao smallint	
	Declare @Sequencial_Movimentacao int
    Declare @Sequencial_Conta int
    Declare @Tipo_Lancamento Smallint

    Declare @Sequencial_Historico int
    Declare @Data_Lancamento Varchar(10)
    Declare @Valor_Previsto decimal(18, 2)        
    Declare @WL_DataAtual Varchar(10)   
    Declare @WL_UltimoDiaDataAtual SmallDateTime
    Declare @WL_Grava smallint
    Declare @Conta_PrevistaAparecer smallint
    Declare @Conta_Alterada smallint

    -------------------------------------------------------------------
    -- Inicio programa.
    -------------------------------------------------------------------
    --Set @WL_DataAtual = '02/01/2008'
    Set @WL_DataAtual = getdate()

    If Day(@WL_DataAtual) <> 1 
      Begin 
        Return
      End               

    -- Ultimo dia do mês.
    Set @WL_UltimoDiaDataAtual = DateAdd(month,1,@WL_DataAtual)
    Set @WL_UltimoDiaDataAtual = DateAdd(day,-1,@WL_UltimoDiaDataAtual)

    ----------------------------------------------------------------------------
    -- 1º Passo : 
    -- Pegar todos os registros de aprazamento validos.
    ----------------------------------------------------------------------------                   
    Declare Cursor_Principal  Cursor For 
    Select  Sequencial_Aprazamento,convert(varchar,Data_Documento,101),Historico,
            Tempo_Lancamento,CD_Fornecedor,CD_Funcionario,CD_Associado,CD_Sequencial,         
            CD_AssociadoEmpresa,Nome_Outros,Numero_Prestacao,
            Sequencial_Conta,Tipo_Lancamento,Numero_Atual_Prestacao,  
            CD_Dentista,Valor_Lancamento,Sequencial_Movimentacao, 
            Sequencial_Conta
    From    TB_Aprazamento
    Where   Data_HoraExclusao Is Null And
            Gerar_Lancamento = 1 And      
            ((Numero_Prestacao > Numero_Atual_Prestacao) Or
             (Numero_Prestacao = 0)) And
              Data_Documento <=  @WL_UltimoDiaDataAtual              
              --Data_Documento <=  '12/01/2008'

    Open Cursor_Principal
       Fetch Next from Cursor_Principal 
       Into  @Sequencial_Aprazamento,@Data_Documento,@Historico,@Tempo_Lancamento,
             @CD_Fornecedor,@CD_Funcionario,@CD_Associado,@CD_Sequencial,         
             @CD_AssociadoEmpresa,@Nome_Outros,@Numero_Prestacao,
             @Sequencial_Conta,@Tipo_Lancamento,@Numero_Atual_Prestacao,  
             @CD_Dentista,@Valor_Lancamento,@Sequencial_Movimentacao,@Sequencial_Conta
   
    ----------------------------------------------------------------------------
    -- 2º Passo : 
    -- Entrando no laço principal.
    ----------------------------------------------------------------------------                   
    While (@@fetch_status  <> -1)
      Begin 
         --Somente para o caixa ABS_ALDEOTA
         If @Sequencial_Movimentacao = 16
            Begin
              Set @Conta_PrevistaAparecer = Null
              Set @Conta_Alterada = 0
            End       
         Else
            Begin
              Set @Conta_PrevistaAparecer = 1
              Set @Conta_Alterada = Null
            End

         -- Flag que informa se registro vai ser gerado ou não
         -- 1 - Grava , 2 - não grava
         Set @WL_Grava = 1 --default grava                  
             
         -- Registro do ultimo caixa aberto 
         Select @Sequencial_Historico = Sequencial_Historico
           From TB_HistoricoMovimentacao
           Where Data_Fechamento is null And 
                 Sequencial_Movimentacao = @Sequencial_Movimentacao
          
         -- Saber se existe lançamento feito já para o aprazamento, para pegar o valor.
         -- Se não existir pegar o valor que foi cadastrado.
         Set @Valor_Previsto = -1
         Set @Data_Lancamento = ''          

         Select  @Valor_Previsto =  Valor_Previsto,
                 @Data_Lancamento = convert(varchar,Data_Documento,101) 
           From  TB_FormaLancamento T1, TB_Lancamento T2
           Where T1.Sequencial_Lancamento  = T2.Sequencial_Lancamento And
                 T2.Sequencial_Aprazamento = @Sequencial_Aprazamento And
                 T2.Sequencial_Lancamento = (Select max(Sequencial_Lancamento) 
                                               From TB_Lancamento  t100 
                                               Where t100.sequencial_aprazamento = t2.sequencial_aprazamento)
         
         If @Valor_Previsto = -1
            -- Caso não exista ultimo lançamento.          
            Begin
              Set @Data_Lancamento = @Data_Documento
              Set @Valor_Previsto  = @Valor_Lancamento
            End 
         Else
            -- Existindo lançamento, testes gerais.
            Begin               
              If @Tempo_Lancamento = 1 --Mensal
                 Begin 
                    --Gerar a data com dia da data do documemento e mês e ano atual.
                    Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                 End

              If @Tempo_Lancamento = 2 --Bimestral
                 Begin 
                    -- veficar se faz dois meses do ultimo lançamento
                    If Datediff(month,@Data_Lancamento,@WL_DataAtual) = 2 
                       Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                    Else 
                       Set @WL_Grava = 0 --Não grava registro                    
                 End

               If @Tempo_Lancamento = 3 --Trimestral
                 Begin 
                    -- veficar se faz 3 meses do ultimo lançamento
                    If Datediff(month,@Data_Lancamento,@WL_DataAtual) = 3 
                       Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                    Else 
                       Set @WL_Grava = 0 --Não grava registro                    
                 End

               If @Tempo_Lancamento = 4 --Quadrimestral
                 Begin 
                    -- veficar se faz 4 meses do ultimo lançamento
                    If Datediff(month,@Data_Lancamento,@WL_DataAtual) = 4 
                       Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                    Else 
                       Set @WL_Grava = 0 --Não grava registro                    
                 End

               If @Tempo_Lancamento = 6 --Semestral
                 Begin 
                    -- veficar se faz 6 meses do ultimo lançamento
                    If Datediff(month,@Data_Lancamento,@WL_DataAtual) = 6 
                       Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                    Else 
                       Set @WL_Grava = 0 --Não grava registro                    
                 End

               If @Tempo_Lancamento = 12 --Anual
                 Begin 
                    -- veficar se faz 12 meses do ultimo lançamento
                    If Datediff(month,@Data_Lancamento,@WL_DataAtual) = 12 
                       Set @Data_Lancamento = convert(varchar,Month(@WL_DataAtual)) + '/' + convert(varchar,Day(@Data_Documento)) + '/' + convert(varchar,Year(@WL_DataAtual))
                    Else 
                       Set @WL_Grava = 0 --Não grava registro                    
                 End                                                 
            End 
         
         If @WL_Grava = 1 -- Grava registro      
           Begin                            
              --Altera Numero de prestações.
              If @Numero_Atual_Prestacao < @Numero_Prestacao
                Begin
                  Update TB_Aprazamento Set
                      Numero_Atual_Prestacao = Numero_Atual_Prestacao + 1
                  Where Sequencial_Aprazamento = @Sequencial_Aprazamento
                End                            

              -- Tabela de Lancamento.
              Insert Into TB_Lancamento 
                (Tipo_Lancamento, Historico, Sequencial_Conta,
                 nome_usuario, Sequencial_Aprazamento,
                 Mensagem_Delecao,cd_fornecedor, cd_funcionario, 
                 cd_associado, cd_sequencial, cd_dentista, 
                 cd_associadoempresa, nome_outros,Conta_Alterada)         
              Values
                (@Tipo_Lancamento, @Historico, @Sequencial_Conta,'SYS',
                 @Sequencial_Aprazamento, 'Somente a gerência pode excluir esse lançamento gerado automaticamente.',
                 @cd_fornecedor, @cd_funcionario, @cd_associado, @cd_sequencial, 
                 @cd_dentista, @cd_associadoempresa, @Nome_Outros,@Conta_Alterada)                                

              -- Tabela de Forma Lancamento.
              Insert Into TB_FormaLancamento
                (Tipo_ContaLancamento, Forma_lancamento, Valor_lancamento,
                 Valor_Previsto, Data_Documento, Data_Pagamento, Data_lancamento,
                 Data_HoraLancamento, Sequencial_Lancamento, Sequencial_Historico,
                 Nome_Usuario,Conta_PrevistaAparecer)
              Select 
                 2, 1, Null,
                 @Valor_Previsto,@Data_Lancamento, Null, Null,
                 getdate(), Max(Sequencial_Lancamento), @Sequencial_Historico,
                 'sys',@Conta_PrevistaAparecer                 
              From TB_Lancamento                       
           
           End

           --Proximo registro.
   Fetch Next from Cursor_Principal 
       Into  @Sequencial_Aprazamento,@Data_Documento,@Historico,@Tempo_Lancamento,
             @CD_Fornecedor,@CD_Funcionario,@CD_Associado,@CD_Sequencial,         
             @CD_AssociadoEmpresa,@Nome_Outros,@Numero_Prestacao,
             @Sequencial_Conta,@Tipo_Lancamento,@Numero_Atual_Prestacao,  
             @CD_Dentista,@Valor_Lancamento,@Sequencial_Movimentacao,@Sequencial_Conta
      End

    Close Cursor_Principal
    DEALLOCATE Cursor_Principal 

End
