/****** Object:  Function [dbo].[FS_RetornaContratosPorAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaContratosPorAssociado](@cd_associado int)    
Returns Varchar(1000)    
As    
Begin    
       
   Declare @retorno varchar(1000)    
   Declare @nr_contrato as varchar(100)    
       
     
    
   Set @retorno = ''    
   Declare cursor_contrato_associado CURSOR FOR    
   Select distinct nr_contrato     
   from dependentes     
   Where cd_associado = @cd_associado  
   ORDER BY nr_contrato ASC  
    open cursor_contrato_associado    
   fetch next from cursor_contrato_associado into @nr_contrato    
   while (@@fetch_status<>-1)    
   begin    
     if len(@retorno)>0   
        set @retorno = @retorno + '_' + @nr_contrato     
     else    
        Set @retorno = @nr_contrato    
            
     fetch next from cursor_contrato_associado into @nr_contrato    
   End     
   Close cursor_contrato_associado    
   Deallocate cursor_contrato_associado    
       
   Return @retorno      
End    
