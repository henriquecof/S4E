/****** Object:  Procedure [dbo].[SP_AtualizaDataPagamentoCarencia]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_AtualizaDataPagamentoCarencia]
as
Begin

  --  print 'x' 
 
	update DEPENDENTES 
	   set dependentes.dt_pagamentoadesao = t4.DT_PAGAMENTO 
	  from ASSOCIADOS t1, EMPRESA t3, MENSALIDADES t4, mensalidades_planos t5, RegraCarenciaAtendimento T6, 
	       HISTORICO T7, SITUACAO_HISTORICO T8
 	 where t1.cd_associado = DEPENDENTES.CD_ASSOCIADO 
	   and t1.cd_empresa = t3.CD_EMPRESA
	   and t3.rcaId = t6.rcaID 
 	   and t6.tcaId=4 
	   and DEPENDENTES.CD_SEQUENCIAL = t5.cd_sequencial_dep 
	   and DEPENDENTES.dt_pagamentoadesao is null 
	   and DEPENDENTES.cd_Sequencial_historico = t7.cd_sequencial 
	   and t7.CD_SITUACAO = t8.CD_SITUACAO_HISTORICO 
	   and t8.fl_gera_cobranca=1 
	   and t5.cd_parcela_mensalidade = t4.CD_PARCELA 
	   and t4.TP_ASSOCIADO_EMPRESA = 1 
	   --and t4.cd_tipo_parcela in (1,2)
	   and t4.cd_tipo_parcela in (1)
	   and T4.CD_TIPO_RECEBIMENTO not in (0,1,2) 
--	   and DEPENDENTES.dt_assinaturaContrato <= t4.DT_VENCIMENTO 
	   and convert(smalldatetime,substring(convert(varchar(10),DEPENDENTES.mm_aaaa_1pagamento),5,2) + '/'+ 
		   case when substring(convert(varchar(10),DEPENDENTES.mm_aaaa_1pagamento),5,2)='02' and t3.dt_vencimento = 30 then '28' else convert(varchar(10),t3.dt_vencimento) end + '/'+
		   substring(convert(varchar(10),DEPENDENTES.mm_aaaa_1pagamento),1,4)) = t4.DT_VENCIMENTO 

End 
