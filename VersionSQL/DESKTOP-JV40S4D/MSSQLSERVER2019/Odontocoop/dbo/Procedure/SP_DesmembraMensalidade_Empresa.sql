/****** Object:  Procedure [dbo].[SP_DesmembraMensalidade_Empresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_DesmembraMensalidade_Empresa] (
	@Parcela int,       
	@Empresa int,       
	@GrupoFaturamento int,       
	@tipo_parcela int,       
	@tit_dep int,       
	@vl_parcela money,  
	@retorno varchar(1000)='' output)   
As
	Begin

	if (isnull(@GrupoFaturamento,0) =0 and isnull(@tipo_parcela,0) = 0 and isnull(@vl_parcela,0) = 0) or
		(isnull(@GrupoFaturamento,0) >0 and isnull(@tipo_parcela,0) > 0 and isnull(@vl_parcela,0) > 0)
	Begin
		Set @retorno = 'Selecione ou grupo de Faturamento ou Tipo de Parcela ou Valor para desmembrar '
		return    
	End   

	Declare @nova_parcela int 
	Declare @fl_possui_MP bit = 1 
	if isnull(@GrupoFaturamento,0)> 0 -- Verificar se o Grupo de Faturamento existe
	Begin 
		if (Select COUNT(0) 
		from mensalidades as m, Mensalidades_Planos as mp , DEPENDENTES as d , ASSOCIADOS as a
		where m.CD_PARCELA = @Parcela and 
			m.CD_ASSOCIADO_empresa = @Empresa and 
			m.CD_PARCELA = mp.cd_parcela_mensalidade and
			mp.cd_sequencial_dep = d.cd_sequencial and 
			d.CD_ASSOCIADO =  a.cd_associado and 
			m.TP_ASSOCIADO_EMPRESA > 1 and 
			m.CD_TIPO_RECEBIMENTO=0 and 
			mp.dt_exclusao is null and 
			a.depId = @GrupoFaturamento) = 0 
		Begin
			Set @retorno = 'Nenhum registro encontrado para desmembrar.'
			return   
		End        
	End 
	Else if isnull(@tipo_parcela,0)> 0
	Begin
		if (Select COUNT(0) 
		from mensalidades as m, Mensalidades_Planos as mp 
		where m.CD_PARCELA = @Parcela and 
		m.CD_ASSOCIADO_empresa = @Empresa and 
		m.CD_PARCELA = mp.cd_parcela_mensalidade and
		m.TP_ASSOCIADO_EMPRESA > 1 and 
		m.CD_TIPO_RECEBIMENTO=0 and 
		mp.dt_exclusao is null and 
		mp.cd_tipo_parcela = @tipo_parcela) = 0 
		Begin
			Set @retorno = 'Nenhum registro encontrado para desmembrar.'
			return   
		End  
	End
	else if @vl_parcela>0  
	begin  
		--if (select count(0)  
		--from mensalidades as m, Mensalidades_Planos as mp , DEPENDENTES as d       
		--where m.CD_PARCELA = @Parcela and       
		--m.CD_ASSOCIADO_empresa = @Empresa and       
		--m.CD_PARCELA = mp.cd_parcela_mensalidade and      
		--mp.cd_sequencial_dep = d.CD_SEQUENCIAL and       
		--m.TP_ASSOCIADO_EMPRESA > 1 and       
		--m.CD_TIPO_RECEBIMENTO=0 and       
		--mp.dt_exclusao is null) = 0  
		--Begin      
		  set @fl_possui_MP = 0 
		--  if (select count(0)  
		--		from mensalidades as m
		--		where m.CD_PARCELA = @Parcela and       
		--		m.CD_ASSOCIADO_empresa = @Empresa and       
		--		m.TP_ASSOCIADO_EMPRESA > 1 and       
		--		m.CD_TIPO_RECEBIMENTO=0 ) = 0
		--	begin 	
		--		Set @retorno = 'Nenhum registro encontrado para desmembrar.'      
		--		return         
		--	end 	
		--End           
	End      

    Declare @cd_tipo_parcela_new int = 14 -- Fatura Desmembrada
   
 	Begin Transaction

		insert mensalidades (CD_ASSOCIADO_empresa,TP_ASSOCIADO_EMPRESA,cd_tipo_parcela,
			CD_TIPO_PAGAMENTO,CD_TIPO_RECEBIMENTO,DT_VENCIMENTO,DT_GERADO, VL_PARCELA, VL_Acrescimo,VL_Desconto)
		select cd_Associado_empresa, TP_ASSOCIADO_EMPRESA,@cd_tipo_parcela_new,
			CD_TIPO_PAGAMENTO,0,DT_VENCIMENTO,GETDATE(), 0, 0,0
		from mensalidades  
		where CD_PARCELA = @Parcela 

		Set @nova_parcela = @@IDENTITY
		if @nova_parcela is null 
		Begin
			ROLLBACK
			Set @retorno = 'Erro na criação da nova mensalidade.'
			return       
		End 

		print 'Nova Parcela:' + convert(varchar(10),@nova_parcela)

		print  'mensalidades_planos'


		declare @mpValor  money=0.0
		declare @sumValor  money=0.0
		declare @cd_sequencial_dep int
		declare @cd_plano int 
		declare @cd_empresa_filha int
		declare @cd_tipo_parcela int
		declare @dt_exclusao int
		declare @cd_funcionario_exclusao int
		declare @cd_sequencial int

		if LEN(@vl_parcela)>0 and @fl_possui_MP=0 
		begin 
		
		   update mensalidades set vl_parcela = @vl_parcela where cd_parcela = @nova_parcela
		   update mensalidades set vl_parcela = vl_parcela - @vl_parcela where cd_parcela = @Parcela
		
		End 
		
		if LEN(@vl_parcela)>0 and @fl_possui_MP=1 
		begin 
			DECLARE c_pp CURSOR FOR  
				select p.cd_sequencial_dep, p.cd_plano , p.valor, p.cd_empresa_filha , p.cd_tipo_parcela,p.dt_exclusao,p.cd_funcionario_exclusao, p.cd_sequencial      
				from mensalidades_planos as p , mensalidades as m, DEPENDENTES as d, ASSOCIADOS as a      
				where p.cd_parcela_mensalidade = m.cd_parcela and       
				m.CD_PARCELA = @Parcela and       
				p.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL and       
				d.CD_ASSOCIADO = a.cd_associado and       
				p.dt_exclusao is null           
			OPEN c_pp
			FETCH NEXT FROM c_pp INTO @cd_sequencial_dep, @cd_plano, @mpValor, @cd_empresa_filha, @cd_tipo_parcela, @dt_exclusao, @cd_funcionario_exclusao, @cd_sequencial
			WHILE (@@FETCH_STATUS <> -1)  
			BEGIN  
				set @sumValor = @sumValor + @mpValor
				if @vl_parcela > @sumValor
				begin
					insert mensalidades_planos	(cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,dt_exclusao,cd_funcionario_exclusao )
								values (@nova_parcela, @cd_sequencial_dep, @cd_plano, @mpValor, @cd_empresa_filha, @cd_tipo_parcela, @dt_exclusao, @cd_funcionario_exclusao  )             
					update Mensalidades_Planos 
					set dt_exclusao=GETDATE(), cd_funcionario_exclusao=(select cd_funcionario from Processos where cd_processo=1)
					from mensalidades_planos as p 
					where p.cd_sequencial = @cd_sequencial
					
					if @@Rowcount =  0 
					begin -- 3.1.2.1
						ROLLBACK
						Set @retorno = 'Erro na criação da nova mensalidade plano.'		
						RETURN
					end -- 3.1.2.1
				end
				else
				begin
					insert mensalidades_planos	(cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,dt_exclusao,cd_funcionario_exclusao )
								values (@parcela, @cd_sequencial_dep, @cd_plano, abs(@sumValor-@vl_parcela), @cd_empresa_filha, @cd_tipo_parcela, @dt_exclusao, @cd_funcionario_exclusao  )             

					insert mensalidades_planos	(cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,dt_exclusao,cd_funcionario_exclusao )
								values (@nova_parcela, @cd_sequencial_dep, @cd_plano, @mpValor-abs(@sumValor-@vl_parcela), @cd_empresa_filha, @cd_tipo_parcela, @dt_exclusao, @cd_funcionario_exclusao  )      
								
					update Mensalidades_Planos 
					set dt_exclusao=GETDATE(), cd_funcionario_exclusao=(select cd_funcionario from Processos where cd_processo=1)
					from mensalidades_planos as p 
					where p.cd_sequencial = @cd_sequencial
					
					if @@Rowcount =  0 
					begin -- 3.1.2.1
						ROLLBACK
						Set @retorno = 'Erro na criação da nova mensalidade plano.'		
						RETURN
					end -- 3.1.2.1
					break			
				end
			FETCH NEXT FROM c_pp INTO @cd_sequencial_dep, @cd_plano, @mpValor, @cd_empresa_filha, @cd_tipo_parcela, @dt_exclusao, @cd_funcionario_exclusao, @cd_sequencial  
			END  
		Close c_pp
		Deallocate c_pp
		end
	
		if isnull(@GrupoFaturamento,0)> 0 -- Verificar se o Grupo de Faturamento existe
		Begin      
			insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,dt_exclusao,cd_funcionario_exclusao )
			select @nova_parcela, p.cd_sequencial_dep, p.cd_plano , p.valor, p.cd_empresa_filha , p.cd_tipo_parcela,p.dt_exclusao,p.cd_funcionario_exclusao 
			from mensalidades_planos as p , mensalidades as m, DEPENDENTES as d, ASSOCIADOS as a
			where p.cd_parcela_mensalidade = m.cd_parcela and 
			m.CD_PARCELA = @Parcela and 
			p.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL and 
			d.CD_ASSOCIADO = a.cd_associado and 
			a.depId = @GrupoFaturamento and 
			p.dt_exclusao is null 
			
			if @@Rowcount =  0 
			begin -- 3.1.2.1
				ROLLBACK
				Set @retorno = 'Erro na criação da nova mensalidade plano.'		
				RETURN
			end -- 3.1.2.1	
		End
		if isnull(@tipo_parcela,0)> 0
		Begin
			insert mensalidades_planos (cd_parcela_mensalidade, cd_sequencial_dep , cd_plano, valor, cd_empresa_filha,cd_tipo_parcela,dt_exclusao,cd_funcionario_exclusao )
			select @nova_parcela, p.cd_sequencial_dep, p.cd_plano , p.valor, p.cd_empresa_filha , p.cd_tipo_parcela,p.dt_exclusao,p.cd_funcionario_exclusao 
			from mensalidades_planos as p , mensalidades as m, DEPENDENTES as d, ASSOCIADOS as a
			where p.cd_parcela_mensalidade = m.cd_parcela and 
			m.CD_PARCELA = @Parcela and 
			p.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL and 
			d.CD_ASSOCIADO = a.cd_associado and 
			p.cd_tipo_parcela = @tipo_parcela and 
			p.dt_exclusao is null     
			
			if @@Rowcount =  0 
			begin -- 3.1.2.1
				ROLLBACK
				Set @retorno = 'Erro na criação da nova mensalidade plano.'		
				RETURN
			end -- 3.1.2.1	
		End 

        if @fl_possui_MP=1 
        begin 
			update mensalidades
			set VL_PARCELA =  (select SUM(valor) from Mensalidades_Planos where cd_parcela_mensalidade = @nova_parcela and dt_exclusao is null), 
			DT_ALTERACAO = GETDATE(), 
			CD_USUARIO_ALTERACAO = (select cd_funcionario from Processos where cd_processo=1)
			where CD_PARCELA = @nova_parcela
        End 
        
		print  'mensalidades_planos cancelada'

		if isnull(@GrupoFaturamento,0)> 0 -- Verificar se o Grupo de Faturamento existe
		Begin             
			update Mensalidades_Planos 
			set dt_exclusao=GETDATE(), cd_funcionario_exclusao=(select cd_funcionario from Processos where cd_processo=1)
			from mensalidades_planos as p , mensalidades as m, DEPENDENTES as d, ASSOCIADOS as a
			where p.cd_parcela_mensalidade = m.cd_parcela and 
			m.CD_PARCELA = @Parcela and 
			p.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL and 
			d.CD_ASSOCIADO = a.cd_associado and 
			a.depId = @GrupoFaturamento and 
			p.dt_exclusao is null 	
			
			if @@Rowcount =  0 
			begin -- 3.1.2.1
				ROLLBACK
				Set @retorno = 'Erro na exclusão da mensalidade plano.'		
				RETURN
			end -- 3.1.2.1		  
		End 
		if isnull(@tipo_parcela,0)> 0
		Begin
			update Mensalidades_Planos 
			set dt_exclusao=GETDATE(), cd_funcionario_exclusao=(select cd_funcionario from Processos where cd_processo=1)
			from mensalidades_planos as p , mensalidades as m, DEPENDENTES as d, ASSOCIADOS as a
			where p.cd_parcela_mensalidade = m.cd_parcela and 
			m.CD_PARCELA = @Parcela and 
			p.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL and 
			d.CD_ASSOCIADO = a.cd_associado and 
			p.cd_tipo_parcela = @tipo_parcela and 
			p.dt_exclusao is null 	
			
			if @@Rowcount =  0 
			begin -- 3.1.2.1
				ROLLBACK
				Set @retorno = 'Erro na exclusão da mensalidade plano.'		
				RETURN
			end -- 3.1.2.1
		End 

		--print 'Imposto'
		--exec SP_Gerar_Imposto @nova_parcela
		--print 'Imposto2'
		--exec SP_Gerar_Imposto @Parcela
		--print 'Fim'
		
	commit                            
	return  
End
