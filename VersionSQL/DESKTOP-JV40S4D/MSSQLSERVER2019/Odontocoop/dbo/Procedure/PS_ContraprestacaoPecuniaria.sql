/****** Object:  Procedure [dbo].[PS_ContraprestacaoPecuniaria]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_ContraprestacaoPecuniaria] (@tipo tinyint, @dataInicial date, @dataFinal date)
AS
BEGIN
	
Declare @dt_ini date = @dataInicial
Declare @dt_fim date = @dataFinal 

--@tipo: 1 - Sintetico / 2 - A vencer / 3 - Iniciado EM / 4 - Atrasados

if @tipo = 1
	begin --1
		-- Sintetico
		 Select tipo, 
				IniciadoEm, 
				case when IniciadoEm = 99 then 0 else sum(Titulo) end as ValorEmitido, 
				sum(case when TipoRecebimento=2 then titulo else 0 end) as ValorRecebido, 
				sum(case when TipoRecebimento=0 then 
					   case when DataInicioCobertura<@dt_fim then titulo else 0 end
					else 0 end) as ValorVencido,
				sum(case when TipoRecebimento=0 then 
						 case when DataInicioCobertura<@dt_fim then 0 else titulo end 
					else 0 end) as ValorVencer,
			     0 as ValorCancelado
		   from (

			  -- A vencer
			 SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				m.dt_inicio_cobertura as DataInicioCobertura,
				--case when convert(varchar(6),m.dt_inicio_cobertura,112) > convert(varchar(6),m.dt_emissao,112) then 0 else day(m.dt_inicio_cobertura) end as IniciadoEm,
				0 as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					-- when m.CD_TIPO_RECEBIMENTO in (1,2) or dt_cancelado_contabil is not null then 1 -- Cancelado
					 else 0 end as TipoRecebimento , -- Aberto 
				isnull(m.dt_credito, m.DT_PAGAMENTO) as DtCredito,
				m.dt_vencimento as dt_vencimento,
				m.dt_cancelado_contabil
		 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_inicio_cobertura >= @dt_fim 
				and m.dt_vencimento >= @dt_fim 
				and m.dt_emissao < @dt_fim
				and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
				and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
				and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
				and m.CD_TIPO_RECEBIMENTO not in (1)
			 union 

			  -- iniciado em 
			 SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				m.dt_inicio_cobertura as DataInicioCobertura,
				--case when convert(varchar(6),m.dt_inicio_cobertura,112) > convert(varchar(6),m.dt_emissao,112) then 0 else day(m.dt_inicio_cobertura) end as IniciadoEm,
				day(m.dt_inicio_cobertura) as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					-- when m.CD_TIPO_RECEBIMENTO in (1,2) or dt_cancelado_contabil is not null then 1 -- Cancelado
					 else 0 end as TipoRecebimento , -- Aberto 
				isnull(m.dt_credito, m.DT_PAGAMENTO) as DtCredito,
				m.dt_vencimento as dt_vencimento,
				m.dt_cancelado_contabil
		 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_inicio_cobertura >= @dt_ini 
				and m.dt_inicio_cobertura < @dt_fim
				and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
				and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
				and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
				and m.CD_TIPO_RECEBIMENTO not in (1)
			 union -- Meses anteriores


		SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				m.dt_inicio_cobertura as DataInicioCobertura,
				99 as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					 else 0 end as TipoRecebimento , -- Aberto 
				isnull(m.dt_credito, m.DT_PAGAMENTO) as DtCredito,
				m.dt_vencimento as dt_vencimento,
				m.dt_cancelado_contabil
			 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_vencimento < @dt_ini --@dt_fim
			--	and m.dt_emissao < @dt_fim
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.CD_TIPO_RECEBIMENTO not in (1)
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
				and (    (m.CD_TIPO_RECEBIMENTO in (0) and m.dt_cancelado_contabil is null ) -- Aberta
						or (m.dt_cancelado_contabil >= @dt_fim) -- Cancelada depois da competencia
						or (m.CD_TIPO_RECEBIMENTO =2 and isnull(m.dt_cancelado_contabil,@dt_fim) >= @dt_fim)
						or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= @dt_fim ) -- Pago depois da competencia
					)
				and m.cd_parcela not in (
						   SELECT  m.cd_parcela 
							 FROM MENSALIDADES as m 
							WHERE m.cd_tipo_parcela < 100
								and m.dt_inicio_cobertura >= @dt_ini 
								and m.dt_inicio_cobertura < @dt_fim
								and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
								and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
								and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
								and m.dt_inicio_cobertura is not null 
								and m.dt_emissao is not null 
								and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
						   )

				) as x
			group by tipo,IniciadoEm
			order by tipo,IniciadoEm
	end --1

if @tipo = 2
	begin --2
		-- A Vencer 
		SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				case when m.TP_ASSOCIADO_EMPRESA=1 then (select top 1 nm_completo from ASSOCIADOS where cd_associado = CD_ASSOCIADO_empresa) else (select top 1 NM_RAZSOC from EMPRESA where CD_EMPRESA = CD_ASSOCIADO_empresa) end as ASSOCIADO_empresa,
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				convert(varchar(10),m.dt_inicio_cobertura,103) as DataInicioCobertura,
				--case when convert(varchar(6),m.dt_inicio_cobertura,112) > convert(varchar(6),m.dt_emissao,112) then 0 else day(m.dt_inicio_cobertura) end as IniciadoEm,
				0 as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					 --when m.CD_TIPO_RECEBIMENTO in (1,2) then 1 
					 else 0 end as TipoRecebimento , -- Aberto 
				convert(varchar(10),isnull(m.dt_credito, m.DT_PAGAMENTO),103) as DtCredito,
				convert(varchar(10),m.dt_vencimento,103) as dt_vencimento, 
				convert(varchar(10),m.dt_cancelado_contabil,103) as dt_cancelado_contabil,
				convert(varchar(10),m.dt_baixa,103) as dt_baixa 
			 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_inicio_cobertura >= @dt_fim
				and m.dt_vencimento >= @dt_fim 
				and m.dt_emissao < @dt_fim
				and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
				and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
				and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.CD_TIPO_RECEBIMENTO not in (1)
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
			--	and m.cd_parcela in (8835035,8835036)
		   order by tipo, day(dt_inicio_cobertura)
	end --2

if @tipo = 3
	begin --3
		-- Iniciado EM 
		SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				case when m.TP_ASSOCIADO_EMPRESA=1 then (select top 1 nm_completo from ASSOCIADOS where cd_associado = CD_ASSOCIADO_empresa) else (select top 1 NM_RAZSOC from EMPRESA where CD_EMPRESA = CD_ASSOCIADO_empresa) end as ASSOCIADO_empresa,
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				convert(varchar(10),m.dt_inicio_cobertura,103) as DataInicioCobertura,
				--case when convert(varchar(6),m.dt_inicio_cobertura,112) > convert(varchar(6),m.dt_emissao,112) then 0 else day(m.dt_inicio_cobertura) end as IniciadoEm,
				day(m.dt_inicio_cobertura) as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					 --when m.CD_TIPO_RECEBIMENTO in (1,2) then 1 
					 else 0 end as TipoRecebimento , -- Aberto 
				convert(varchar(10),isnull(m.dt_credito, m.DT_PAGAMENTO),103) as DtCredito,
				convert(varchar(10),m.dt_vencimento,103) as dt_vencimento, 
				convert(varchar(10),m.dt_cancelado_contabil,103) as dt_cancelado_contabil,
				convert(varchar(10),m.dt_baixa,103) as dt_baixa 
			 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_inicio_cobertura >= @dt_ini 
				and m.dt_inicio_cobertura < @dt_fim
				and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
				and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
				and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.CD_TIPO_RECEBIMENTO not in (1)
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
			--	and m.cd_parcela in (8835035,8835036)
		   order by tipo, day(dt_inicio_cobertura)
	end --3

if @tipo = 4
	begin --4
		-- Atrasados
		SELECT  m.cd_parcela , m.cd_associado_empresa,
				case when m.TP_ASSOCIADO_EMPRESA=1 then 3 else 2 end as tipo, -- Alterado
				case when m.TP_ASSOCIADO_EMPRESA=1 then (select top 1 nm_completo from ASSOCIADOS where cd_associado = CD_ASSOCIADO_empresa) else (select top 1 NM_RAZSOC from EMPRESA where CD_EMPRESA = CD_ASSOCIADO_empresa) end as ASSOCIADO_empresa,
				convert(varchar(10),m.dt_emissao,103) as dt_emissao,				
				convert(varchar(10),m.dt_inicio_cobertura,103) as DataInicioCobertura,
				99 as IniciadoEm,
				m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0) as Titulo,
				case when m.CD_TIPO_RECEBIMENTO>2 and isnull(m.dt_credito, m.DT_PAGAMENTO)<@dt_fim then 2 -- Pago
					-- when m.CD_TIPO_RECEBIMENTO in (1,2) then 1 
					 else 0 end as TipoRecebimento , -- Aberto 
				convert(varchar(10),isnull(m.dt_credito, m.DT_PAGAMENTO),103) as DtCredito,
				convert(varchar(10),m.dt_vencimento,103) as dt_vencimento, 
				convert(varchar(10),m.dt_cancelado_contabil,103) as dt_cancelado_contabil,
				convert(varchar(10),m.dt_baixa,103) as dt_baixa 
			FROM MENSALIDADES as m 
			WHERE m.cd_tipo_parcela < 100
				and m.dt_vencimento < @dt_ini --@dt_fim
				--and m.dt_emissao < @dt_fim
				and m.dt_inicio_cobertura is not null 
				and m.dt_emissao is not null 
				and m.CD_TIPO_RECEBIMENTO not in (1)
				and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
				and (    (m.CD_TIPO_RECEBIMENTO in (0) and m.dt_cancelado_contabil is null ) -- Aberta
						or (m.dt_cancelado_contabil >= @dt_fim) -- Cancelada depois da competencia
						or (m.CD_TIPO_RECEBIMENTO =2 and isnull(m.dt_cancelado_contabil,@dt_fim) >= @dt_fim)
						or (m.CD_TIPO_RECEBIMENTO >2 and m.dt_cancelado_contabil is null and isnull(m.dt_credito, m.dt_pagamento) >= @dt_fim ) -- Pago depois da competencia
					)
				and m.cd_parcela not in (
						   SELECT  m.cd_parcela 
							 FROM MENSALIDADES as m 
							WHERE m.cd_tipo_parcela < 100
								and m.dt_inicio_cobertura >= @dt_ini 
								and m.dt_inicio_cobertura < @dt_fim
								and (m.dt_cancelado_contabil is null or m.dt_cancelado_contabil >= @dt_fim)  
								and m.cd_tipo_parcela not in (select cd_tipo_parcela from tipo_parcela where fl_excluir_regaux=1 ) 
								and m.cd_parcela not in (select cd_parcela from exclusao_regaux_parcelas) 
								and m.dt_inicio_cobertura is not null 
								and m.dt_emissao is not null 
								and m.vl_parcela + isnull(m.vl_acrescimo,0) - isnull(m.vl_desconto,0)-ISNULL(m.vl_imposto,0)>0
						   )
						--and m.cd_parcela in (8835035,8835036)

		   order by tipo, day(dt_inicio_cobertura)
	end --4

END
