/****** Object:  Procedure [dbo].[PS_excluiFormaLancamentoOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

 CREATE Procedure [dbo].[PS_excluiFormaLancamentoOrcamento](
   @Orcamento int,
   @usuario varchar(30))
 As
  Begin
     Declare @Associado Int
     
     --Saber se tem alguma parcela paga, se tiver não pode excluir.
     If (Select count(*)
			from mensalidades
			where cd_associado_empresa = (Select cd_associado from orcamento_clinico where cd_orcamento = @orcamento) And
		          tp_associado_empresa = 1 and
			      dt_pagamento is not null and
			      cd_parcela in (Select cd_parcela from orcamento_mensalidades Where cd_orcamento = @Orcamento)) > 0
      Begin
        Rollback
		RAISERROR ('Existe alguma parcela paga para esse orçamento. Exclusão da forma de pagamento não pode ser realizada.', 16, 1)
		Return
      End
      
        Begin Transaction
      
		Select @Associado = cd_associado From Orcamento_Clinico
		Where cd_orcamento = @Orcamento
		
		update orcamento_clinico set
    		cd_tipo_pagamento = null
		Where cd_orcamento = @Orcamento
		
		update mensalidades set
		   	   cd_tipo_recebimento=1, 
			   dt_baixa=getdate(), 
			   dt_alteracao=getdate(), 
			   cd_usuario_alteracao=@usuario,
			   CD_USUARIO_BAIXA = @usuario
    	where tp_associado_empresa = 1 And
	      	  cd_associado_empresa = @Associado And
		      cd_parcela in
	        	(Select cd_parcela
		           From orcamento_mensalidades
		           Where cd_orcamento = @Orcamento And
		                 cd_associado_empresa = @Associado)

		Delete From orcamento_mensalidades
		Where cd_orcamento = @Orcamento And
		cd_associado_empresa = @Associado
          
        Commit Transaction
End

 
