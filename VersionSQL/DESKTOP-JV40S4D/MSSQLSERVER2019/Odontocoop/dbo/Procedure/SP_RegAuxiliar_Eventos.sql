/****** Object:  Procedure [dbo].[SP_RegAuxiliar_Eventos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_RegAuxiliar_Eventos] (@mes varchar(2), @ano varchar(4), @tipo tinyint)
as 
Begin 

    -- @tipo = 1 - Conhecidos, 2 - Pagos

	-- REGISTRO DE EVENTOS

	Declare @dt_i date --= '08/01/2013' 
	Declare @dt_f date --= '09/01/2013' 
    declare @SQL varchar(5000)
    
	Set @dt_i = convert(date,@mes + '/01/' + @ano )
	Set @dt_f = DATEADD(month,1,@dt_i)

    Set @SQL = '
	select c.cd_sequencial, a.nr_contrato, convert(varchar(10),f.Data_pagamento,103) as Dtpagamento, d1.nm_dependente as titular, d.nr_cpf_dep, d.nm_dependente, 
		   convert(varchar(10),c.dt_servico,103) as Dtservico , c.vl_pago_produtividade  , 
		   CONVERT(varchar(10),f.data_documento,103) as Dtconhecimento, d.cco 
	  from Pagamento_Dentista_Lancamento as pdl, pagamento_dentista as pd, Modelo_Pagamento_Prestador as mp , consultas as c, 
		   dependentes as d, TB_Lancamento as l , TB_FormaLancamento as f , associados as a, DEPENDENTES as d1 /* Titular*/
	where pdl.cd_modelo_pgto_prestador = mp.cd_modelo_pgto_prestador and 
		   pdl.cd_pgto_dentista_lanc = pd.cd_pgto_dentista_lanc and   
		   pdl.sequencial_lancamento = l.Sequencial_Lancamento and 
		   l.Sequencial_Lancamento =  f.Sequencial_Lancamento and 
		   pd.cd_sequencial = c.nr_numero_lote and 
		   c.cd_sequencial_dep = d.CD_SEQUENCIAL and
		   d.cd_associado = a.cd_associado and 
		   a.cd_associado = d1.CD_ASSOCIADO and d1.CD_GRAU_PARENTESCO=1 and 
		   mp.id_contabilizado =1 and '
	if @tipo = 1 
	   Set @SQL = @SQL + 'f.data_documento >= ''' + convert(varchar(10),@dt_i,101) + ''' and f.data_documento < ''' + convert(varchar(10),@dt_f,101) + '''' -- Conhecidos
	if @tipo = 2 
	   Set @SQL = @SQL + 'f.Data_pagamento >= ''' + convert(varchar(10),@dt_i,101) + ''' and f.Data_pagamento < ''' + convert(varchar(10),@dt_f,101) + '''' -- Pagos 

	Set @SQL = @SQL + '	order by c.cd_sequencial'

    print @sql 
    
    exec (@sql)
    
End 
