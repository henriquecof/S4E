/****** Object:  Function [dbo].[FS_RetornaLancamentosParcela]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_RetornaLancamentosParcela](@cd_parcela int)    
Returns Varchar(1000)    
As    
Begin    
       
   Declare @retorno varchar(1000)    
   Declare @lancamento as varchar(100)    
    
   Set @retorno = ''    
   Declare cursor_dados CURSOR FOR    
   
   Select distinct sequencial_lancamento     
   from tb_mensalidadeassociado     
   Where cd_parcela = @cd_parcela  
   and data_exclusao is null
   ORDER BY sequencial_lancamento ASC  
   
    open cursor_dados    
   fetch next from cursor_dados into @lancamento    
   while (@@fetch_status<>-1)    
   begin    
     if len(@retorno)>0   
        set @retorno = @retorno + '_' + @lancamento     
     else    
        Set @retorno = @lancamento    
            
     fetch next from cursor_dados into @lancamento    
   End     
   Close cursor_dados    
   Deallocate cursor_dados    
       
   Return @retorno      
End   
