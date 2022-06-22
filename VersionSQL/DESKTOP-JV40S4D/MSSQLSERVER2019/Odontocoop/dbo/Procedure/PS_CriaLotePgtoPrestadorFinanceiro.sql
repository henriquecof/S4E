/****** Object:  Procedure [dbo].[PS_CriaLotePgtoPrestadorFinanceiro]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[PS_CriaLotePgtoPrestadorFinanceiro]
    @cd_sequencial int , @dt_previsao_pagamento varchar(10) = ''
as
begin
	
	Declare @PagDentistaLancamento int = Null -- Lote Criado
	Declare @filial as int 
	Declare @funcionario as int 
	Declare @modelo int 
	Declare @cd_tipo_faturamento int 
	Declare @centro_custo int 
	Declare @vl_fixo money 
	Declare @LicencaS4E varchar(50)
	Declare @id_convenio int 
	declare @fl_separarproducaocompetencia smallint 
	Declare @competenciaFechamento varchar(6)

	select @LicencaS4E = LicencaS4E, @fl_separarproducaocompetencia=isnull(fl_separarproducaocompetencia,0)  from configuracao
	
	-- Verificar se o Sequencial nao esta em nenhum lote 
	Select @PagDentistaLancamento = p.cd_pgto_dentista_lanc,
	       @filial = p.cd_filial ,
	       @funcionario = p.cd_funcionario ,
	       @modelo = p.cd_modelo_pgto_prestador ,
	       @cd_tipo_faturamento = fi.cd_tipo_faturamento,
	       @vl_fixo = isnull(fi.Vl_fixo_Produtividade,0),
	       @centro_custo = p.cd_centro_custo,
		   @id_convenio = p.idConvenio_ans, 
		   @competenciaFechamento = convert(varchar(6), isnull(p.dt_previsao_pagamento,getdate()),112)
	  
	  from pagamento_dentista as p , filial as fi, FUNCIONARIO as f , Modelo_Pagamento_Prestador as m
	 where p.cd_filial = fi.cd_filial and 
	       p.cd_funcionario = f.cd_funcionario and 
	       p.cd_modelo_pgto_prestador = m.cd_modelo_pgto_prestador and 
	       p.cd_sequencial = @cd_sequencial 
	 
	if @@ROWCOUNT = 0 
	Begin
	  Raiserror('Lote do dentista nao encontrado.',16,1)
	  RETURN
	End   
	
	if @PagDentistaLancamento is not null 
	Begin
	  Raiserror('Lote já possui lote financeiro.',16,1)
	  RETURN
	End   	
	
	if @cd_tipo_faturamento=1 
	print 'entrou  tipo faturamento = 1'
		Select @PagDentistaLancamento = cd_pgto_dentista_lanc 
		  from Pagamento_Dentista_Lancamento 
		 where sequencial_lancamento is null and 
			   cd_filial = @filial and
			   cd_modelo_pgto_prestador = @modelo and 
			   cd_centro_custo = @centro_custo and 
			   cd_funcionario is null 
			   and isnull(idConvenio_ans,0) = isnull(@id_convenio,0)

    if @cd_tipo_faturamento=2
    	print 'entrou  tipo faturamento = 2'
		Select @PagDentistaLancamento = cd_pgto_dentista_lanc 
		  from Pagamento_Dentista_Lancamento 
		 where sequencial_lancamento is null and 
			   cd_filial is null and 
			   cd_modelo_pgto_prestador = @modelo and 
			   cd_centro_custo = @centro_custo and 
			   cd_funcionario = @funcionario 
			   and isnull(idConvenio_ans,0) = isnull(@id_convenio,0)

			   
   if @fl_separarproducaocompetencia=1 and @PagDentistaLancamento is not null
   Begin

      select top 1 @PagDentistaLancamento = case when @competenciaFechamento = convert(varchar(6), isnull(p.dt_previsao_pagamento,getdate()),112) then @PagDentistaLancamento else null end 
	    from pagamento_dentista as p 
	   where cd_pgto_dentista_lanc=@PagDentistaLancamento

   End 

	Begin transaction
    if @PagDentistaLancamento is null 
    begin 
    	print 'entrou  insert'
       insert Pagamento_Dentista_Lancamento (cd_filial,cd_funcionario,cd_modelo_pgto_prestador,dt_gerado,vl_lote ,vl_bruto,cd_centro_custo ,idConvenio_ans)
        values (case when @cd_tipo_faturamento = 1 then @filial else null end,case when @cd_tipo_faturamento = 1 then null else @funcionario end,@modelo,GETDATE(),0,0,@centro_custo,@id_convenio)
       if @@ROWCOUNT = 0 
       begin
          rollback 
		  Raiserror('Erro na criação do lote de pagamento.',16,1)
		  RETURN          
       End 
      
	   SELECT @PagDentistaLancamento = @@IDENTITY   -- Pega o Lote Gerado
	   if @PagDentistaLancamento is null 
		 begin
		  rollback
		  Raiserror('Erro na identificação do lote de pagamento.',16,1)
		  RETURN
	   End

     End 
     -- Atualizar o Lote de dentista com o Lote de Pagamento
     print 'entrou  update'
     update pagamento_dentista set cd_pgto_dentista_lanc = @PagDentistaLancamento, dt_previsao_pagamento = case when @dt_previsao_pagamento <> '' then @dt_previsao_pagamento else null end where cd_sequencial = @cd_sequencial
       if @@ROWCOUNT = 0
       begin
          rollback
          Raiserror('Erro ao anexar do lote de pagamento.',16,1)
          RETURN         
       End
       
		--*********************************************************************** 
		--Descontar os estornos
		--***********************************************************************
		Declare @valorLote Money
		Declare @valorImpostosRetidos Money
		Declare @cd_sequencialConsulta int
		Declare @valor Money
		Declare @valorEstornado Money
		
		select @valorLote = isnull(vl_bruto,0), @valorEstornado = isnull(valorEstorno,0) from Pagamento_Dentista_Lancamento where cd_pgto_dentista_lanc = @PagDentistaLancamento
		select @valorImpostosRetidos = isnull(sum(valor_aliquota),0) from pagamento_dentista_aliquotas where dt_exclusao is null and id_retido = 1 and cd_pgto_dentista_lanc = @PagDentistaLancamento
		
		if (@valorLote - @valorImpostosRetidos > 0)
			begin
				set @valorEstornado = 0

				if @cd_tipo_faturamento = 1
				--Clínica
					begin
						Declare cursorEstorno cursor for
							select cd_sequencialConsulta, isnull(valor,0) valor
							from EstornoPagamentoPrestador
							where cd_pgto_dentista_lanc is null
							and dataExclusao is null
							and cd_filial = @filial
							and
							case
								when @LicencaS4E = '0051AJHASAS9UJO9876TGHJNBGYUJHYTRFGHIKJHY654RTYUJ' then
									--Só calcular se o dentista tiver lote gerado
									(
										select count(0)
										from consultas T1
										inner join pagamento_dentista T2 on T2.cd_sequencial = T1.nr_numero_lote
										where T2.cd_pgto_dentista_lanc = @PagDentistaLancamento
										and T1.cd_funcionario = EstornoPagamentoPrestador.cd_funcionarioDentista
									)
								else
									1
							end
							> 0

							order by id
						open cursorEstorno
						fetch next from cursorEstorno into @cd_sequencialConsulta, @valor
						while (@@fetch_status <> -1)
							begin
								if (@valorEstornado + @valor > @valorLote - @valorImpostosRetidos and @valorEstornado + @valor <> @valorLote)
									break
								else
									update EstornoPagamentoPrestador set cd_pgto_dentista_lanc = @PagDentistaLancamento where cd_sequencialConsulta = @cd_sequencialConsulta
							
								fetch next from cursorEstorno into @cd_sequencialConsulta, @valor
							end
						close cursorEstorno
						deallocate cursorEstorno

						select @valorEstornado = isnull(sum(valor),0) from EstornoPagamentoPrestador where cd_pgto_dentista_lanc = @PagDentistaLancamento
					end
				
				if @cd_tipo_faturamento = 2
				--Dentista
					begin
						Declare cursorEstorno cursor for
							select cd_sequencialConsulta, isnull(valor,0) valor
							from EstornoPagamentoPrestador
							where cd_pgto_dentista_lanc is null
							and dataExclusao is null
							and cd_filial = @filial
							and cd_funcionarioDentista = @funcionario
							order by id
						open cursorEstorno
						fetch next from cursorEstorno into @cd_sequencialConsulta, @valor
						while (@@fetch_status <> -1)
							begin
								if (@valorEstornado + @valor > @valorLote - @valorImpostosRetidos and @valorEstornado + @valor <> @valorLote)
									break
								else
									update EstornoPagamentoPrestador set cd_pgto_dentista_lanc = @PagDentistaLancamento where cd_sequencialConsulta = @cd_sequencialConsulta
							
								fetch next from cursorEstorno into @cd_sequencialConsulta, @valor
							end
						close cursorEstorno
						deallocate cursorEstorno

						select @valorEstornado = isnull(sum(valor),0) from EstornoPagamentoPrestador where cd_pgto_dentista_lanc = @PagDentistaLancamento
					end
				
				if (@valorEstornado > 0)
					begin
						print 'Chama Dedução'
						update Pagamento_Dentista_Lancamento set vl_acerto = -@valorEstornado, vl_bruto = isnull(vl_lote,0) - @valorEstornado, valorEstorno = @valorEstornado where cd_pgto_dentista_lanc = @PagDentistaLancamento
						exec SP_Deducao_Prestador @PagDentistaLancamento
					end
					
				if (@valorEstornado = @valorLote)
					begin
						update pagamento_dentista_aliquotas set dt_exclusao = getdate() where dt_exclusao is null and cd_pgto_dentista_lanc = @PagDentistaLancamento
					end
			end
		
		--***********************************************************************
     
      commit
End
