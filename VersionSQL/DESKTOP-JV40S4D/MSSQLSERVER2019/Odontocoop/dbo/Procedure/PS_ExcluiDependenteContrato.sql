/****** Object:  Procedure [dbo].[PS_ExcluiDependenteContrato]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_ExcluiDependenteContrato](@CD_Sequencial Int, @Lote int)
As
Begin
    
     Begin Transaction

     Insert into Historico (CD_SITUACAO,CD_SEQUENCIAL_dep,DT_SITUACAO,cd_usuario)
	 values (2, @CD_Sequencial, getdate(),null)

     delete from lote_contratos_contratos_vendedor
     where CD_SEQUENCIAL_DEP = @CD_Sequencial
           and cd_sequencial_lote = @Lote

     Commit transaction
End
