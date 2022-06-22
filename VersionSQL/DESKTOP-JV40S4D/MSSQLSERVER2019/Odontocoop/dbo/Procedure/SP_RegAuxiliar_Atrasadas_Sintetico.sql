/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Atrasadas_Sintetico]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_RegAuxiliar_Atrasadas_Sintetico] (@mes VARCHAR(2), @ano VARCHAR(4), @tp_associado SMALLINT = 0, @centro_custo INT = 0)
AS
BEGIN
	-- REGISTRO DE CONTRAPRESTAÇÕES Atrasadas – II
	DECLARE @SQL VARCHAR(max)
	DECLARE @dt_i DATE --= '08/01/2013' 
	DECLARE @dt_f DATE --= '09/01/2013' 
	DECLARE @dt_fmenos1 DATE

	SET @dt_i = convert(DATE, @mes + '/01/' + @ano)
	SET @dt_f = DATEADD(month, 1, @dt_i)
	SET @dt_fmenos1 = dateadd(day, - 1, @dt_f)
	SET @SQL = ''

    -- alter table configuracao add calculo_ppsc smallint  
    Declare @ppsc smallint -- 0 : faz o calculo olhando a parcela e 1 faz o calculo olhando todo o contrato 
    Select @ppsc = isnull(calculo_ppsc,0) from Configuracao
    

	create table #ppsc (tp_associado_empresa int, cd_Associado_empresa int)

	 insert #ppsc 
	 SELECT distinct m.tp_associado_empresa , m.cd_associado_empresa
	   FROM MENSALIDADES as m 
	  WHERE m.DT_VENCIMENTO < convert(varchar(10),@dt_f,101)
  		and datediff(day,m.DT_VENCIMENTO ,convert(varchar(10),@dt_fmenos1,101)) > case when m.tp_associado_empresa = 1 then 60 else 90 end 
		and m.dt_emissao is not null
		and (    (m.CD_TIPO_RECEBIMENTO =0 and m.dt_cancelado_contabil is null ) -- Aberta
			  or (m.dt_cancelado_contabil >= convert(varchar(10),@dt_f,101)) -- Cancelada depois da competencia
			  or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= convert(varchar(10),@dt_f,101) ) -- Pago depois da competencia
			 ) and 1=2
         
	IF @tp_associado IN (0, 1)
	BEGIN
		SET @SQL = @SQL + 'SELECT 
				datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''') as dias_atraso,
				sum(m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)) as Parcela,
				case when e.tp_empresa = 8 then 8 when m.tp_associado_empresa = 1 then 3 else e.tp_empresa end tp_empresa ,
				case when e.tp_empresa = 8 then ''COLETIVO POR ADESAO'' when m.tp_associado_empresa = 1 then ''INDIVIDUAL FAMILIAR'' else te.ds_empresa end  ds_empresa,
				case when '+convert(varchar(1),@ppsc) + ' = 1 then 
				  case when ppsc.cd_associado_empresa is null then null else 1 end -- ppsc
				else   
					case when case when e.tp_empresa = 8 then 8 when m.tp_associado_empresa = 1 then 3 else e.tp_empresa end = 3 then
						   case when datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''')>=61 then 1 else null end
						 else
						   case when datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''')>=91 then 1 else null end
						 end 
				end as ppsc
		   FROM MENSALIDADES as m inner join ASSOCIADOS as a on m.CD_ASSOCIADO_empresa = a.cd_associado and m.tp_associado_empresa = 1 
		          inner join empresa as e on a.cd_empresa = e.cd_empresa 
		          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
		          inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		          inner join dependentes as d on a.cd_Associado = d.cd_Associado and d.cd_grau_parentesco=1
		          inner join historico as h on d.cd_Sequencial_historico = h.cd_sequencial 
		          inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico 
		          left join lote_Nfe as nf on m.lnfid = nf.lnfid	
		          left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO
		          left join tipo_empresa te on e.tp_empresa = te.tp_empresa
		          left join #ppsc as ppsc on m.cd_associado_empresa = ppsc.cd_associado_empresa and ppsc.tp_associado_empresa = 1 
		  WHERE m.DT_VENCIMENTO < ''' + convert(VARCHAR(10), @dt_f, 101) + ''' 
		    and m.dt_emissao is not null
		     '

		IF @centro_custo > 0
			SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR(10), @centro_custo)
		SET @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and a.cd_associado not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=1	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas)  '
		SET @SQL = @SQL + '    
		        and (    (m.CD_TIPO_RECEBIMENTO =0 and m.dt_cancelado_contabil is null ) -- Aberta
		              or (m.dt_cancelado_contabil >= ''' + convert(VARCHAR(10), @dt_f, 101) + ''') -- Cancelada depois da competencia
		              or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= ''' + convert(VARCHAR(10), @dt_f, 101) + ''' ) -- Pago depois da competencia
		             ) 
		        group by e.tp_empresa, CASE WHEN e.tp_empresa = 8 THEN 8 WHEN m.tp_associado_empresa = 1 THEN 3 ELSE e.tp_empresa END, 
		          CASE WHEN e.tp_empresa = 8 THEN ''COLETIVO POR ADESAO'' WHEN m.tp_associado_empresa = 1 THEN ''INDIVIDUAL FAMILIAR'' ELSE te.ds_empresa END, 
		          datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''') ,
		          case when ppsc.cd_associado_empresa is null then null else 1 end
		 '
	END

	IF @tp_associado IN (0)
	BEGIN
		SET @SQL = @SQL + ' 
		     union all
		                   '
	END

	IF @tp_associado IN (0, 2)
	BEGIN
		SET @SQL = @SQL + 'SELECT 
					datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''') as dias_atraso,
					sum(m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)) as Parcela,
					case when e.tp_empresa = 8 then 8 when m.tp_associado_empresa = 1 then 3 else e.tp_empresa end tp_empresa,
					case when e.tp_empresa = 8 then ''COLETIVO POR ADESAO'' when m.tp_associado_empresa = 1 then ''INDIVIDUAL FAMILIAR'' else te.ds_empresa end  ds_empresa,
				    case when '+convert(varchar(1),@ppsc) + ' = 1 then 
					  case when ppsc.cd_associado_empresa is null then null else 1 end -- ppsc
					else   
						case when case when e.tp_empresa = 8 then 8 when m.tp_associado_empresa = 1 then 3 else e.tp_empresa end = 3 then
						   case when datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''')>=61 then 1 else null end
						 else
						   case when datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + ''')>=91 then 1 else null end
						 end 
					end as ppsc
			   FROM MENSALIDADES as m inner join EMPRESA as e on m.CD_ASSOCIADO_empresa = e.cd_empresa and m.tp_associado_empresa in (2,3) 
			          inner join TIPO_PAGAMENTO as t on m.CD_TIPO_Pagamento = t.cd_tipo_pagamento 
		              inner join historico as h on e.cd_Sequencial_historico = h.cd_sequencial 
		              inner join situacao_historico as sh on h.cd_situacao = sh.cd_situacao_historico 
		              inner join tipo_parcela as p on m.cd_tipo_parcela = p.cd_tipo_parcela
		              left join lote_Nfe as nf on m.lnfid = nf.lnfid		              
		              left join motivo_cancelamento as mc on h.cd_MOTIVO_CANCELAMENTO = mc.cd_MOTIVO_CANCELAMENTO
		              left join tipo_empresa te on e.tp_empresa = te.tp_empresa
		              left join #ppsc as ppsc on m.cd_associado_empresa = ppsc.cd_associado_empresa and ppsc.tp_associado_empresa in (2,3)
		  WHERE m.DT_VENCIMENTO < '''+ convert(VARCHAR(10), @dt_f, 101) + '''
			and m.dt_emissao is not null
		    '

		IF @centro_custo > 0
			SET @SQL = @SQL + ' and e.cd_centro_custo = ' + CONVERT(VARCHAR(10), @centro_custo)
		SET @SQL = @SQL + ' and e.cd_empresa not in (select cd_Associado_empresa from exclusao_registrosauxiliares_empAssoc where tp_associado_empresa=2	) 
		                     and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 )
		                     and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas)  '
		SET @SQL = @SQL + '    
		        and (    (m.CD_TIPO_RECEBIMENTO =0 and m.dt_cancelado_contabil is null ) -- Aberta
		              or (m.dt_cancelado_contabil >= ''' + convert(VARCHAR(10), @dt_f, 101) + ''') -- Cancelada depois da competencia
		              or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= ''' + convert(VARCHAR(10), @dt_f, 101) + ''' ) -- Pago depois da competencia
		             )  
				group by e.tp_empresa, CASE 
		WHEN e.tp_empresa = 8
			THEN 8
		WHEN m.tp_associado_empresa = 1
			THEN 3
		ELSE e.tp_empresa
		END, CASE 
		WHEN e.tp_empresa = 8
			THEN ''COLETIVO POR ADESAO''
		WHEN m.tp_associado_empresa = 1
			THEN ''INDIVIDUAL FAMILIAR''
		ELSE te.ds_empresa
		END, 
		datediff(day,m.DT_VENCIMENTO,''' + convert(VARCHAR(10), @dt_fmenos1, 101) + '''),
		case when ppsc.cd_associado_empresa is null then null else 1 end
		 '
	END

	SET @SQL = @SQL + ' ORDER BY 3,1'

	PRINT @sql

	EXEC (@sql)
	
	drop table #ppsc 
END
