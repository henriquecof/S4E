/****** Object:  Procedure [dbo].[PS_FechaFaturamentoEmpresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_FechaFaturamentoEmpresa]  
	@wl_diaCorte int = 0, @cd_tipo_pagamento int = 0, @funcionarioResponsavel int = 0 
As  
 
Begin  
   
    -- Se tipo_empresa for (2,6,7) gerar mensalidade da Empresa
    -- Se tipo_empresa nao for (2,6,7) gerar mensalidade do Associado

	declare @dia int  

	declare @dt_venc smallint  
	Declare @cd_empresa int  
	Declare @dt_vencimento datetime  
	Declare @mm_aaaa_1pagamento_empresa int  
	Declare @tp_empresa as int  
    Declare @equipe int 
    Declare @qt_incfatura int 
    
	Declare @qtde int  
	Declare @WL_DataAtual varchar(10)  

	--Select @WL_DataAtual = convert(varchar(10),getdate(),103)  
	
	if @wl_diaCorte = 0  
		set @dia = day(getdate())  
    else
		set @dia = @wl_diaCorte

	-- print @dia  
	 
    print 'Faturamento'

	DECLARE cursor_FechaFaturamentoEmpresa CURSOR FOR  
	select e.cd_empresa, e.dt_vencimento, e.mm_aaaa_1pagamento_empresa, e.tp_empresa, e.qt_incremento_mes_fatura
      from empresa as e, historico as h  , situacao_historico as s
     where e.cd_sequencial_historico = h.cd_sequencial and 
           h.cd_situacao = s.cd_situacao_historico and 
           s.fl_gera_cobranca = 1 and dt_corte >= @dia and
           dt_corte <= case when @dia>=28 and month(getdate())=2 then 30 else @dia end and 
           e.cd_tipo_pagamento = case when @cd_tipo_pagamento=0 then e.cd_tipo_pagamento else @cd_tipo_pagamento end and
           isnull(e.cd_funcionario,0) = case when @funcionarioResponsavel=0 then isnull(e.cd_funcionario,0) else @funcionarioResponsavel end and
           e.tp_empresa < 10 and -- Tipo de Empresa superior a 9 são convenios e particulares e nao são faturadas por essa rotina.
           e.CD_EMPRESA not in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise = 50) and -- Nao faturar automatico
           isnull(e.fechaFaturamentoAutomatico,1)=1
     order by tp_empresa , nm_fantasia

	OPEN cursor_FechaFaturamentoEmpresa  
	FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_empresa,@dt_venc,@mm_aaaa_1pagamento_empresa, @tp_empresa,@qt_incfatura

	WHILE (@@FETCH_STATUS <> -1)  
	begin  

		print 'Entrou Cursor'
        if @dt_venc > 29 -- Verificar o mes de fevereiro mudar p dia 28
        Begin
	 	 set @dt_venc = Case when @dia >= @dt_venc and month(dateadd(month,1,getdate()))= 2 then 28 
	 	                     when @dia < @dt_venc and month(getdate())= 2 then 28 
	 	                     else @dt_venc 
	 	                end 
        End    
        
		if @dia >= @dt_venc  
			set @dt_vencimento = convert(varchar(2),month(dateadd(month,1,getdate()))) + '/' + convert(varchar(2),@dt_venc) + '/' + convert(varchar(4),year(dateadd(month,1,getdate())))  
		Else  
			set @dt_vencimento = convert(varchar(2),month(getdate())) + '/' + convert(varchar(2),@dt_venc) + '/' + convert(varchar(4),year(getdate()))  
		 
		--set @dt_vencimento = dateadd(month,1,@dt_vencimento)
		
        Set @dt_vencimento = DATEADD(month,ISNULL(@qt_incfatura,0),@dt_vencimento) -- Realiza o incremento 

		-- Verificar se o mes e ano do 1 pagamento da empresa é maior do que o vencimento calculado  
		if convert(varchar(4),year(@dt_vencimento)) + right('00'+convert(varchar(2),month(@dt_vencimento)),2) >= @mm_aaaa_1pagamento_empresa  
		begin  
			print '--------'
		    print @dt_vencimento 
			print @cd_empresa  
			print '--------'
		    if @tp_empresa in (2,6,7,8)
				exec sp_gera_mensalidade @dt_vencimento, @cd_empresa, @tp_empresa,0
            else
				exec sp_gera_mensalidade_ass @dt_vencimento, @cd_empresa, @tp_empresa
		end  
 
		FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_empresa,@dt_venc,@mm_aaaa_1pagamento_empresa, @tp_empresa,@qt_incfatura
	end  
	DEALLOCATE cursor_FechaFaturamentoEmpresa  

    --Declare @cd_tipo_pagamento int 
    Declare @cd_tipo_servico_bancario int 

    --- Gerar Arquivos de Averbacao
    print 'Arquivos de Averbação'
	DECLARE cursor_FechaFaturamentoEmpresa CURSOR FOR  
	select cd_tipo_pagamento, cd_tipo_servico_bancario
	  from tipo_pagamento
	 where cd_tipo_servico_bancario is not null and 
	       fl_averbacao = 1 

	OPEN cursor_FechaFaturamentoEmpresa  
	FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_tipo_pagamento, @cd_tipo_servico_bancario

	WHILE (@@FETCH_STATUS <> -1)  
	begin  
        print '--------' + convert(varchar(10),@cd_tipo_pagamento)+ '---' + convert(varchar(10),@cd_tipo_servico_bancario)

	    exec sp_gera_averbacao @cd_tipo_pagamento, @cd_tipo_servico_bancario
 
		FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_tipo_pagamento, @cd_tipo_servico_bancario
	end  
    Close cursor_FechaFaturamentoEmpresa
	DEALLOCATE cursor_FechaFaturamentoEmpresa  

    --- Limpar Arquivos de Bancos 
    --update mensalidades 
    --   set cd_lote_processo_banco=null 
    -- where cd_lote_processo_banco in (select cd_sequencial from lote_processos_bancos where dt_finalizado is null)
    
    --delete lote_processos_bancos_mensalidades  
    -- where cd_sequencial_lote in (select cd_sequencial from lote_processos_bancos where dt_finalizado is null)
    
    --- Gerar Arquivos de Bancos
    print 'Arquivos de Bancos'
	DECLARE cursor_FechaFaturamentoEmpresa CURSOR FOR  
	select cd_tipo_pagamento, cd_tipo_servico_bancario
	  from tipo_pagamento
	 where cd_tipo_servico_bancario is not null and isnull(fl_envia_arquivo,0)>0

	OPEN cursor_FechaFaturamentoEmpresa  
	FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_tipo_pagamento, @cd_tipo_servico_bancario

	WHILE (@@FETCH_STATUS <> -1)  
	begin  
        print '--------' + convert(varchar(10),@cd_tipo_pagamento)+ '---' + convert(varchar(10),@cd_tipo_servico_bancario)
        if (select licencaS4E from configuracao) in ('HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020') and @cd_tipo_servico_bancario=1
        Begin
			DECLARE cursor_FechaFaturamentoEquipe CURSOR FOR  
			select cd_equipe from equipe_vendas
			OPEN cursor_FechaFaturamentoEquipe  
			FETCH NEXT FROM cursor_FechaFaturamentoEquipe INTO @equipe
			WHILE (@@FETCH_STATUS <> -1)  
			begin 
			  print @equipe
		      exec sp_gera_processos_bancos @cd_tipo_pagamento, @cd_tipo_servico_bancario , @equipe,1
			
			  FETCH NEXT FROM cursor_FechaFaturamentoEquipe INTO @equipe
			End 
			Close cursor_FechaFaturamentoEquipe
			Deallocate cursor_FechaFaturamentoEquipe			
             
        End
        else
	       exec sp_gera_processos_bancos @cd_tipo_pagamento, @cd_tipo_servico_bancario
 
		FETCH NEXT FROM cursor_FechaFaturamentoEmpresa INTO @cd_tipo_pagamento, @cd_tipo_servico_bancario
	end  
    Close cursor_FechaFaturamentoEmpresa
	DEALLOCATE cursor_FechaFaturamentoEmpresa  
 
End  
