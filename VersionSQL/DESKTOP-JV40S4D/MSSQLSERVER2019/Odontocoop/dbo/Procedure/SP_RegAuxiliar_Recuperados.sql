/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Recuperados]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Recuperados] (@mes varchar(2), @ano varchar(4))
as 
Begin 

-- REGISTRO DE CONTRAPRESTAÇÕES Recuperados – VI

Declare @dt_i date --= '08/01/2013' 
Declare @dt_f date --= '09/01/2013' 
Declare @QtMesesBaixaTituloAns tinyint 

Select @QtMesesBaixaTituloAns = isnull(QtMesesBaixaTituloAns,0) from Configuracao 
if @QtMesesBaixaTituloAns = 0 
Begin
   RAISERROR ('Quantidade de dias para baixa dos titulos na ans não configurado.', 16, 1)
   return
End 

Set @dt_i = convert(date,@mes + '/01/' + @ano )
Set @dt_f = DATEADD(month,1,@dt_i)

	 -- Recebidas 
	
	 SELECT 1 as tipoDocumento, 
			d.CD_SEQUENCIAL, 
			d.cd_associado , -- contrato
			m.CD_PARCELA , -- doc
			m.DT_GERADO, -- Emissao
			d1.NM_DEPENDENTE, -- Titular
			b.nm_beneficiario, -- Usuario
			case when b.nr_cpf IS not null then b.nr_cpf else d1.nr_cpf_dep end nr_CPF, -- CPF
			convert(varchar(10),b.dt_inclusao,3) as InicioContrato,  
			'00/00/00' as FimContrato, 
			m.DT_VENCIMENTO,  
			mp.valor, 
			case when d.CD_GRAU_PARENTESCO=1 and m.tp_associado_empresa=1 then m.VL_Acrescimo else 0 end, -- juros 
			case when d.CD_GRAU_PARENTESCO>1 then 0 
				 when isnull(ass.taxa_cobranca,0) = 0 then 0 
				 else (select vl_taxa from TIPO_PAGAMENTO as t, tipo_servico_bancario as ts where m.cd_tipo_pagamento = T.cd_tipo_pagamento and t.cd_tipo_servico_bancario = ts.cd_tipo_servico_bancario)
			End as TaxaServico,             
			case when d.CD_GRAU_PARENTESCO=1 and m.tp_associado_empresa=1 then m.VL_Desconto  else 0 end , -- desconto
			m.DT_Pagamento, 
			m.lnfId , -- nota fiscal
			b.cd_plano_ans as numeroPlanoANS, 
			g.nm_GRAU_PARENTESCO as relacaoDependencia,  
			e.nm_fantasia as NomeFantasia , 
			d.vl_plano
	 
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
	   and m.DT_PAGAMENTO >= @dt_i and m.DT_PAGAMENTO < @dt_f and m.CD_TIPO_RECEBIMENTO > 2
	   and m.DT_VENCIMENTO < DATEADD(month,@QtMesesBaixaTituloAns*-1,@dt_i)
	   and m.cd_tipo_parcela = 1 
	   and mp.dt_exclusao is null
	   and dt_inclusao < @dt_f 
	   and (b.dt_exclusao is null or b.dt_exclusao >= @dt_f)  
	 ORDER BY m.DT_VENCIMENTO, d.cd_associado , g.cd_grau_parentesco  
 
 End 
