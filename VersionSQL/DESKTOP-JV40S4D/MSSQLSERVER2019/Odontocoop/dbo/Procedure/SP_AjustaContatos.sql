/****** Object:  Procedure [dbo].[SP_AjustaContatos]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SP_AjustaContatos] @codigo int, @Contato tinyint -- 1 - associado, 3-empresa
as
Begin
  
    Declare @sql varchar(max)
    
    Set @sql = case when @codigo = 0 and @Contato = 1 then 'delete TB_Contatoassociado where cd_associado is not null '
		            when @codigo = 0 then 'delete TB_Contatoassociado where cd_empresa is not null '
                    when @codigo > 0 and @Contato = 1 then 'delete TB_Contatoassociado where cd_associado = ' + convert(varchar(20),@codigo)
		            else 'delete TB_Contatoassociado where cd_empresa = ' + convert(varchar(20),@codigo)
               end 
    exec (@SQL)
    
	Declare @cod int 
	Declare @tel varchar(1000)
	Declare @dt date 
	Declare @dta date 
	Declare @qtde int
	Declare @tipo tinyint -- 1 - Telefone, 2-email  
	Set @sql = 'Declare Cursor_Cont Cursor For '
	Set @sql = @sql + ' select cd_sequencial, tusTelefone , case when ttesequencial<50 then 1 else 2 end,tusdtatualizacao, tusDtCadastro from TB_Contato where cd_origeminformacao in (' + case when @Contato =1 then '1' else '3' end + ') and fl_ativo = 1 and ttesequencial<=50 ' 
 	if @codigo > 0 
 	   Set @sql = @sql + ' and cd_sequencial = ' + convert(varchar(20),@codigo) 
 	   
 	if @Contato = 1 
	begin    
	  Set @sql = @sql + '  union 
	     select d.CD_ASSOCIADO, tusTelefone, case when ttesequencial<50 then 1 else 2 end,tusdtatualizacao, tusDtCadastro from TB_Contato as c, DEPENDENTES as d where cd_origeminformacao in (5) and c.cd_sequencial = d.CD_SEQUENCIAL and d.CD_GRAU_PARENTESCO=1 and fl_ativo = 1 and ttesequencial<=50 ' 
 	  if @codigo > 0 
 	     Set @sql = @sql + ' and d.cd_Associado = ' + convert(varchar(20),@codigo)
    end 	
	Set @sql = @sql + ' order by tusdtatualizacao,tusDtCadastro '
	
    exec(@sql)
	Open Cursor_Cont  
	Fetch next from Cursor_Cont Into @cod,@tel,@tipo,@dta,@dt
	While (@@fetch_status <> -1)
	Begin 
	   if @Contato = 1 
          Select @qtde = COUNT(0) from TB_Contatoassociado where cd_associado=@cod 
       else 
          Select @qtde = COUNT(0) from TB_Contatoassociado where cd_empresa=@cod    
          
       if @qtde = 0 -- Incluir 
       begin
         Set @sql = 'insert into TB_Contatoassociado (' + case when @Contato=1 then 'cd_Associado' else 'cd_empresa' end + ',' + case when @tipo=1 then 'contato1' else 'email' end + ') values (' + CONVERT(varchar(20),@cod) + ',''' + @tel + ''')'
       end
       else -- Alterar
       begin
         if @tipo=1
		 begin 
		    Set @sql ='update TB_Contatoassociado set contato1='''+@tel+''',contato2=contato1,contato3=contato2,contato4=contato3 where ' + case when @Contato=1 then 'cd_Associado' else 'cd_empresa' end + ' = ' + CONVERT(varchar(20),@cod)
		 end  
		 else 
		 begin
		    Set @sql ='update TB_Contatoassociado set email=''' + @tel + ''' where ' + case when @Contato=1 then 'cd_Associado' else 'cd_empresa' end + ' = ' + CONVERT(varchar(20),@cod)
		 end
	   end
	   exec (@sql)
	   
	   Fetch next from Cursor_Cont Into @cod,@tel,@tipo ,@dta,@dt
	End
	Close Cursor_Cont
	Deallocate Cursor_Cont   
End 	
