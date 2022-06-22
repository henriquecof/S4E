/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Comissoes]    Committed by VersionSQL https://www.versionsql.com ******/

Create Procedure [dbo].[SP_RegAuxiliar_Comissoes] (@mes varchar(2), @ano varchar(4))
as 
Begin 

-- REGISTRO DE COMISSOES EMITIDAS – II

Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 


Set @dt_i = convert(date,@mes + '/01/' + @ano )
Set @dt_f = DATEADD(month,1,@dt_i)

	 -- Recebidas 
	
	 SELECT 1 as tipoDocumento, 
			d.CD_SEQUENCIAL, 
			m.CD_PARCELA , -- contrato
			cv.cd_sequencial_mensalidade_planos , -- doc
			lc.dt_base_fim , -- Emissao
			f.nm_empregado ,
			f.nr_cpf,
			cv.valor,
			cv.perc_pagamento,
			cv.valor * (cv.perc_pagamento/100) 
	 
	  FROM ans_beneficiarios as b , empresa as e, grau_parentesco as g ,  dependentes as d, 
		   ASSOCIADOS as ass , MENSALIDADES as m, Mensalidades_Planos as mp , 
		   DEPENDENTES as d1,  /* Titular */ 
		   comissao_vendedor as cv, lote_comissao as lc , FUNCIONARIO as f
	 WHERE b.cd_sequencial_dep = d.cd_sequencial  
	   and b.cd_grau_parentesco = g.cd_grau_parentesco    
	   and d.CD_ASSOCIADO = ass.cd_associado    
	   and ass.cd_empresa = e.CD_EMPRESA    
	   and ass.cd_associado = d1.CD_ASSOCIADO and d1.CD_GRAU_PARENTESCO=1 -- Titular 
	   and d.CD_SEQUENCIAL = mp.cd_sequencial_dep 
	   and mp.cd_parcela_mensalidade = m.CD_PARCELA 
	   and d.CD_SEQUENCIAL = cv.cd_sequencial_dependente 
	   and mp.cd_sequencial = cv.cd_sequencial_mensalidade_planos 
	   and cv.cd_sequencial_lote = lc.cd_sequencial 
	   and cv.cd_funcionario = f.cd_funcionario 
	   and lc.dt_base_fim >= @dt_i and lc.dt_base_fim < @dt_f 
	   --and m.DT_PAGAMENTO >= @dt_i and m.DT_PAGAMENTO < @dt_f and m.CD_TIPO_RECEBIMENTO > 2
	   --and m.cd_tipo_parcela = 1 
	   and cv.dt_exclusao is null 
	   and mp.dt_exclusao is null
	   and b.dt_inclusao < @dt_f 
	   and (b.dt_exclusao is null or b.dt_exclusao >= @dt_f)  
	 ORDER BY lc.dt_base_fim , lc.cd_sequencial, d.CD_ASSOCIADO , d.CD_SEQUENCIAL 
 
 End 
