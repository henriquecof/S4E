/****** Object:  Procedure [dbo].[SP_VariacaoFaturamento]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_VariacaoFaturamento]   
  @dt datetime,  
  @dia_vencimento smallint = 0,  
  @cd_centro_custo smallint,  
  @cd_grupo smallint = 0,
  @CD_GRUPOAnalise int = 0 
As  
Begin   

DECLARE @sql varchar(max)
SET @sql =  ' SELECT distinct '
SET @sql += ' a.cd_empresa cd_associado , '
SET @sql += ' ufSigla , '   
SET @sql += ' nm_tipo_pagamento, '     
SET @sql += ' a.NM_FANTASIA nm_responsavel, '  
       
 -- preço titular  
SET @sql += ' dbo.moeda((select top 1 vl_tit from preco_plano as pp , planos as p where pp.cd_empresa = a.cd_empresa and pp.cd_plano = p.cd_plano and p.fl_exige_dentista = 0 and p.fl_cortesia = 0 and pp.dt_fim_comercializacao is null order by 1 )) as p_tit,  '
   
 --preço dependente  
SET @sql += ' dbo.moeda((select top 1 vl_dep from preco_plano as pp , planos as p where pp.cd_empresa = a.cd_empresa and pp.cd_plano = p.cd_plano and p.fl_exige_dentista = 0 and p.fl_cortesia = 0 and pp.dt_fim_comercializacao is null order by 1 )) as p_dep,  '    
   
 -- quantidade titular  
SET @sql += ' (select count(0) from associados as a1 , dependentes as d1, historico as h1 , situacao_historico as s1 '  
SET @sql += ' where a1.cd_empresa = a.cd_empresa and '     
SET @sql += ' a1.cd_Associado = d1.cd_Associado and d1.cd_grau_parentesco = 1 and '     
SET @sql += ' d1.cd_sequencial_historico = h1.cd_sequencial and '     
SET @sql += ' h1.cd_situacao = s1.cd_situacao_historico and '     
SET @sql += ' s1.fl_incluir_ans=1) as qt_tit, '     
   
 -- quantidade dependente  
SET @sql += ' (select count(0) '     
SET @sql += ' from associados as a1 , '     
SET @sql += ' dependentes as d1 , historico as h1, situacao_historico as s1, '     
SET @sql += ' dependentes as d2 , historico as h2 , situacao_historico as s2 '    
SET @sql += ' where a1.cd_empresa = a.cd_empresa and '     
SET @sql += ' a1.cd_associado = d1.cd_Associado and d1.cd_grau_parentesco >= 1 and '     
SET @sql += ' d1.cd_sequencial_historico = h1.cd_sequencial and '     
SET @sql += ' h1.cd_situacao = s1.cd_situacao_historico and '     
SET @sql += ' s1.fl_incluir_ans=1 and '     
SET @sql += ' a1.cd_associado = d2.cd_Associado and d2.cd_grau_parentesco = 1 and '     
SET @sql += ' d2.cd_sequencial_historico = h2.cd_sequencial and '     
SET @sql += ' h2.cd_situacao = s2.cd_situacao_historico and '     
SET @sql += ' s2.fl_incluir_ans=1 and '     
SET @sql += ' d1.CD_SEQUENCIAL <> d2.cd_Sequencial) as qt_dep , '     
   
 --valor da parcela atual  
SET @sql += ' convert(varchar(10),m.dt_vencimento,103) dt_vencimento, dbo.moeda(sum(m.vl_parcela)) as vl_parcela ,  '     

 -- valor da parcela mês anterior  
SET @sql += ' dbo.moeda((select sum(vl_parcela) from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),@dt,126) +''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-1,@dt),126) +''' and '     
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc '
SET @sql += ' )) as vl_parcela_anterior ,'    

 -- Crescimento da Fatura (variação)   
SET @sql += ' dbo.moeda(sum(m.vl_parcela) - isnull((select isnull(sum(vl_parcela),0) from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-10,@dt),126)+''' and        
              m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-11,@dt),126)+''' and  '         
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc),0)) as variacao , '    
SET @sql += ' ),0)) as variacao , '    

 -- valor parcela anterior 2 meses atrás  
SET @sql += ' dbo.moeda((select sum(vl_parcela) from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-1,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-2,@dt),126) + ''' and '     
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc'
SET @sql += ' )) as vl_parcela_anterior_2, ' -- 2   
   
 -- valor parcela anterior 3 meses atrás  
SET @sql += ' dbo.moeda((select sum(vl_parcela) from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-2,@dt),126) + ''' and '    
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-3,@dt),126) + ''' and '   
SET @sql += '  m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_3, ' -- 3   
SET @sql += ' )) as vl_parcela_anterior_3, ' -- 3   
    
 -- valor parcela anterior 4 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-3,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-4,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_4, '-- 4      
SET @sql += ' )) as vl_parcela_anterior_4, '-- 4      
    
 -- valor parcela anterior 5 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-4,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-5,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_5, '-- 5      
SET @sql += ' )) as vl_parcela_anterior_5, '-- 5      
   
 -- valor parcela anterior 06 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-5,@dt),126) + ''' and '  
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-6,@dt),126) + ''' and '    
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_6, ' -- 06    
SET @sql += ' )) as vl_parcela_anterior_6, ' -- 06    
   
 -- valor parcela anterior 07 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-6,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-7,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_7, ' -- 07      
SET @sql += ' )) as vl_parcela_anterior_7, ' -- 07      
   
 -- valor parcela anterior 08 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-7,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-8,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_8, ' -- 8      
SET @sql += ' )) as vl_parcela_anterior_8, ' -- 8      
   
 -- valor parcela anterior 09 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-8,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-9,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_9, '-- 9      
SET @sql += ' )) as vl_parcela_anterior_9, '-- 9      
   
 -- valor parcela anterior 10 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '     
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-9,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-10,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_10, '-- 10      
SET @sql += ' )) as vl_parcela_anterior_10, '-- 10      
   
 -- valor parcela anterior 11 meses atrás  
SET @sql += ' dbo.moeda((select top 1 vl_parcela from mensalidades m2 '     
SET @sql += ' where a.cd_empresa = m2.cd_associado_empresa and '    
SET @sql += ' m2.tp_associado_empresa=2 and m2.dt_vencimento<'''+ CONVERT(varchar(10),dateadd(month,-10,@dt),126) + ''' and '     
SET @sql += ' m2.dt_vencimento>='''+ CONVERT(varchar(10),dateadd(month,-11,@dt),126) + ''' and ' 
SET @sql += ' m2.cd_tipo_parcela=1 and m2.cd_tipo_recebimento not in (1,2) '    
--SET @sql += ' order by m2.dt_vencimento desc)) as vl_parcela_anterior_11 '--11  
SET @sql += ' )) as vl_parcela_anterior_11 '--11  
  
SET @sql += ' from empresa as a '
SET @sql += ' join mensalidades as m on m.cd_associado_empresa = a.cd_empresa '
SET @sql += ' join tipo_pagamento as tp on m.cd_tipo_pagamento = tp.cd_tipo_pagamento ' 
SET @sql += ' join uf on a.ufid = uf.ufID ' 	
SET @sql += ' where m.dt_vencimento >= '''+ CONVERT(varchar(10),@dt,126) +''' and '   
SET @sql += ' m.dt_vencimento <'''+ CONVERT(varchar(10),dateadd(month,1,@dt),126) +''' and ' 
 
  if @dia_vencimento > 0
	begin
		Set @sql += ' datepart(day, m.dt_vencimento) = ' + CONVERT(varchar(5), @dia_vencimento) + ' and ' 
	  --datepart(day, m.dt_vencimento) = (case when @dia_vencimento > 0 then @dia_vencimento else datepart(day, m.dt_vencimento) end) and
	end 
	 
SET @sql += ' m.tp_associado_empresa=2 and m.cd_tipo_recebimento not in (1,2) and m.cd_tipo_parcela=1 and '     
SET @sql += ' a.cd_centro_Custo = ''' + CONVERT(varchar(5), @cd_centro_custo) + ''' and m.vl_parcela > 0 ' 
 
 if @cd_grupo > 0
	begin
		Set @sql += ' and a.cd_grupo = ' + CONVERT(varchar(10), @cd_grupo) + ' ' 
	  --isnull(a.cd_grupo, 0) = (case when @cd_grupo > 0 then @cd_grupo else isnull(a.cd_grupo, 0) end)
	end   
	
	if @CD_GRUPOAnalise > 0
	begin
		Set @sql += ' and a.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise = ' + CONVERT(varchar(10), @CD_GRUPOAnalise) + ')' 	 
	end 	   	
	                      
SET @sql += ' group by a.cd_empresa ,  ufSigla ,  nm_tipo_pagamento,  a.NM_FANTASIA , m.dt_vencimento 
              order by 2,3,16 desc '

print (@sql) 
exec (@sql)

End   
