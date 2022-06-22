/****** Object:  Function [dbo].[FS_RetornaVencimentoMensalidadesAgrupadas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaVencimentoMensalidadesAgrupadas](@codigo int)
Returns Varchar(1000)
As
Begin
   
   Declare @retorno varchar(1000)
   Declare @vencimento as varchar(100)
   
   Set @retorno = ''
   Declare cursor_vencimentos CURSOR FOR
     
   		 select convert(varchar(10),T2.dt_vencimento,103) dt_vencimento
		 from MensalidadesAgrupadas T1
		 inner Join Mensalidades T2 on T1.cd_parcela = T2.cd_parcela 
		 where T1.cd_parcelaMae = @codigo 
		
    open cursor_vencimentos
    
   fetch next from cursor_vencimentos into @vencimento
   
   while (@@fetch_status<>-1)
   begin
     if len(@retorno)>0 
        set @retorno = @retorno + ', ' + @vencimento 
     else
        Set @retorno = @vencimento
        
     fetch next from cursor_vencimentos into @vencimento
   End 
   
   Close cursor_vencimentos
   Deallocate cursor_vencimentos
   
   Return @retorno  
End
