/****** Object:  Procedure [dbo].[SP_Configura_CC_Projetado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Configura_CC_Projetado] @cd_centro_custo smallint
as
Begin
  Declare @cd_centro_custo_f int = @cd_centro_custo
  if @cd_centro_custo= 0 
     Set @cd_centro_custo_f = 9999
 
  DECLARE cursor_projetado CURSOR FOR   
   select cd_centro_custo 
     from centro_custo
    where cd_centro_custo >= @cd_centro_custo and cd_centro_custo <= @cd_centro_custo_f
  OPEN cursor_projetado  
  FETCH NEXT FROM cursor_projetado INTO @cd_centro_custo
  WHILE (@@FETCH_STATUS <> -1)  
  begin
     insert configuracao_fluxoprojetado (cd_centro_custo, dia)
     select @cd_centro_custo, cd_dia 
       from centro_custo, dia_pagamento
      where cd_centro_custo = @cd_centro_custo and cd_dia not in (select dia from configuracao_fluxoprojetado where cd_centro_custo=@cd_centro_custo)
        and cd_dia <26
    
     FETCH NEXT FROM cursor_projetado INTO @cd_centro_custo
  End
  Close cursor_projetado
  Deallocate cursor_projetado
  
End 
