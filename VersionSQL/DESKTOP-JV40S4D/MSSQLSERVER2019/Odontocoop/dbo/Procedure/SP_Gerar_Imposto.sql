/****** Object:  Procedure [dbo].[SP_Gerar_Imposto]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Gerar_Imposto] @parc int
as 
Begin

  --- Verificar se ja tinha sido gerado o imposto 
  declare @vl_desconto money = 0 -- = (select SUM(valor_aliquota) from parcela_aliquota where cd_parcela = @parc and dt_exclusao is null and id_retido=1)
  declare @vl_acrescimo money = 0 
  declare @perc_retencao money = 0 
  declare @vl_taxa money = 0
  
  declare @vl_desconto_new money 
  declare @vl_ref money 
  Declare @cd_ass_emp int 
  Declare @tp_ass int 
  declare @cd_tipo_recebimento int 
  Declare @wl_venc date 
  
  --********************************
  Declare @roundHalfDown money 
  Declare @cd_centrocusto int 
  Declare @LicensaS4E Varchar(50)	
  SELECT top 1 @LicensaS4E = LicencaS4E FROM Configuracao
  
   --********************************


  select @vl_ref=ISNULL(m.vl_parcela,0), -- +ISNULL(vl_acrescimo,0)-ISNULL(vl_desconto,0)+ISNULL(@vl_desconto,0) ,
         @cd_ass_emp = m.CD_ASSOCIADO_empresa ,
         @tp_ass = m.TP_ASSOCIADO_EMPRESA ,
         @cd_tipo_recebimento = m.CD_TIPO_RECEBIMENTO ,
         @vl_taxa = case when m.cd_tipo_parcela>1 then 0 else isnull(sb.vl_taxa,0) end ,
         @wl_venc = m.dt_vencimento
    from MENSALIDADES as m inner join tipo_pagamento as t on m.cd_tipo_pagamento = t.cd_tipo_pagamento 
                 left join tipo_servico_bancario as sb on t.cd_tipo_servico_bancario = sb.cd_tipo_servico_bancario
   where CD_PARCELA = @parc
  
  --if @cd_tipo_recebimento>0 
  --   return
  
  if @tp_ass > 1 -- pessoa juridica
  begin 
      
      Select @vl_acrescimo = case when fl_acrescimo is null then 0 when fl_acrescimo = 1 then vl_ajuste else 0 end +
						    ISNULL((select sum(t1.valor)  
									  from Mensalidades_avulsas t1 , Tipo_parcela t4 
									 where t1.cd_empresa = case when @tp_ass=1 then 0 else @cd_ass_emp end and 
										   t1.dt_exclusao is null and 
										   t1.cd_tipo_parcela = t4.cd_tipo_parcela and 
										   t4.fl_positivo = 1 and 
										   t1.dt_vencimento <= @wl_venc and 
										   t1.dt_vencimento_final >= @wl_venc
													 ),0),
             @vl_desconto = case when fl_acrescimo is null then 0 when fl_acrescimo = 0 then vl_ajuste else 0 end +
							ISNULL((select sum(t1.valor)  
									  from Mensalidades_avulsas t1 , Tipo_parcela t4 
									 where t1.cd_empresa = case when @tp_ass=1 then 0 else @cd_ass_emp end and 
										   t1.dt_exclusao is null and 
										   t1.cd_tipo_parcela = t4.cd_tipo_parcela and 
										   t4.fl_positivo = 0 and 
										   t1.dt_vencimento <= @wl_venc and 
										   t1.dt_vencimento_final >= @wl_venc
													 ),0),
             @perc_retencao = isnull(percentual_retencao,0),
             @vl_taxa = 0, -- Zerar taxa. So cobrar de PF 
             @cd_centrocusto = e.cd_centro_custo
        from mensalidades as m , empresa as e
       where m.cd_Associado_empresa = e.cd_empresa and cd_parcela = @parc 
       
       if @perc_retencao>0
          Set @vl_desconto = (@vl_ref-isnull(@vl_desconto,0))*(@perc_retencao/100)
          
       Set @vl_ref = @vl_ref + isnull(@vl_acrescimo,0) - isnull(@vl_desconto,0)
             
  End 
  
  if @tp_ass = 1 -- pessoa Fisica
  begin 
	Select @cd_centrocusto = e.cd_centro_custo
        from mensalidades as m , associados a, empresa as e
       where m.cd_Associado_empresa = a.cd_associado 
			 and a.cd_empresa  = e.cd_empresa 
			 and cd_parcela = @parc 
       
  end
  
  if @cd_centrocusto= 1 and (@LicensaS4E = 'U87DJHJ767DFJJHJDFD8676FDJHJSSAQEHBV86265698JJ005' or @LicensaS4E = 'HGDTRAKASKJSAI78734863210190298883487ASAJHJHAJ003')
	  Begin
		set @roundHalfDown = 0.4
	  end
  
  else
	  Begin
		set @roundHalfDown = 0.5
	  end
  
  print '@roundHalfDown'
  print  @roundHalfDown
      select @vl_acrescimo = round(@vl_acrescimo,2), @vl_desconto= round(@vl_desconto,2)

  if @vl_taxa > 0 
  Begin 
     select @vl_taxa = case when isnull(a.taxa_cobranca,1) = 1 then @vl_taxa else 0 end 
       from mensalidades as m , ASSOCIADOS as a
      where m.cd_Associado_empresa = a.cd_associado and cd_parcela = @parc 
  End 
  
  -- Cancelar as aliquota para gerar novamente
  update parcela_aliquota set dt_exclusao = getdate() where cd_parcela = @parc and dt_exclusao is null
  
  -- referencia_aliquota liga na aliquota
  --1	Titulo superior a
  --2	Tabela do IR Pessoa Fisica
  
  -- Retencao_Aliquota
  -- 0	Não
  -- 1	Sim 
  -- 2	Conforme Legislação (Valor referencia)
  
  -- Informar na tabela de mensalidades o valor referência
    -- update mensalidades set vl_referenciaNF = @vl_ref where cd_parcela = @parc
  declare @prt varchar(max)
  set @prt = 'select ' + convert(varchar(10),@parc) + ' , ea.cd_aliquota , ' +  convert(varchar(10), @vl_ref) +' , perc_aliquota, 
			round((' +  convert(varchar(10), @vl_ref) +' * convert(int,perc_aliquota)/100)-0.001,2),
			GETDATE(),
			case when ra.id_retencao_aliquota = 1 or (ra.id_retencao_aliquota = 2 and r.id_referencia =1 and ' +  convert(varchar(10), @vl_ref) +' >= a.vl_referencia) then 1 else 0 end -- 1 - Retem or (2 Conforme Legislação (Valor referencia) e 1 Titulo superior a)
	   from empresa_aliquota as ea, retencao_aliquota ra, Aliquota as a, referencia_aliquota as r 
	  where ea.cd_empresa = case when ' + convert(varchar(10),@tp_ass) +' = 1 then (select cd_empresa from associados where cd_associado = '+convert(varchar(10),@cd_ass_emp) +') else '+convert(varchar(10),@cd_ass_emp) +' end and 
			ea.id_retencao_aliquota = ra.id_retencao_aliquota   and 
			ea.cd_aliquota = a.cd_aliquota and 
			a.id_referencia = r.id_referencia '
  print @prt
  -- Gerar as aliqoutas
     insert parcela_aliquota (cd_parcela, cd_aliquota, vl_referencia, perc_aliquota,valor_aliquota,dt_gerado,id_retido)
     select @parc , ea.cd_aliquota , @vl_ref , perc_aliquota, 
			--convert(float,convert(int,convert(float,@vl_ref * perc_aliquota) + 0.5))/100 , 
			--convert(float,convert(int,convert(float,@vl_ref * perc_aliquota) + @roundHalfDown))/100 ,
			--round((@vl_ref * convert(int,perc_aliquota)/100)-0.001,2), 
			round(round(@vl_ref * convert(float,perc_aliquota*100)/100/100,3)-0.001,2),
			GETDATE(),
			case when ra.id_retencao_aliquota = 1 or (ra.id_retencao_aliquota = 2 and r.id_referencia =1 and @vl_ref >= a.vl_referencia) then 1 else 0 end -- 1 - Retem or (2 Conforme Legislação (Valor referencia) e 1 Titulo superior a)
	   from empresa_aliquota as ea, retencao_aliquota ra, Aliquota as a, referencia_aliquota as r 
	  where ea.cd_empresa = case when @tp_ass = 1 then (select cd_empresa from associados where cd_associado = @cd_ass_emp) else @cd_ass_emp end and 
			ea.id_retencao_aliquota = ra.id_retencao_aliquota   and 
			ea.cd_aliquota = a.cd_aliquota and 
			a.id_referencia = r.id_referencia 
        
   -- Se plano continuidade nao retem nada 
   update p
      set id_retido=0
     from parcela_aliquota as p inner join MENSALIDADES as m on p.cd_parcela = m.CD_PARCELA and m.TP_ASSOCIADO_EMPRESA=1
            inner join DEPENDENTES as d on m.cd_associado_empresa = d.cd_Associado and d.CD_GRAU_PARENTESCO=1
            inner join HISTORICO as h on d.CD_Sequencial_historico=h.cd_sequencial 
    where m.CD_PARCELA= @parc 
      and p.id_retido=1 
      and h.CD_SITUACAO in (select ds_procedure from Processos where cd_processo=20)
      and p.dt_exclusao is null      
         
  Select @vl_desconto_new = SUM(valor_aliquota) from parcela_aliquota where cd_parcela = @parc and dt_exclusao is null and id_retido = 1 
  
   -- if isnull(@vl_desconto,0) > 0 or ISNULL(@vl_desconto_new,0)>0 or isnull(@vl_acrescimo,0)>0 
      update MENSALIDADES 
         set vl_acrescimo = isnull(@vl_acrescimo,0),
             VL_Desconto = isnull(@vl_desconto,0),
             --VL_Desconto = isnull(@vl_desconto,0)+ISNULL(@vl_desconto_new,0), 
             vl_taxa = @vl_taxa  ,
             vl_referenciaNF = @vl_ref, 
             vl_imposto=ISNULL(@vl_desconto_new,0),
             vl_titulo = @vl_ref-ISNULL(@vl_desconto_new,0)
       where cd_parcela = @parc 
  
End
