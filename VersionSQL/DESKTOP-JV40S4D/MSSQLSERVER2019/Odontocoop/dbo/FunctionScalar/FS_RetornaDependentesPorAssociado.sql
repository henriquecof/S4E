/****** Object:  Function [dbo].[FS_RetornaDependentesPorAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

create function [dbo].[FS_RetornaDependentesPorAssociado](@cd_associado int)    
Returns Varchar(1000)    
As    
Begin    
       
   Declare @retorno varchar(max)        
   Declare @dependentes as varchar(max)    
               
   set @retorno = ''    
   Declare cursor_dependentes_associado CURSOR FOR   
   
   select distinct 'Codigo: '+ convert(varchar(10),cd_sequencial) + ' - Nome: '  + nm_dependente
   + ' - Adesão: '+ convert(varchar(10),dt_assinaturaContrato,103) + ' - CPF: '  + isnull(dbo.formatarCPF(nr_cpf_dep),'')
   + ' - Carteira: ' + isnull(nr_carteira,'') 
   from dependentes     
   where cd_associado = @cd_associado
       
    open cursor_dependentes_associado        
   fetch next from cursor_dependentes_associado into @dependentes    
   while (@@fetch_status<>-1)    
   begin    
     if len(@retorno)>0   
        set @retorno = @retorno + '_' + @dependentes     
     else    
        Set @retorno = @dependentes    
            
     fetch next from cursor_dependentes_associado into @dependentes    
   End     
   Close cursor_dependentes_associado    
   Deallocate cursor_dependentes_associado    
       
   Return @retorno      
End
