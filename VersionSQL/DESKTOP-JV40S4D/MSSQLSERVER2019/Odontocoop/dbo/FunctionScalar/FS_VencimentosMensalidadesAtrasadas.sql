/****** Object:  Function [dbo].[FS_VencimentosMensalidadesAtrasadas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_VencimentosMensalidadesAtrasadas](@codigo int, @tpEmpresa int)
Returns Varchar(max)
As
Begin
   
   Declare @retorno varchar(max)
   Declare @vencimento varchar(max)
   declare @sql varchar(max)
   
   Set @retorno = ''
   Declare cursor_mensalidade CURSOR FOR
   
		select convert(varchar(10),isnull(dt_vencimento_new,dt_vencimento),103) as dt_vencimento 
		from Mensalidades
		where cd_tipo_recebimento = 0
		and isnull(dt_vencimento_new, dt_vencimento) < convert(varchar(10), getdate(), 101)
		and cd_associado_empresa = @codigo
		and tp_associado_empresa = @tpEmpresa
		
    open cursor_mensalidade
    
   fetch next from cursor_mensalidade into @vencimento
   
   while (@@fetch_status<>-1)
   begin
     if len(@retorno)>0 
        set @retorno = @retorno + '; ' + @vencimento 
     else
        Set @retorno = @vencimento
        
     fetch next from cursor_mensalidade into @vencimento
   End 
   
   Close cursor_mensalidade
   Deallocate cursor_mensalidade
   
   Return @retorno  
End
