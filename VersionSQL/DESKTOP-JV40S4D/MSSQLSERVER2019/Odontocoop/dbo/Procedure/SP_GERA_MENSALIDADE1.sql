/****** Object:  Procedure [dbo].[SP_GERA_MENSALIDADE1]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE procedure [dbo].[SP_GERA_MENSALIDADE1]
	@wl_venc datetime,
	@codigo_PK integer, -- Caso Empresa: Codigo da Empresa, Associado: Codigo do Associado
    @tp_empresa integer,
    @Sequencial_LogMensalidades integer = 0 , -- Codigo Sequencial da Tabela de Log_Mensalidades, para informar se a mesma foi regerada
    @cd_parcela integer = 0 -- Codigo da Parcela para cancelar
as
begin -- 1
 
    if @cd_parcela > 0 and @Sequencial_LogMensalidades > 0 
    Begin -- 1.1
  	  ROLLBACK TRANSACTION
	  Raiserror('Erro na exclusão da Mensalidade.',16,1)
	  RETURN
    End -- 1.1

   print @Sequencial_LogMensalidades
   print @cd_parcela

end -- 1
