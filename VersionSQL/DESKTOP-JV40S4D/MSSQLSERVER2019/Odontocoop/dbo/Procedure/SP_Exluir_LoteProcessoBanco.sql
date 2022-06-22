/****** Object:  Procedure [dbo].[SP_Exluir_LoteProcessoBanco]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Exluir_LoteProcessoBanco] @Lote int 
As
Begin
    Declare @dt_finalizado date 
    select @dt_finalizado = dt_finalizado from lote_processos_bancos where cd_sequencial = @Lote
    if @dt_finalizado is not null 
    begin
	  Raiserror('Lote finalizado nao pode ser excluido.',16,1)
	  RETURN
    End
    
    Begin tran
	update mensalidades set cd_lote_processo_banco = null where cd_lote_processo_banco = @Lote 
    if @@error >0 
    begin
	  Raiserror('Erro na ação de desvincular a mensalidade.',16,1)
	  rollback
	  RETURN
    End
    	
	delete lote_processos_bancos_mensalidades where cd_sequencial_lote = @Lote 
    if @@error >0 
    begin
	  Raiserror('Erro na ação de exclusao dos detalhes do arquivo.',16,1)
	  rollback
	  RETURN
    End
    
	delete lote_processos_bancos where cd_sequencial = @Lote
    if @@error >0 
    begin
	  Raiserror('Erro na ação de exclusao do arquivo.',16,1)
	  rollback
	  RETURN
    End
    
    commit 
    
End 
