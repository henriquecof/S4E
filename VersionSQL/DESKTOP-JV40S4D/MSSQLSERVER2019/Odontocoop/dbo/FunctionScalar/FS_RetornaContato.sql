/****** Object:  Function [dbo].[FS_RetornaContato]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Function [dbo].[FS_RetornaContato](@codigo int, @OrigemInformacao int, @tipoContato int)
Returns Varchar(1000)
As
Begin
	-- @tipoContato = 1 Telefone
	-- @tipoContato = 2 E-mail
	-- @tipoContato = 3 Telefone e e-mail
	-- @tipoContato = 4 Site
   
	Declare @retorno varchar(1000)
	Declare @tusTelefone varchar(100)
	Declare @tusQuantidade int
	Declare @tteseq_i int
	Declare @tteseq_f int
	Declare @cd_grau_parentesco int
  
	if @tipoContato = 1
		select @tteseq_i = 0, @tteseq_f = 50
     
	if @tipoContato = 2
		select @tteseq_i = 49, @tteseq_f = 100
     
	if @tipoContato = 3
		select @tteseq_i = 0, @tteseq_f = 999
	
	if @tipoContato = 4
		select @tteseq_i = 50, @tteseq_f = 52

	Set @retorno = ''
	Set @cd_grau_parentesco = -1
	
	if (@OrigemInformacao = 1) --Associados. Exibir também dados do titular do plano.
		begin
			declare cursor_contato CURSOR FOR
				select distinct x.tusTelefone, x.tusQuantidade
				from (
				select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
				from tb_contato
				where cd_origeminformacao = @OrigemInformacao
				and cd_sequencial = @codigo
				and fl_ativo = 1
				and ttesequencial > @tteseq_i
				and ttesequencial < @tteseq_f
				union all
				select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
				from tb_contato
				where cd_origeminformacao = 5
				and cd_sequencial = (select top 1 cd_sequencial from dependentes where cd_associado = @codigo and cd_grau_parentesco = 1)
				and fl_ativo = 1
				and ttesequencial > @tteseq_i
				and ttesequencial < @tteseq_f
				) x
				order by x.tusQuantidade desc
			open cursor_contato
		end
	else if (@OrigemInformacao = 5) --Dependentes. Se for titular, exibir dados.
		begin
			select @cd_grau_parentesco = isnull(cd_grau_parentesco,-1)
			from dependentes
			where cd_sequencial = @codigo
			
			if(@cd_grau_parentesco = 1)
				begin
					declare cursor_contato CURSOR FOR
						select distinct x.tusTelefone, x.tusQuantidade
						from (
						select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
						from tb_contato
						where cd_origeminformacao = @OrigemInformacao
						and cd_sequencial = @codigo
						and fl_ativo = 1
						and ttesequencial > @tteseq_i
						and ttesequencial < @tteseq_f
						union all
						select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
						from tb_contato
						where cd_origeminformacao = 1
						and cd_sequencial = (select cd_associado from dependentes where cd_sequencial = @codigo)
						and fl_ativo = 1
						and ttesequencial > @tteseq_i
						and ttesequencial < @tteseq_f
						) x
						order by x.tusQuantidade desc
					open cursor_contato
				end
			else
				begin
					declare cursor_contato CURSOR FOR
						select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
						from tb_contato
						where cd_origeminformacao = @OrigemInformacao
						and cd_sequencial = @codigo
						and fl_ativo = 1
						and ttesequencial > @tteseq_i
						and ttesequencial < @tteseq_f
						order by tusQuantidade desc
					open cursor_contato
				end
		end
	else
		begin
			declare cursor_contato CURSOR FOR
				select case when ttesequencial < 50 then '(' + substring(tusTelefone,1,2) + ')' + substring(tusTelefone,3,20) else tusTelefone end tusTelefone, tusQuantidade
				from tb_contato
				where cd_origeminformacao = @OrigemInformacao
				and cd_sequencial = @codigo
				and fl_ativo = 1
				and
					case
						when @OrigemInformacao = 4 then --Clínica
							isnull(convert(int,divulgar_rede),1)
						when @OrigemInformacao = 7 then --Endereço complementar
							isnull(convert(int,divulgar_rede),0)
						else
							1
					end = 1
				and ttesequencial > @tteseq_i
				and ttesequencial < @tteseq_f
				order by tusQuantidade desc
			open cursor_contato
		end

		fetch next from cursor_contato into @tusTelefone, @tusQuantidade
		while (@@fetch_status <> -1)
			begin
				if len(@retorno) > 0
					set @retorno = @retorno + ', ' + @tusTelefone
				else
					Set @retorno = @tusTelefone
	        
			fetch next from cursor_contato into @tusTelefone, @tusQuantidade
		End
		Close cursor_contato
			Deallocate cursor_contato
   
	Return @retorno
End
