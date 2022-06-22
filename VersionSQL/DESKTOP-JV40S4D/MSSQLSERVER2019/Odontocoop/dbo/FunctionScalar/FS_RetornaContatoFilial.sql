/****** Object:  Function [dbo].[FS_RetornaContatoFilial]    Committed by VersionSQL https://www.versionsql.com ******/

create Function [dbo].[FS_RetornaContatoFilial](@codigo int, @OrigemInformacao int, @tipoContato int)
Returns Varchar(1000)
As
Begin

   -- @tipoContato =1 Apenas Telefone
   -- @tipoContato =2 Apenas Email 
   -- @tipoContato =3 Telefone e e-mail 
   
   
   Declare @retorno varchar(1000)
   Declare @nm_fone as varchar(100)
   Declare @tteseq_i int 
   Declare @tteseq_f int 
   
   if @tipoContato =1
     select @tteseq_i=0 ,@tteseq_f=50
     
   if @tipoContato =2
     select @tteseq_i=49 ,@tteseq_f=100      
     
   if @tipoContato =3
     select @tteseq_i=0 ,@tteseq_f=999

   Set @retorno = ''
   Declare cursor_contato CURSOR FOR
   Select case when ttesequencial < 50 then '('+substring(tusTelefone,1,2)+')'+substring(tusTelefone,3,20) else tusTelefone end 
   from tb_contato 
   Where cd_origeminformacao = @OrigemInformacao and cd_sequencial = @codigo and fl_ativo = 1 and 
         ttesequencial > @tteseq_i and ttesequencial < @tteseq_f and 
         divulgar_rede <>0
         
   order by tusQuantidade desc 
    open cursor_contato
   fetch next from cursor_contato into @nm_fone
   while (@@fetch_status<>-1)
   begin
     if len(@retorno)>0 
        set @retorno = @retorno + ', ' + @nm_fone 
     else
        Set @retorno = @nm_fone
        
     fetch next from cursor_contato into @nm_fone
   End 
   Close cursor_contato
   Deallocate cursor_contato
   
   Return @retorno  
End
