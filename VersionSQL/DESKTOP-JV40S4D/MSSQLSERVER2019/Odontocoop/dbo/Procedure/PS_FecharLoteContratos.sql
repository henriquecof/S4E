/****** Object:  Procedure [dbo].[PS_FecharLoteContratos]    Committed by VersionSQL https://www.versionsql.com ******/

/*
Objetivo : Criado para fechar automaticamente os lotes de contratos
           na virada do mês.
Marcio Nogueira Costa
*/
CREATE Procedure [dbo].[PS_FecharLoteContratos]
As
Begin
 
  if day(getdate()) = 1 
    begin
     update lote_contratos set
            dt_finalizado = getdate()
     where dt_finalizado is null and
           dt_cadastro < getdate()
    end 
End
