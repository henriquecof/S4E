/****** Object:  Procedure [dbo].[PS_IncluiSolicitacaoProtocolo]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Criado por : Marcio N. Costa em 12/11/2007
Procedure  : PS_IncluiSolicitacaoProtocolo
Objetivo   : Cria registro com solicitação do protocolo TB_SolicitacaoProtocolo e 
             cria registro em protocolo TB_Protocolo caso não exista.
*/
CREATE Procedure [dbo].[PS_IncluiSolicitacaoProtocolo](
           @Codigo Int,
           @TipoUsuario Smallint,
           @ValorContrato Numeric(18,2),
           @CDAssociado Int,
           @CDSequencialDep Int,
           @TipoSolicitacao SmallInt,
           @Status SmallInt,
           @DSSolicitacao Varchar(1000),
           @CDFuncionario Int,
           @Anexo Varchar(50))
As
Begin
  
  Declare @SequencialProtocolo Int
  Declare @DataAbertura DateTime

  -- Caso seja tipo de solicitação de cadastro de usuário.
  If @CDAssociado = 0 
     Select @CDAssociado = IsNull(Max(cd_associado),0) From Associados

  -- Caso seja solicitação de cadastro de um novo dependente.
  If @CDSequencialDep = 0 
     Select @CDSequencialDep = IsNull(Max(cd_sequencial),0) From Dependentes
          Where CD_Associado = @CDAssociado

  If @TipoUsuario = 2 -- Empresa
     Begin
          Set @SequencialProtocolo = 0            
          Select @SequencialProtocolo = IsNull(Max(Sequencial_Protocolo),0)                       
             From  TB_Protocolo 
             Where CD_Empresa           = @Codigo And
                   Data_Fechamento is Null
          
         If @SequencialProtocolo = 0            
            Begin
                Insert into TB_Protocolo 
                   (Data_Abertura, Data_Fechamento, CD_Empresa,CD_Funcionario,CD_Associado, CD_Dentista)
                Values
                  (GetDate(),null,@Codigo,null,null,null)

               Select @SequencialProtocolo = Max(Sequencial_Protocolo)                       
                 From  TB_Protocolo 
                 Where CD_Empresa           = @Codigo And
                       Data_Fechamento is Null               
            End  
      End 

  If @TipoUsuario = 4 -- Funcionario
     Begin
          Set @SequencialProtocolo = 0
          Select @SequencialProtocolo = IsNull(Max(T1.Sequencial_Protocolo),0)
             From TB_Protocolo as T1, TB_SolicitacaoProtocolo as T2, Associados as T3
	         Where T1.Sequencial_Protocolo = T2.Sequencial_Protocolo And
	               T2.CD_Associado = T3.CD_Associado And
                   T3.CD_Empresa = @Codigo And
                   T1.CD_Funcionario = @CDFuncionario And
                   T1.Data_Fechamento is Null And
                   datediff(day,T1.Data_Abertura,getdate()) = 0

         If @SequencialProtocolo = 0
            Begin
                Insert into TB_Protocolo
                   (Data_Abertura, Data_Fechamento, CD_Empresa, CD_Funcionario, CD_Associado, cd_dentista)
                    Values(GetDate(), null, null, @CDFuncionario, null, null)

				  Select @SequencialProtocolo = Max(T1.Sequencial_Protocolo)
					 From TB_Protocolo as T1
					 Where T1.CD_Funcionario = @CDFuncionario And
						   T1.Data_Fechamento is Null And
						   datediff(day,T1.Data_Abertura,getdate()) = 0
            End
      End      

     -- Inclusão Solicitação
	  Insert into TB_SolicitacaoProtocolo 
	    	(Valor_Contrato, Data_cadastro, Sequencial_Protocolo, CD_ASSOCIADO, CD_SEQUENCIAL_DEP, Tipo_Solicitacao, DS_Solicitacao, Status, Anexo)
            Values (@ValorContrato, getdate(), @SequencialProtocolo, @CDAssociado, @CDSequencialDep, @TipoSolicitacao, @DSSolicitacao, @Status, @Anexo)
End
