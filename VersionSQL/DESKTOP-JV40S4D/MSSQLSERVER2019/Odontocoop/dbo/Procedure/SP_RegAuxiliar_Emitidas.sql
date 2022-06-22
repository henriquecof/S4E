/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Emitidas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Emitidas] (@mes varchar(2), @ano varchar(4), @tp_associado smallint = 0,@centro_custo int = 0, @grupo int = 0 , @dt_inicial date = null, @dt_final date = null )
as 
Begin 

Declare @SQL varchar(max)    
Set @SQL = @ano  + right('00'+@mes,2)    
exec SP_RegAuxiliar_CancelaContabil @SQL  

-- REGISTRO DE CONTRATOS E CONTRAPRESTAÇÕES EMITIDOS – I

if LEN(@mes)=1 
   Set @mes='0'+@mes
   
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Mensalidade_emitidas]') AND type in (N'U'))
    drop table Mensalidade_emitidas

Create Table Mensalidade_emitidas 
 (cd_parcela int , 
  DT_VENCIMENTO date not null,
  mes smallint not null,-- 1 laco 
  inicio_cobertura smallint not null, -- 1 laco 
  qt_diasmes smallint not null, -- 1 laco
  qt_diasmescorrente smallint null, 
  vl_debito money not null, -- 1 laco
  vl_dia money , 
  Janeiro money null,
  Fevereiro money null,
  Marco money null,
  Abril money null,
  Maio money null,
  Junho money null,
  Julho money null,
  Agosto money null,
  Setembro money null,
  Outubro money null,
  Novembro money null,
  Dezembro money null,
  Janeiro_1 money null,
  CONSTRAINT [PK_Mensalidade_emitidas_1] PRIMARY KEY NONCLUSTERED (cd_parcela ASC)
 )

Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 

Set @dt_i = convert(date,@mes + '/01/' + @ano )
Set @dt_f = DATEADD(month,1,@dt_i)

-- Inicio da Cobertura
Declare @tipo_imp_regaux_emi_pf smallint -- 1-Inicio Cobertura, 2-Vencimento e 3-Dia fixo 1 , 4-Dia do Venc + Mes e Ano do Pagamento (So pode com o outro 3), 5 - data de assinatura contrato
-- Emissao 
Declare @tipo_DtEmissao_RegAux_Emi_pf smallint -- 1-Emissao,2-Vencimento,3-Pagamento

Declare @tipo_imp_regaux_emi_pj smallint -- 1-Inicio Cobertura, 2-Vencimento e 3-Dia fixo 1 , 4-Dia do Venc + Mes e Ano do Pagamento
Declare @tipo_DtEmissao_RegAux_Emi_pj smallint -- 1-Emissao,2-Vencimento,3-Pagamento

Select @tipo_imp_regaux_emi_pf       = isnull(tipo_imp_regaux_emipf,1),  -- dt_inicio_cobertura
       @tipo_DtEmissao_RegAux_Emi_pf = ISNULL(tipo_DtEmissao_RegAux_Emipf,1) , -- dt_emissao 
       @tipo_imp_regaux_emi_pj       = isnull(tipo_imp_regaux_emipj,1),
       @tipo_DtEmissao_RegAux_Emi_pj = ISNULL(tipo_DtEmissao_RegAux_Emipj,1) 
  from configuracao 

-- ******************************************************************************************************************

--Disable trigger TR_mensalidades_Upd on mensalidades
--Disable trigger TR_mensalidades_IU on mensalidades

if @tipo_imp_regaux_emi_pf = 4 
Begin
	update mensalidades 
	   set dt_inicio_cobertura = convert(varchar(2),month(isnull(dt_credito,dt_pagamento)))+'/'+
	                             convert(varchar(2),case when month(isnull(dt_credito,dt_pagamento))=2 and DAY(dt_vencimento)>28 then 28 when DAY(dt_vencimento)>30 then 30 else DAY(dt_vencimento) end) +
	                             '/'+convert(varchar(4),YEAR(isnull(dt_credito,dt_pagamento))),
	       executartrigger=0                             
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 1 and 
	       CD_TIPO_RECEBIMENTO>2 and 
	       DT_PAGAMENTO is not null
End

if @tipo_imp_regaux_emi_pf in (1,5) 
Begin
	update m  
	   set dt_inicio_cobertura = convert(varchar(2),month(m.dt_vencimento))+'/'+
	                             convert(varchar(2),case when month(m.dt_vencimento)=2 and case when  @tipo_imp_regaux_emi_pf in (1) then e.dia_inicio_cobertura else convert(int,day(a.dt_assinatura_contrato)) end =30 then 28 else case when  @tipo_imp_regaux_emi_pf in (1) then e.dia_inicio_cobertura else case when day(a.dt_assinatura_contrato)>30 then 30 else day(a.dt_assinatura_contrato) end end end) +
	                             '/'+convert(varchar(4),YEAR(m.dt_vencimento)),
	       executartrigger=0   
	  from mensalidades as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa=a.cd_associado 
	        inner join empresa as e on a.cd_empresa=e.CD_EMPRESA 
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 1 
End

if @tipo_imp_regaux_emi_pf in (2,3) 
Begin
	update mensalidades 
	   set dt_inicio_cobertura = convert(varchar(2),month(dt_vencimento))+'/'+
	                             convert(varchar(2),case when @tipo_imp_regaux_emi_pf in (3) then 1 else Day(dt_vencimento) end) +
	                             '/'+convert(varchar(4),YEAR(dt_vencimento)),
	       executartrigger=0                             
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 1 
End

if @tipo_imp_regaux_emi_pj = 4 
Begin
	update mensalidades 
	   set dt_inicio_cobertura = convert(varchar(2),month(isnull(dt_credito,dt_pagamento)))+'/'+
	                             convert(varchar(2),case when month(isnull(dt_credito,dt_pagamento))=2 and DAY(dt_vencimento)>28 then 28 when DAY(dt_vencimento)>30 then 30 else DAY(dt_vencimento) end) +
	                             '/'+convert(varchar(4),YEAR(isnull(dt_credito,dt_pagamento))),
	       executartrigger=0                             
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 2 and
	       CD_TIPO_RECEBIMENTO>2 and DT_PAGAMENTO is not null
End

if @tipo_imp_regaux_emi_pj in (1) 
Begin
	update m  
	   set dt_inicio_cobertura = convert(varchar(2),month(m.dt_vencimento))+'/'+
	                             convert(varchar(2),case when month(m.dt_vencimento)=2 and e.dia_inicio_cobertura=30 then 28 else e.dia_inicio_cobertura end) +
	                             '/'+convert(varchar(4),YEAR(m.dt_vencimento)),
	       executartrigger=0   
	  from mensalidades as m inner join empresa as e on m.CD_ASSOCIADO_empresa=e.CD_EMPRESA                    
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 2 
End

if @tipo_imp_regaux_emi_pj in (2,3) 
Begin
	update mensalidades 
	   set dt_inicio_cobertura = convert(varchar(2),month(dt_vencimento))+'/'+
	                             convert(varchar(2),case when @tipo_imp_regaux_emi_pj in (3) then 1 else Day(dt_vencimento) end) +
	                             '/'+convert(varchar(4),YEAR(dt_vencimento)),
	       executartrigger=0                             
	 where dt_inicio_cobertura is null and 
	       tp_Associado_empresa = 2 
End


-- ******************************************************************************************************************
-- Emissao sendo a data do pagamento 
if @tipo_DtEmissao_RegAux_Emi_pf = 3 
Begin
	update mensalidades 
	   set dt_emissao = isnull(dt_credito,dt_pagamento),
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 1 and 
	       CD_TIPO_RECEBIMENTO>2 and 
	       DT_PAGAMENTO is not null and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual
End

-- Emissao sendo a data gerado ou vencimento   
if @tipo_DtEmissao_RegAux_Emi_pf in (1,2)
Begin
    -- Quando a parcela esta paga 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 1 and 
	       CD_TIPO_RECEBIMENTO > 2 and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual

    -- Quando a parcela esta Aberta 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 1 and 
	       CD_TIPO_RECEBIMENTO = 0 and
	       case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end < convert(varchar(10),@dt_f,101) and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual
	       
 --   -- Quando a parcela estiver em acordo 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 1 and 
	       CD_TIPO_RECEBIMENTO = 2 and 
	       dt_baixa >= convert(varchar(10),@dt_f,101) and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual

End 

-- Emissao sendo a data do pagamento 
if @tipo_DtEmissao_RegAux_Emi_pj = 3 
Begin
	update mensalidades 
	   set dt_emissao = isnull(dt_credito,dt_pagamento),
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 2 and 
	       CD_TIPO_RECEBIMENTO>2 and 
	       DT_PAGAMENTO is not null and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual
End

-- Emissao sendo a data gerado ou vencimento   
if @tipo_DtEmissao_RegAux_Emi_pj in (1,2)
Begin 
    -- Quando a parcela esta paga 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pj=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 2 and 
	       CD_TIPO_RECEBIMENTO > 2 and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual

    -- Quando a parcela esta aberta 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pj=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 2 and 
	       CD_TIPO_RECEBIMENTO = 0 and
	       case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end < convert(varchar(10),@dt_f,101) and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual
	       
 --   -- Quando a parcela estiver em acordo 
	update mensalidades 
	   set dt_emissao = case when @tipo_DtEmissao_RegAux_Emi_pf=2 then dt_vencimento else dt_gerado end ,
	       executartrigger=0                             
	 where dt_emissao is null and 
	       tp_Associado_empresa = 2 and 
	       CD_TIPO_RECEBIMENTO = 2 and 
	       dt_baixa >= convert(varchar(10),@dt_f,101) and
	       cd_tipo_parcela < 100 -- Nao entrar a virtual
	 
End

-- ******************************************************************************************************************

--Enable trigger TR_mensalidades_Upd on mensalidades
--Enable trigger TR_mensalidades_IU on mensalidades


-- @tipo_imp_regaux_emi_pf = PF 
-- 3 = (select LicencaS4E from Configuracao) In (''THGF6453JD81HDHCBVJG856SHFG57656JHDFDSDFGTHJJJ015'')
-- 2 = (select LicencaS4E from Configuracao) In (''UHD68FDSSHDS87622ASBVQ71619A87287776SDS0KJUY66001'',''HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020'')

-- @tipo_DtEmissao_RegAux_Emi_pf = PF 
-- 2 = (select LicencaS4E from Configuracao) In (''THGF6453JD81HDHCBVJG856SHFG57656JHDFDSDFGTHJJJ015'',''HYYT76658HFKJNXBEY46WUYU1276745JHFJDHJDFDVCGFD020'')

-- @tipo_imp_regaux_emi_pJ = PJ 
-- 3 = (select LicencaS4E from Configuracao) In (''THGF6453JD81HDHCBVJG856SHFG57656JHDFDSDFGTHJJJ015'')

-- @tipo_DtEmissao_RegAux_Emi_pJ = PJ 
-- 2 = (select LicencaS4E from Configuracao) In ('THGF6453JD81HDHCBVJG856SHFG57656JHDFDSDFGTHJJJ015')

	-- Calcular as parcelas que irao sair no relatorio 
	 Set @SQL = 'insert Mensalidade_emitidas (cd_parcela,DT_VENCIMENTO,mes, inicio_cobertura,qt_diasmes,vl_debito) ' 
	 if @tp_associado in (0,1)	 
	 begin
		 Set @SQL = @SQL + 'SELECT 
				m.cd_parcela,  
				convert(varchar(10),m.DT_VENCIMENTO,101) ,
				month(m.dt_inicio_cobertura) ,
				Day(m.dt_inicio_cobertura) as dia_inicio, 
				case when '''+@mes+'''=''02'' then 28 else 30 end as qt_dia_mes,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as vl_debito
		   FROM MENSALIDADES as m inner join associados as a on m.cd_associado_empresa = a.cd_Associado 
		            inner join empresa as e on a.cd_empresa = e.cd_empresa 
		  WHERE m.tp_associado_empresa = 1 
		    and m.cd_tipo_pagamento not in (1) '

		 Set @SQL = @SQL + ' and m.dt_emissao >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_emissao < '''+convert(varchar(10),@dt_f,101)+''' '
		  
		  --if @tipo_DtEmissao_RegAux_Emi_pf = 3 
		  --   Set @SQL = @SQL + ' '
		  --else    
			 -- if @tipo_DtEmissao_RegAux_Emi_pf >= 2 
				--Set @SQL = @SQL + ' and m.dt_vencimento >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_vencimento < '''+convert(varchar(10),@dt_f,101)+''' '
			 -- else
				--Set @SQL = @SQL + ' and m.dt_gerado >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_gerado < '''+convert(varchar(10),@dt_f,101)+''' '		    
			
		  if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo)	
		    
	 End 
	 if @tp_associado in (0)
		 Set @SQL = @SQL + ' 
		   union 
		   '
	 if @tp_associado in (0,2)	 
	 begin
		 Set @SQL = @SQL + 'SELECT 
				m.cd_parcela,  
				convert(varchar(10),m.DT_VENCIMENTO,101) ,
				month(m.dt_inicio_cobertura) ,				
				day(m.dt_inicio_cobertura) as dia_inicio , 
				case when '''+@mes+'''=''02'' then 28 else 30 end as qt_dia_mes,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as vl_debito
		   FROM MENSALIDADES as m inner join empresa as e on m.cd_associado_empresa = e.cd_empresa 
		  WHERE m.tp_associado_empresa in (2,3) 
		    and m.cd_tipo_pagamento not in (1) '

		 Set @SQL = @SQL + ' and m.dt_emissao >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_emissao < '''+convert(varchar(10),@dt_f,101)+''' '

		  --if @tipo_DtEmissao_RegAux_Emi_pf = 3 
		  --   Set @SQL = @SQL + ' '
		  --else 
			 -- if @tipo_DtEmissao_RegAux_Emi_pJ=2
				--Set @SQL = @SQL + ' and m.dt_vencimento >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_vencimento < '''+convert(varchar(10),@dt_f,101)+''' '
			 -- else		    
				--Set @SQL = @SQL + ' and m.dt_gerado >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_gerado < '''+convert(varchar(10),@dt_f,101)+''' '
			
		 if @centro_custo > 0 
		    Set @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@centro_custo)	
			
	 End 		

	 print @sql
	 exec (@sql)	
	 
     -- Atualizar dias mes corrente e valor do dia p calculo do pro-rata
     update Mensalidade_emitidas
        set qt_diasmescorrente = qt_diasmes - inicio_cobertura + case when (select LicencaS4E from Configuracao) In ('UHD68FDSSHDS87622ASBVQ71619A87287776SDS0KJUY66001') and mensalidades.TP_ASSOCIADO_EMPRESA=1 then 0 else 1 end,
            vl_dia = ROUND(vl_debito/qt_diasmes,2),
            inicio_cobertura = case when inicio_cobertura>30 then 30 when inicio_cobertura>28 and @mes='02' then 28 else inicio_cobertura end 
       from mensalidades
      where Mensalidade_emitidas.cd_parcela = mensalidades.CD_PARCELA
     
     -- Atualizar o pro-rata  
     update Mensalidade_emitidas
	   set janeiro   = case when mes = 1 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 1 then vl_dia * qt_diasmescorrente
							else 0 end,
		   fevereiro = case when mes = 1 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 2 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 2 then vl_dia * qt_diasmescorrente
							else 0 end,
		   marco = case when mes = 2 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 3 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 3 then vl_dia * qt_diasmescorrente
							else 0 end,                        
		   abril = case when mes = 3 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 4 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 4 then vl_dia * qt_diasmescorrente
							else 0 end,                        
		   maio = case when mes = 4 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 5 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 5 then vl_dia * qt_diasmescorrente
							else 0 end, 
		   junho = case when mes = 5 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 6 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 6 then vl_dia * qt_diasmescorrente
							else 0 end, 
		   julho = case when mes = 6 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 7 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 7 then vl_dia * qt_diasmescorrente
							else 0 end, 
		   agosto = case when mes = 7 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 8 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 8 then vl_dia * qt_diasmescorrente
							else 0 end,                                                                                             
		   setembro = case when mes = 8 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 9 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 9 then vl_dia * qt_diasmescorrente
							else 0 end,                        
		   outubro = case when mes = 9 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 10 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 10 then vl_dia * qt_diasmescorrente
							else 0 end,  
		   novembro = case when mes = 10 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 11 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 11 then vl_dia * qt_diasmescorrente
							else 0 end,                                              
		   dezembro = case when mes = 11 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							when mes = 12 and qt_diasmes = qt_diasmescorrente  then vl_debito 
							when mes = 12 then vl_dia * qt_diasmescorrente
							else 0 end, 
		   janeiro_1 = case when mes = 12 and qt_diasmes <> qt_diasmescorrente  then vl_debito - (vl_dia * qt_diasmescorrente)
							else 0 end

  
            
	-- Emitidas
	 Set @SQL = '' 
	 if @tp_associado in (0,1)
	 Begin
		Set @SQL = @SQL + 'SELECT 
				case when e.tp_empresa=8 then ''CADE'' else ''PF'' end as tipo, -- Alterado
				m.CD_ASSOCIADO_empresa as codigo, a.nm_completo as nome, 
				isnull(a.nr_cpf,'''') nr_CPF_CGC,
				m.cd_parcela as Documento,  
				convert(varchar(10),dt_emissao ,103) as dt_emissao,				
				convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
                convert(varchar(10),m.dt_inicio_cobertura,103) as Dt_InicioCobertura,
                convert(varchar(10),a.dt_assinatura_contrato,103) as dt_assinaturacontrato,
				me.qt_diasmes,
				me.qt_diasmescorrente as DiasMesCobertura,
			    m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0) as Parcela,
				
				(SELECT sum(tt1.valor_aliquota)
				FROM parcela_aliquota tt1
				inner join Aliquota tt2 on tt1.cd_aliquota = tt2.cd_aliquota
				WHERE tt1.cd_parcela = m.cd_parcela
				and tT2.cd_grupo_aliquota = 5
				AND tt1.dt_exclusao IS NULL) as iss,

					ISNULL(m.vl_imposto,0) as Imposto,					
			    m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,				
				isnull(m.vl_taxa,0) as taxa,
                me.vl_dia,   
				me.janeiro, me.fevereiro, me.marco, me.abril, me.maio, me.junho, 
				me.julho, me.agosto, me.setembro, me.outubro, me.novembro , me.dezembro, me.janeiro_1,
				t.nm_tipo_pagamento as Carteira,
				isnull(m.NF,m.lnfid) as Lote, nf.lnfProtocolo as Protocolo, 
			    p.ds_tipo_parcela,								
				m.dt_vencimento as dt_gerado, e.nm_fantasia,
				(select count(0) from mensalidades_planos mp where mp.cd_parcela_mensalidade = m.cd_parcela and dt_exclusao is null and cd_tipo_parcela=1) qtde_vidas, 
				ge.nm_grupo, ce.ds_centro_custo
				, ce2.ds_centro_custo as ds_centro_custo_aux -- incluido
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado 
		          inner join Mensalidade_emitidas as me on m.cd_parcela = me.cd_parcela 
		          inner join empresa as e on a.cd_empresa = e.cd_empresa and e.tp_empresa < 10
		          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
			      inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela		
			       left join lote_Nfe as nf on m.lnfid = nf.lnfid      
			       left join grupo as ge on e.cd_grupo = ge.cd_grupo    
			       left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
				   left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo  -- incluido

		  WHERE m.tp_associado_empresa = 1 and m.cd_tipo_parcela < 100
		    -- and m.cd_tipo_parcela in (1,2,5) 
		    '

		 Set @SQL = @SQL + ' and m.dt_emissao >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_emissao < '''+convert(varchar(10),@dt_f,101)+''' '
		    
		  --if @tipo_DtEmissao_RegAux_Emi_pf>=2
		  --   Set @SQL = @SQL + ' and m.dt_vencimento >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_vencimento < '''+convert(varchar(10),@dt_f,101)+''' '
		  --else
		  --   Set @SQL = @SQL + ' and m.dt_gerado >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_gerado < '''+convert(varchar(10),@dt_f,101)+''' '
		    
		   -- Set @SQL = @SQL + ' and m.cd_tipo_recebimento <> 1 
		   -- and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101) + ''')
		   -- and not (m.cd_tipo_recebimento = 2 and m.dt_baixa < '''+convert(varchar(10),@dt_f,101) + ''' )
		   -- 		'
		 
		 if @grupo > 0 
		    Set @SQL = @SQL + ' and e.cd_grupo = ' + convert(varchar(10),@grupo) 
		    
		 Set @SQL = @SQL + ' and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101) + ''') '
				
		 Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '			    
				
	 End	 
	 
	 if @tp_associado in (0)
	 Begin
		 Set @SQL = @SQL + ' 
		   union 
		   '
	 End 

	 if @tp_associado in (0,2)
	 Begin	 
		 Set @SQL = @SQL + 'SELECT 
					case when e.tp_empresa=2 then ''PJ'' else ''CADE'' end as tipo, -- Alterado
					m.CD_ASSOCIADO_empresa as codigo, e.NM_RAZSOC as nome, 
				    isnull(e.nr_cgc,'''') nr_CPF_CGC,
				    m.cd_parcela as Documento,  
					convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
					convert(varchar(10),m.DT_VENCIMENTO,103) as dt_venc,
                    convert(varchar(10),m.dt_inicio_cobertura,103) as Dt_InicioCobertura,
                    convert(varchar(10),e.dt_fechamento_contrato,103) as dt_assinaturacontrato,
					me.qt_diasmes,
					me.qt_diasmescorrente as DiasMesCobertura,
					m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0) as Parcela,
				    
					(SELECT sum(tt1.valor_aliquota)
					FROM parcela_aliquota tt1
					inner join Aliquota tt2 on tt1.cd_aliquota = tt2.cd_aliquota
					WHERE tt1.cd_parcela = m.cd_parcela
					and tT2.cd_grupo_aliquota = 5
					AND tt1.dt_exclusao IS NULL) as iss,

					ISNULL(m.vl_imposto,0) as Imposto,
					m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,				
					isnull(m.vl_taxa,0) as taxa,
					me.vl_dia,   
					me.janeiro, me.fevereiro, me.marco, me.abril, me.maio, me.junho, 
					me.julho, me.agosto, me.setembro, me.outubro, me.novembro , me.dezembro, me.janeiro_1,
					t.nm_tipo_pagamento as Carteira,
					isnull(m.NF,m.lnfid) as Lote, nf.lnfProtocolo as Protocolo, 
					p.ds_tipo_parcela,
				    m.dt_gerado, e.nm_fantasia, 
				    case when (select count(0) from MensalidadesAgrupadas where cd_parcelamae=m.CD_PARCELA)>0 then
				    (select count(0) from mensalidades_planos mp where mp.cd_parcela_mensalidade in (select cd_parcela from MensalidadesAgrupadas where cd_parcelamae=m.CD_PARCELA) and dt_exclusao is null and cd_tipo_parcela in (1,2))  
				    else
				    (select count(0) from mensalidades_planos mp where mp.cd_parcela_mensalidade = m.cd_parcela and dt_exclusao is null and cd_tipo_parcela in (1,2))  
				    end as qtde_vidas,
				    ge.nm_grupo, ce.ds_centro_custo
					, ce2.ds_centro_custo as ds_centro_custo_aux  -- incluido
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and e.tp_empresa < 10
			   		  inner join Mensalidade_emitidas as me on m.cd_parcela = me.cd_parcela 
			          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
			          inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
			           left join lote_Nfe as nf on m.lnfid = nf.lnfid
			           left join grupo as ge on e.cd_grupo = ge.cd_grupo
			           left join centro_custo as ce on e.cd_centro_custo = ce.cd_centro_custo
					   left join centro_custo as ce2 on e.cd_centro_custo_aux = ce2.cd_centro_custo   -- incluido

			  WHERE m.tp_associado_empresa in (2,3) and m.cd_tipo_parcela < 100
			    -- and m.cd_tipo_parcela in (1,2,5) 
			    '

		 Set @SQL = @SQL + ' and m.dt_emissao >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_emissao < '''+convert(varchar(10),@dt_f,101)+''' '

		 if @grupo > 0 
		    Set @SQL = @SQL + ' and e.cd_grupo = ' + convert(varchar(10),@grupo) 
		    
		  --if @tipo_DtEmissao_RegAux_Emi_pj>=2 
		  --   Set @SQL = @SQL + ' and m.dt_vencimento >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_vencimento < '''+convert(varchar(10),@dt_f,101)+''' '
		  --else
		  --   Set @SQL = @SQL + ' and m.dt_gerado >= '''+convert(varchar(10),@dt_i,101) + ''' and m.dt_gerado < '''+convert(varchar(10),@dt_f,101)+''' '

		 -- Set @SQL = @SQL + ' and m.cd_tipo_recebimento <> 1 
		 --       and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101) + ''')			    
 		 --	    and not (m.cd_tipo_recebimento = 2 and m.dt_baixa < '''+convert(varchar(10),@dt_f,101) + ''' )
		 --		'

		 Set @SQL = @SQL + ' and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= '''+convert(varchar(10),@dt_f,101) + ''') '
		 
		 Set @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) '			    
				
     End      
     
     --Set @SQL = @SQL + ' ORDER BY case when m.tp_Associado_empresa = 1 then m.dt_vencimento else m.dt_gerado end, 2'
     Set @SQL = @SQL + ' ORDER BY m.dt_gerado, 2'
    
    print @sql
    exec (@sql)	
	 
 End 
