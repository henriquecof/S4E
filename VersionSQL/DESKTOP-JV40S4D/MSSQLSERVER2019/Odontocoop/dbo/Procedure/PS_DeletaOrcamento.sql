/****** Object:  Procedure [dbo].[PS_DeletaOrcamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_DeletaOrcamento]
   (@Orcamento Int)
AS 
 Begin
   Declare @Associado Int

   Set @Associado = 0
   Select @Associado = cd_associado
    From  orcamento_clinico  
    where cd_orcamento = @Orcamento

   If @Associado = 0 
      Begin 
          RAISERROR ('Orcamento inexistente.', 16, 1)
          Return        
      end 

    begin transaction
   
    Delete Mensalidades
     where cd_associado_empresa = @Associado
     and tp_associado_empresa = 1
     and cd_parcela in (select cd_parcela from Orcamento_Mensalidades
     where cd_associado_empresa = @Associado
      and cd_orcamento = @Orcamento)

    /*delete consultas
    where cd_sequencial in
    (select cd_sequencial_pp from orcamento_servico where cd_orcamento = @Orcamento)*/

    delete orcamento_servico
    where cd_orcamento = @Orcamento

    delete Orcamento_Mensalidades
    where cd_associado_empresa = @Associado
    and cd_orcamento = @Orcamento

     delete orcamento_clinico
     where cd_orcamento = @Orcamento

     delete comissao_vendedor
     where cd_orcamento = @Orcamento

     commit transaction

End   
