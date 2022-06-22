/****** Object:  Procedure [dbo].[SP_Resumo_Banco]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Resumo_Banco] @lote int , @data datetime 
As
Begin

    Delete Lote_Processos_Bancos_resumo where cd_lote = @lote 
     
	Declare @cd_ass int 
	Declare @tp_ass int
	Declare @vl_parcela money
	Declare @dt_venc datetime 

	Declare @vl_parcela_a money
	Declare @dt_venc_a datetime 

	Declare @tp_pag int 
	Select @tp_pag = cd_tipo_pagamento from Lote_Processos_Bancos where cd_sequencial=@lote

	Declare @cd_parc int 
	Declare cursor_men_resumo CURSOR FOR
	select cd_parcela from Lote_Processos_Bancos_Mensalidades where cd_sequencial_lote=@lote and dt_vencimento = @data
	Open cursor_men_resumo
	FETCH NEXT FROM cursor_men_resumo INTO @cd_parc
	WHILE (@@FETCH_STATUS <> -1)  
	begin  -- 2.2        

	  Select @cd_ass = cd_Associado_empresa , @tp_ass = tp_Associado_empresa, @vl_parcela=VL_PARCELA , @dt_venc=DT_VENCIMENTO ,
			 @vl_parcela_a=null , @dt_venc_a=null  
		from MENSALIDADES 
	   where CD_PARCELA = @cd_parc 
	  
	   select @vl_parcela_a=VL_PARCELA , @dt_venc_a=DT_VENCIMENTO
		 from MENSALIDADES 
		where CD_ASSOCIADO_empresa=@cd_ass and TP_ASSOCIADO_EMPRESA=@tp_ass and 
			  DT_VENCIMENTO=DATEADD(month,-1,@dt_venc)
	          
		if @vl_parcela_a is null 
		  insert Lote_Processos_Bancos_resumo (cd_lote,cd_Associado,acao) values (@lote,@cd_ass,'I')

		if @vl_parcela_a <> @vl_parcela 
		  insert Lote_Processos_Bancos_resumo (cd_lote,cd_Associado,acao) values (@lote,@cd_ass,'A')
	      
	  FETCH NEXT FROM cursor_men_resumo INTO @cd_parc
	END
	Close cursor_men_resumo
	deallocate cursor_men_resumo

    if @tp_ass = 1 
    Begin -- Associados 
		insert Lote_Processos_Bancos_resumo (cd_lote,cd_Associado,acao,nm_situacao)
		select @lote, CD_ASSOCIADO_empresa, 'E', sh.NM_SITUACAO_HISTORICO 
		  from MENSALIDADES as m, DEPENDENTES as d, HISTORICO as h , SITUACAO_HISTORICO as sh
		 where m.CD_ASSOCIADO_empresa = d.CD_ASSOCIADO and d.CD_GRAU_PARENTESCO=1 and 
		       d.CD_Sequencial_historico = h.cd_sequencial and h.CD_SITUACAO not in (2) and 
		       h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 
		       m.CD_TIPO_PAGAMENTO = @tp_pag and 
		 	   m.cd_tipo_parcela=1 and 
			   m.CD_TIPO_RECEBIMENTO not in (1,2) and 
			   m.TP_ASSOCIADO_EMPRESA=1 and 
			   m.DT_VENCIMENTO in (select distinct DATEADD(MONTH,-1,DT_VENCIMENTO) from Lote_Processos_Bancos_Mensalidades where cd_sequencial_lote=@lote and dt_vencimento=@data) and 
			   m.CD_ASSOCIADO_empresa not in (
					 select CD_ASSOCIADO_empresa 
					   from MENSALIDADES as m1
					  where m1.cd_tipo_parcela=1 and m1.TP_ASSOCIADO_EMPRESA=1 and 
					        m1.CD_TIPO_RECEBIMENTO not in (1,2) and 
							m1.dt_vencimento in (select distinct DT_VENCIMENTO from Lote_Processos_Bancos_Mensalidades where cd_sequencial_lote=@lote and dt_vencimento=@data)
					 ) 
 	End 
 	else
 	Begin 
		insert Lote_Processos_Bancos_resumo (cd_lote,cd_Associado,acao,nm_situacao)
		select @lote, CD_ASSOCIADO_empresa, 'E', sh.NM_SITUACAO_HISTORICO 
		  from MENSALIDADES as m, empresa as d, HISTORICO as h , SITUACAO_HISTORICO as sh
		 where m.CD_ASSOCIADO_empresa = d.cd_empresa and 
		       d.CD_Sequencial_historico = h.cd_sequencial and h.CD_SITUACAO not in (2) and 
		       h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO and 
		       m.CD_TIPO_PAGAMENTO = @tp_pag and 
		 	   m.cd_tipo_parcela=1 and 
			   m.CD_TIPO_RECEBIMENTO not in (1,2) and 
			   m.TP_ASSOCIADO_EMPRESA>1 and -- Empresa
			   m.DT_VENCIMENTO in (select distinct DATEADD(MONTH,-1,DT_VENCIMENTO) from Lote_Processos_Bancos_Mensalidades where cd_sequencial_lote=@lote and dt_vencimento=@data) and 
			   m.CD_ASSOCIADO_empresa not in (
					 select CD_ASSOCIADO_empresa 
					   from MENSALIDADES as m1
					  where m1.cd_tipo_parcela=1 and m1.TP_ASSOCIADO_EMPRESA>1 and 
					        m1.CD_TIPO_RECEBIMENTO not in (1,2) and   
							m1.DT_VENCIMENTO in (select distinct DT_VENCIMENTO from Lote_Processos_Bancos_Mensalidades where cd_sequencial_lote=119 and dt_vencimento=@data)
					 ) 

 	
 	End 
 	     
    Select cd_Associado, Case when acao='I' then 'Inc' when acao='A' then 'Alt' else 'Mud. Status' end as nm_acao,nm_situacao
     from Lote_Processos_Bancos_resumo
     where cd_lote = @lote
     order by acao, cd_associado 
	      
End       
