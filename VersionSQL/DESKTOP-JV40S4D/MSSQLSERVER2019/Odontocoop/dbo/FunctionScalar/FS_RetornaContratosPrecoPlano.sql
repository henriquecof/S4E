/****** Object:  Function [dbo].[FS_RetornaContratosPrecoPlano]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaContratosPrecoPlano](@codigo int)
Returns Varchar(1000)
As
Begin
   
   Declare @retorno varchar(1000)
   Declare @contrato as varchar(100)
   
   Set @retorno = ''
   Declare cursor_contrato CURSOR FOR
   
		select nr_contrato_plano
		from preco_plano
		where dt_fim_comercializacao is null
		and (fl_inativo is null or fl_inativo = 0)
		and cd_empresa = @codigo
		
    open cursor_contrato
    
   fetch next from cursor_contrato into @contrato
   
   while (@@fetch_status<>-1)
   begin
     if len(@retorno)>0 
        set @retorno = @retorno + ', ' + @contrato 
     else
        Set @retorno = @contrato
        
     fetch next from cursor_contrato into @contrato
   End 
   
   Close cursor_contrato
   Deallocate cursor_contrato
   
   Return @retorno  
End
