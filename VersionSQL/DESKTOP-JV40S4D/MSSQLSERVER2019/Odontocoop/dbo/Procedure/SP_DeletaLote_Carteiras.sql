/****** Object:  Procedure [dbo].[SP_DeletaLote_Carteiras]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_DeletaLote_Carteiras] @lote int 
as 
Begin 
Declare @dt_fec date 
select @dt_fec = dt_fechamento from Lotes_Carteiras where SQ_Lote = @lote 
if @dt_fec is not null 
Begin 
RAISERROR ('Lote fechado não pode ser excluído.', 16, 1) 
RETURN	
End 

Begin tran 

update lote_processos_bancos set cd_sequencial_lote_carteira=null where cd_sequencial_lote_carteira=@lote 
if @@error >0 
Begin 
RAISERROR ('Erro na liberação do lote de processos bancos.', 16, 1) 
rollback 
RETURN 
End

delete Carteiras where sq_lote in (@lote) 
if @@error >0 
Begin 
RAISERROR ('Erro na exclusão das carteiras.', 16, 1) 
rollback 
RETURN 
End 

delete Lotes_Carteiras where sq_lote in (@lote) 
if @@error >0 
Begin 
RAISERROR ('Erro na esclusão do lote de carteiras.', 16, 1) 
rollback 
RETURN 
End	

Commit 
End
