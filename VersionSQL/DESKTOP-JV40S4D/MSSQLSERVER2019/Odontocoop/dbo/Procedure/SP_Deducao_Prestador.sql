/****** Object:  Procedure [dbo].[SP_Deducao_Prestador]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Deducao_Prestador] @lote int
as 
Begin


  --- Verificar se ja tinha sido gerado o imposto 
  declare @vl_desconto money 
  declare @vl_ref money 
  declare @vl_ref_IR money 
  Declare @cd_ass_emp int 
  Declare @tp_ass int 
  declare @cd_tipo_recebimento int 
  
  -- Cancelar as aliquota para gerar novamente
  update Pagamento_Dentista_Aliquotas set dt_exclusao = getdate() 
   where cd_pgto_dentista_lanc = @lote and dt_exclusao is null
  if @@ERROR <> 0 
  begin
     RAISERROR ('Lote no financeiro não pode ser recalculado.', 16, 1)
	 Return  
  End
  
  Declare @qt_dependentes as int 
  if (select COUNT(0) from Pagamento_Dentista_Lancamento as p where p.cd_pgto_dentista_lanc = @lote and cd_filial is null)>0
  begin 
  print 1
	  Select @qt_dependentes = qt_dependentes
		from Funcionario_modelo_pagamento as f, Pagamento_Dentista_Lancamento as p 
	   where f.cd_funcionario = p.cd_funcionario
		 and p.cd_pgto_dentista_lanc = @lote
  end 
  else 
  begin
  print 2 
	  Select @qt_dependentes = qt_dependentes
		from Filial_modelo_pagamento as f, Pagamento_Dentista_Lancamento as p 
	   where f.cd_filial = p.cd_filial
		 and p.cd_pgto_dentista_lanc = @lote  
  end 
  print 'Dep'
  print @qt_dependentes
  print '-----'
  
  Declare @acertoPrestadorBruto bit
  --Verificar se o acerto/estorno é realizado antes ou após a geração das alíquotas
  select @acertoPrestadorBruto = isnull(acertoPrestadorBruto,1)
  from configuracao
  
  select @vl_ref = case when @acertoPrestadorBruto = 0 then ISNULL(vl_lote,0) else ISNULL(vl_bruto,0) end
    from Pagamento_Dentista_Lancamento 
   where cd_pgto_dentista_lanc = @lote 
   
   print 'ref'
   print @vl_ref
   print '---'
   
  select @vl_ref_ir = @vl_ref - 
         isnull(sum(case when isnull(a.vl_maximo_deducao,0)=0 or convert(float,convert(float,ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota,0))/10000) <= isnull(a.vl_maximo_deducao,0) then --- Se a aliquota tiver limite maximo de deducao 
		     convert(float,convert(float,ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota,0))/10000)
		 else
		     a.vl_maximo_deducao
		 end),0) - 
		isnull((select ISNULL(MAX(vl_deducao_dependente),0) * ISNULL(@qt_dependentes,0) from Aliquota_IR ),0)
   from Pagamento_Dentista_Lancamento as p, Modelo_PgtoPrestador_Aliquota as ea ,  retencao_aliquota ra, Aliquota as a, referencia_aliquota as r 
  where ea.cd_modelo_pgto_prestador  = p.cd_modelo_pgto_prestador  and 
		ea.id_retencao_aliquota = ra.id_retencao_aliquota   and 
		ea.cd_aliquota = a.cd_aliquota and 
		a.id_referencia = r.id_referencia and 
		p.cd_pgto_dentista_lanc = @lote and 
		a.cd_grupo_aliquota = 3

     if @vl_ref_ir <0 
        Set @vl_ref_ir = 0 
        
     print 'ref ir'
     print @vl_ref_ir
     print '---'
  

        
  -- referencia_aliquota liga na aliquota
  --1	Titulo superior a
  --2	Tabela do IR Pessoa Fisica
  
  -- Retencao_Aliquota
  -- 0	Não
  -- 1	Sim
  -- 2	Conforme Legislação (Valor referencia)
  
  
  -- Gerar as aliquotas
     insert Pagamento_Dentista_Aliquotas(cd_pgto_dentista_lanc, cd_aliquota, vl_referencia, perc_aliquota,valor_aliquota,dt_gerado,id_retido)
     select @lote , ea.cd_aliquota ,convert(float,convert(float,round(@vl_ref * ea.perc_incidencia,0))/100) , 
            case when r.id_referencia = 2 then -- Tabela do IR
                   (select top 1 ir.perc_aliquota from Aliquota_IR as ir where vl_maximo >=  convert(float,convert(float,ROUND(@vl_ref * ea.perc_incidencia,0))/100) and vl_minimo <= convert(float,convert(float,round(@vl_ref * ea.perc_incidencia,0))/100))
                 else 
                   a.perc_aliquota 
                 end, -- 1parte ( Aliquota IR )
			round(case when r.id_referencia = 2 then 
                  (select top 1 round(convert(float,convert(float,round(@vl_ref_ir * ea.perc_incidencia * ir.perc_aliquota,0))/10000)-ir.vl_deduzir,2)  from Aliquota_IR as ir where vl_maximo >=  convert(float,convert(float,convert(int, @vl_ref_ir * ea.perc_incidencia))/100) and vl_minimo <= convert(float,convert(float,convert(int, @vl_ref_ir * ea.perc_incidencia))/100)) 			       
			     else 
			       case when isnull(a.vl_maximo_deducao,0)=0 or convert(float,convert(float,ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota,0))/10000) <= isnull(a.vl_maximo_deducao,0) then --- Se a aliquota tiver limite maximo de deducao 
			               convert(float,convert(float,ROUND(@vl_ref * ea.perc_incidencia * a.perc_aliquota,0))/10000)
			            else
			               a.vl_maximo_deducao
			            end  -- Caso a aliquota tenha valor maximo  
			     end,2)   , 
			GETDATE(),     
            case when ra.id_retencao_aliquota = 1 or (ra.id_retencao_aliquota = 2 and r.id_referencia =1 and @vl_ref >= a.vl_referencia) or (ra.id_retencao_aliquota = 2 and r.id_referencia =2) then 1 else 0 end -- 1 - Retem or (2 Conforme Legislação (Valor referencia) e 1 Titulo superior a) or (2 Conforme Legislação (Valor referencia) e 2 Tabela IR)
	   from Pagamento_Dentista_Lancamento as p, Modelo_PgtoPrestador_Aliquota as ea ,  retencao_aliquota ra, Aliquota as a, referencia_aliquota as r 
	  where ea.cd_modelo_pgto_prestador  = p.cd_modelo_pgto_prestador  and 
			ea.id_retencao_aliquota = ra.id_retencao_aliquota   and 
			ea.cd_aliquota = a.cd_aliquota and 
			a.id_referencia = r.id_referencia and 
			p.cd_pgto_dentista_lanc = @lote 
			
	  if @@ERROR <> 0 
	  begin
		 RAISERROR ('Erro no calculo dos encargos.', 16, 1)
		 Return  
	  End
        
End 
