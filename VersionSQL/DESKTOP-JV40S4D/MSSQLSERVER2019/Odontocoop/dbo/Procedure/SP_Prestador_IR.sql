/****** Object:  Procedure [dbo].[SP_Prestador_IR]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_Prestador_IR] (@ano varchar(4), @tipo int, @codigo int , @centro_custo varchar(100)='')
as 
Begin
    -- @tipo = 1: Clínica, 2: Dentista

	Declare @SQL varchar(max)
	Declare @dt_i date = '01/01/'+@ano
	Declare @dt_f date = '01/01/'+(convert(varchar(4),convert(int,@ano)+1))

    Set @SQL = '
    select x.pf_pj, x.codigoCNPJ_CPF, x.nome, x.month, sum(x.Total) Total, 
	sum(x.c1708) c1708, sum(x.c5952) c5952, sum(x.c5960) c5960, sum(x.c5979) c5979, 
	sum(x.c5987) c5987, sum(x.cInss) cInss
	from (
	select distinct case when T1.cd_filial IS not null and T4.nr_cgc IS not null then ''PJ''
				when T1.cd_filial IS not null and T4.nr_cgc IS null then ''PF''
				when t6.nr_cnpj is not null then ''PF''
				else ''PF'' end as pf_pj,
	       case when T1.cd_filial IS not null and T4.nr_cgc IS not null then T4.nr_cgc
				when T1.cd_filial IS not null and T4.nr_cgc IS null then T41.nr_cpf
				when t6.nr_cnpj is not null then t6.nr_cnpj
				else t6.nr_cpf end as codigoCNPJ_CPF,
		   case when T1.cd_filial IS not null and T4.nr_cgc IS not null then t4.nm_filial
		        when T1.cd_filial IS not null and T4.nr_cgc IS null then T41.nm_empregado
		        else t6.nm_empregado end as nome,
		   month(case when t2.dt_pagamento is not null then t2.dt_pagamento else f.Data_pagamento end) as month,
		   t1.vl_bruto as Total,
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota = 4)) as c1708, -- IRPJ e IRPF
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota in (1,2,6))) as c5952, -- PIS, COFINS e CSLL
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota = 1)) as c5960, -- COFINS
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota = 6)) as c5979, -- PIS
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota = 2)) as c5987, -- CSLL
			(select isnull(sum(valor_aliquota),0) from Pagamento_Dentista_Aliquotas where cd_pgto_dentista_lanc = T1.cd_pgto_dentista_lanc and dt_exclusao is null and id_retido = 1 and cd_aliquota in (select cd_aliquota from aliquota where cd_grupo_aliquota = 3)) as cInss -- INSS
	  from Pagamento_Dentista_Lancamento T1 
				inner join pagamento_dentista T2 on T1.cd_pgto_dentista_lanc = T2.cd_pgto_dentista_lanc
				inner join Filial T4 on T2.cd_filial = T4.cd_filial
				left  join FUNCIONARIO T41 on  T4.cd_funcionario_responsavel = T41.cd_funcionario 
				inner join FUNCIONARIO T6 on T2.cd_funcionario = T6.cd_funcionario -- Funcionario da Pagamento Dentista
				left  join TB_FormaLancamento as f on T1.sequencial_lancamento = f.Sequencial_Lancamento
	 where '

	   Set @SQL = @SQL + '(
	         (T2.dt_pagamento >= '''+convert(varchar(10),@dt_i,101)+''' and T2.dt_pagamento < '''+convert(varchar(10),@dt_f,101)+''' ) or 
	         (f.Data_pagamento >= '''+convert(varchar(10),@dt_i,101)+'''  and f.Data_pagamento < '''+convert(varchar(10),@dt_f,101)+''' ) 
	       ) '

     Set @SQL = @SQL + ' and t1.' + case when @tipo=1 then 'cd_filial' else 'cd_funcionario' end + ' = ' + CONVERT(varchar(10),@codigo)
        
     --if @centro_custo <> ''
     --   Set @SQL = @SQL + ' and  T1.cd_centro_custo in (' + @centro_custo + ')'
             
	 Set @SQL = @SQL + ' and isnull(t2.exibir,1) = 1
	 group by T1.cd_filial, T4.nr_cgc, T41.nr_cpf, t6.nr_cpf, t4.nm_filial, t6.nm_empregado, t2.dt_pagamento, f.Data_pagamento, t6.nr_cnpj, t41.nm_empregado, T1.cd_pgto_dentista_lanc, t1.vl_bruto
	  ) as x
	 group by x.pf_pj, x.codigoCNPJ_CPF, x.nome, x.month 
	 order by x.month
	 '
	 
     --print @SQL 
     exec (@SQL)
End
