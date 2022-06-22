/****** Object:  Procedure [dbo].[SP_SIP_Detalhes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_SIP_Detalhes]
	@trimestre smallint, -- Valores de 1 a 4 
	@ano smallint, 
	@tp_empresa smallint=0, -- 1-Ind, 2-Col Emp, 3-Col Ades
	@cd_uf int = 0
	, @IdConvenio int =-1 
as 
Begin
  
   Declare @qtde_repeticao smallint = 3
   Declare @qtde_curr smallint = 1 
   Declare @dt_ref datetime
   Set @dt_ref = convert(datetime,convert(varchar(2),(((@trimestre-1)*3)+1))+'/01/'+CONVERT(varchar(4),@ano))
   print @dt_ref 

    Declare @sql varchar(8000)
    Declare @qtde_eventos int 
    
    Create table #tmpSIP (cd_categoria_ans int, cd_sequencial_consulta int) 
    
    -- Responder as perguntas que NÃO sao agrupadas 
    Declare @cd_categoria_ans smallint, @padrao_idade smallint, @ud_inicial smallint, @ud_final smallint, @peso smallint 

    DECLARE cursor_gera_sip CURSOR FOR 
     select cd_categoria_ans , padrao_idade, ud_inicial, ud_final ,isnull(peso,1)
       from Categoria_Ans
      where cd_codigo_ans is null or len(cd_codigo_ans)=0
      order by cd_categoria_ans desc
	   OPEN cursor_gera_sip  
	  FETCH NEXT FROM cursor_gera_sip INTO @cd_categoria_ans , @padrao_idade, @ud_inicial, @ud_final ,@peso
   	  WHILE (@@FETCH_STATUS <> -1)  
	  begin  -- 2.2   

	     set @sql = 'insert #tmpSIP (cd_categoria_ans,cd_sequencial_consulta) 
	        Select ' + convert(varchar(10),@cd_categoria_ans) + ', t3.cd_sequencial 
              from categoriaANS_Servico as T2, Consultas as T3, DEPENDENTES as T4,
                   PLANOS as p, CLASSIFICACAO_ANS as CANS ,
                   SERVICO T5, associados as t1, 
                   pagamento_dentista as pg , Modelo_Pagamento_Prestador as mpp , Pagamento_Dentista_Lancamento as pdl
	         where t2.cd_categoria_ans = ' + convert(varchar(10),@cd_categoria_ans) + ' and
	               t2.cd_servico = t5.cd_servicoANS and
	               t5.cd_servico = t3.cd_servico  and 
	               t3.cd_sequencial_dep = t4.cd_sequencial and 
	               t4.cd_associado = t1.cd_associado and 
	               t4.cd_plano = p.cd_plano and 
	               p.cd_classificacao = CANS.cd_classificacao and
	               CANS.idconvenio is null and 
	               t3.nr_numero_lote is not null and 
                   T3.nr_numero_lote = pg.cd_sequencial and
                   pg.cd_modelo_pgto_prestador = mpp.cd_modelo_pgto_prestador and 
                   pg.cd_pgto_dentista_lanc = pdl.cd_pgto_dentista_lanc  
                   
	              -- and t3.status in (3,6,7)  
	              
				   and T3.dt_servico is not null
				   and T3.dt_cancelamento is null
				   and (T3.vl_pago_produtividade>0 or T3.vl_glosa>0)	              
	              
	              
	               and pdl.dt_conhecimento >= ''' + convert(varchar(10),@dt_ref,101) + '''  
	               and pdl.dt_conhecimento < DATEADD(month,3,''' + convert(varchar(10),@dt_ref,101) + ''')  
	               
	         --      and t3.dt_servico >= ''' + convert(varchar(10),@dt_ref,101) + '''  
	          --     and t3.dt_servico < DATEADD(month,3,''' + convert(varchar(10),@dt_ref,101) + ''')  
	                and t3.cd_sequencial not in (select cd_sequencial_consulta from #tmpSIP)
                   '
	    if  @cd_uf > 0 -- Maior ou igual a 12 anos 
	        set @sql = @sql + ' and t1.ufid= ' + convert(varchar(10),@cd_uf)  

	    if  @tp_empresa > 0 -- Maior ou igual a 12 anos 
	        set @sql = @sql + ' and cans.tp_empresa= ' + convert(varchar(10),@tp_empresa)  
	        
	    if  @padrao_idade = 1 -- Maior ou igual a 12 anos 
	        set @sql = @sql + ' and dbo.FS_Idade(t4.dt_nascimento,t3.dt_servico)>=12 ' 

	    if  @padrao_idade = 2 -- Menor de 12 anos
	        set @sql = @sql + ' and dbo.FS_Idade(t4.dt_nascimento,t3.dt_servico)<12 '    
	  
	    if @ud_inicial is not null 
	       set @sql = @sql + ' and t3.cd_ud >= ' + convert(varchar(2),@ud_inicial) + '
	                           and t3.cd_ud <= ' + convert(varchar(2),@ud_final)
	     
	    print @sql     
	    exec(@sql)

 
        FETCH NEXT FROM cursor_gera_sip INTO @cd_categoria_ans , @padrao_idade, @ud_inicial, @ud_final , @peso
      End    
      close cursor_gera_sip
      Deallocate cursor_gera_sip	    
      
      --  Select t5.cd_servicoANS, t5.nm_servico, convert(varchar(10),t3.dt_servico,103) as dt, t4.cd_associado , t4.nm_dependente
      
      select uf.ufSigla ,  m.nm_municipio , f.nm_filial ,
             t4.nr_carteira, t4.nm_dependente, t4.nr_cpf_dep,case when T4.fl_sexo = 0 then 'F' else 'M' end as sexo,
             dbo.FS_Idade(t4.dt_nascimento,t3.dt_servico) as Idade,
      
             tp.ds_empresa, CANS.cd_ans, CANS.ds_classificacao, t2.nm_categoria_ans, t3.nr_gto, t5.cd_servico, t5.nm_servico, 
             convert(varchar(10),t3.dt_servico ,103) as dataservico,
             isnull(t3.vl_Pago_produtividade,0)+isnull(t3.vl_acerto_pgto_produtividade,0) as vl_Pago_produtividade, isnull(t3.vl_glosa,0) as vl_glosa
             
             
FROM            DEPENDENTES AS T4 INNER JOIN
                         Consultas AS T3 ON T4.CD_SEQUENCIAL = T3.cd_sequencial_dep INNER JOIN
                         SERVICO AS T5 ON T3.cd_servico = T5.CD_SERVICO INNER JOIN
                         ASSOCIADOS AS t1 ON T4.CD_ASSOCIADO = t1.cd_associado INNER JOIN
                         PLANOS AS p ON T4.cd_plano = p.cd_plano INNER JOIN
                         CLASSIFICACAO_ANS AS CANS ON p.cd_classificacao = CANS.cd_classificacao INNER JOIN
                         TIPO_EMPRESA AS tp ON CANS.tp_empresa = tp.tp_empresa INNER JOIN
                         FILIAL AS f ON T3.cd_filial = f.cd_filial LEFT OUTER JOIN
                         MUNICIPIO AS m ON f.CidID = m.CD_MUNICIPIO INNER JOIN
                         UF ON f.ufId = UF.ufId CROSS JOIN
                         [#tmpSIP] CROSS JOIN
                         Categoria_Ans AS T2
WHERE        ([#tmpSIP].cd_sequencial_consulta = T3.cd_sequencial) AND ([#tmpSIP].cd_categoria_ans = T2.cd_categoria_ans)
ORDER BY f.nm_filial, T3.dt_servico
             
      drop table #tmpSIP
 
End 
