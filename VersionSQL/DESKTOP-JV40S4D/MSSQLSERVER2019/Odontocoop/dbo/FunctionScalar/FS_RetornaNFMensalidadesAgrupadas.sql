/****** Object:  Function [dbo].[FS_RetornaNFMensalidadesAgrupadas]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_RetornaNFMensalidadesAgrupadas](@codigo int)
Returns Varchar(1000)
As
Begin
   
   Declare @retorno varchar(1000)
   Declare @nf as varchar(100)
   
   Set @retorno = ''
   Declare cursor_nfs CURSOR FOR
     
   		 select T2.nf
		 from MensalidadesAgrupadas T1
		 inner Join Mensalidades T2 on T1.cd_parcela = T2.cd_parcela 
		 where T1.cd_parcelaMae = @codigo 
		
    open cursor_nfs
    
   fetch next from cursor_nfs into @nf
   
   while (@@fetch_status<>-1)
   begin
     if len(@retorno)>0 
        set @retorno = @retorno + ', ' + @nf 
     else
        Set @retorno = @nf
        
     fetch next from cursor_nfs into @nf
   End 
   
   Close cursor_nfs
   Deallocate cursor_nfs
   
   Return @retorno  
End
