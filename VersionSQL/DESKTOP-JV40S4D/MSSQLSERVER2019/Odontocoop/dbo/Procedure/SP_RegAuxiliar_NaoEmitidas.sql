/****** Object:  Procedure [dbo].[SP_RegAuxiliar_NaoEmitidas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_NaoEmitidas] (@mes varchar(2), @ano varchar(4))
as 
Begin 
-- REGISTRO DE CONTRATOS E CONTRAPRESTAÇÕES NAO EMITIDOS – I

Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 

Set @dt_i = convert(date,@mes + '/01/' + @ano )
Set @dt_f = DATEADD(month,1,@dt_i)

	-- Ativos ANS 
	 SELECT d.cd_associado , b.nr_cpf, b.nm_beneficiario, 
			convert(varchar(10),b.dt_inclusao,103) as dataans,  b.cd_plano_ans as numeroPlanoANS, 
			g.nm_GRAU_PARENTESCO as relacaoDependencia,  
			e.nm_fantasia as NomeFantasia , d.vl_plano
	 FROM ans_beneficiarios as b , empresa as e, grau_parentesco as g ,  dependentes as d, ASSOCIADOS as ass , DEPENDENTES as d1 
	 WHERE b.cd_sequencial_dep = d.cd_sequencial  
	 and b.cd_grau_parentesco = g.cd_grau_parentesco    
	 and d.CD_ASSOCIADO = ass.cd_associado    
	 and ass.cd_empresa = e.CD_EMPRESA    
	 and ass.cd_associado = d1.CD_ASSOCIADO and d1.CD_GRAU_PARENTESCO=1 -- Titular  
	 and dt_inclusao < @dt_f
	 and (dt_exclusao is null or dt_exclusao >= @dt_f)  
	 and d.CD_SEQUENCIAL not in 
	 (

		 SELECT d.CD_SEQUENCIAL
		  FROM ans_beneficiarios as b , empresa as e, grau_parentesco as g ,  dependentes as d, 
			   ASSOCIADOS as ass , MENSALIDADES as m, Mensalidades_Planos as mp , 
			   DEPENDENTES as d1 /* Titular */
		 WHERE b.cd_sequencial_dep = d.cd_sequencial  
		   and b.cd_grau_parentesco = g.cd_grau_parentesco    
		   and d.CD_ASSOCIADO = ass.cd_associado    
		   and ass.cd_empresa = e.CD_EMPRESA    
		   and ass.cd_associado = d1.CD_ASSOCIADO and d1.CD_GRAU_PARENTESCO=1 -- Titular 
		   and d.CD_SEQUENCIAL = mp.cd_sequencial_dep 
		   and mp.cd_parcela_mensalidade = m.CD_PARCELA 
		   and m.DT_GERADO >= @dt_i 
		   and m.DT_GERADO < @dt_f 
		   and m.CD_TIPO_RECEBIMENTO <> 1
		   and m.cd_tipo_parcela = 1 
		   and mp.dt_exclusao is null
		   and dt_inclusao < @dt_f 
		   and (b.dt_exclusao is null or b.dt_exclusao >= @dt_f)  
	 
	 )
	 ORDER BY d.cd_associado , g.cd_grau_parentesco  

End 
