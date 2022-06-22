/****** Object:  Procedure [dbo].[SP_BeneficiariosAtivos_periodo]    Committed by VersionSQL https://www.versionsql.com ******/

create Procedure [dbo].[SP_BeneficiariosAtivos_periodo]
  @comp_base_i Date, -- = '09/01/2018'
  @comp_base_f Date , -- = '09/30/2018'
  @cd_centro_custo smallint = null,
  @cd_grupo int = null,
  @cd_plano int = null ,  
  @cd_empresa int = null,
  @traspInTipoEmpresa varchar(200) = null  
As
Begin 
 
 Declare @SQL varchar(max)

 Create table #Ativos (cd_centro_custo int, ds_centro_custo varchar(100), cd_grupo int, nm_grupo varchar(100), cd_empresa int, NM_FANTASIA varchar(100), cd_plano int, nm_plano varchar(200), inc int, exc int, total int , valor money)
 
 -- Incluir as empresas Ativas
 Set @SQL = '
 select e.cd_centro_custo , cc.ds_centro_custo , 
        e.cd_grupo , g.nm_grupo, 
        e.cd_empresa, e.NM_FANTASIA , 
        p.cd_plano, p.nm_plano, 
        sum(case when d.dt_assinaturaContrato >='''+convert(varchar(10),@comp_base_i,101)+''' and d.dt_assinaturaContrato<='''+convert(varchar(10),@comp_base_f,101)+' 23:59'' then 1 else 0 end) as Inc ,
        
        (select COUNT(0) 
           from HISTORICO as T1 inner join DEPENDENTES as T2 on t1.CD_SEQUENCIAL_dep = t2.CD_SEQUENCIAL 
                  inner join ASSOCIADOS as t3 on t2.CD_ASSOCIADO = t3.cd_associado
          where t1.CD_SITUACAO=2
            and t1.DT_SITUACAO>='''+convert(varchar(10),@comp_base_i,101)+''' 
            and t1.DT_SITUACAO<='''+convert(varchar(10),@comp_base_f,101)+' 23:59''
            and t3.cd_empresa = e.cd_empresa 
            and t2.cd_plano = p.cd_plano
            
        ) as Exc, 
        
        count(d.cd_sequencial) as Total , Sum(d.vl_plano) as Valor 
        
	 from DEPENDENTES as d 
	         inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_associado    
	         inner join EMPRESA as e on a.cd_empresa = e.CD_EMPRESA 
	         inner join PLANOS as p on d.cd_plano = p.cd_plano
	         inner join GRAU_PARENTESCO as gp on d.CD_GRAU_PARENTESCO = gp.cd_grau_parentesco 
		     inner join historico as h on d.cd_Sequencial_historico = h.cd_sequencial  -- dependentes 
		     inner join DEPENDENTES as d1 on d1.CD_ASSOCIADO = a.cd_associado and d1.CD_GRAU_PARENTESCO=1
		     inner join historico as h1 on d1.cd_Sequencial_historico = h1.cd_sequencial -- associados  
		     inner join historico as h2 on e.CD_Sequencial_historico = h2.cd_sequencial   
		      left join grupo as g on e.cd_grupo = g.cd_grupo 
		      left join Centro_Custo as cc on e.cd_centro_custo = cc.cd_centro_custo
	where d.dt_assinaturaContrato<='''+CONVERT(varchar(10),@comp_base_f,101)+' 23:59'''

	 if isnull(@traspInTipoEmpresa,'') <> '' 
		Set @SQL = @SQL + ' and e.TP_EMPRESA in ('+ @traspInTipoEmpresa +')'
	 else
		Set @SQL = @SQL + ' and e.TP_EMPRESA < 10'

	 Set @SQL = @SQL + ' and (select top 1 cd_situacao 
							from historico where cd_empresa = e.cd_empresa 
							 and dt_situacao <= '''+CONVERT(varchar(10),@comp_base_f,101)+' 23:59'' 
						   order by convert(date,dt_situacao) desc, cd_sequencial desc) in (select cd_situacao_historico from situacao_historico where fl_incluir_ans =1 ) 

	  and (select top 1 cd_situacao 
							from historico where cd_sequencial_dep = d.cd_sequencial 
							 and dt_situacao <= '''+CONVERT(varchar(10),@comp_base_f,101)+' 23:59''
						   order by convert(date,dt_situacao) desc, cd_sequencial desc) in (select cd_situacao_historico from situacao_historico where fl_incluir_ans =1 ) 
	  and (select top 1 cd_situacao 
							from historico where cd_sequencial_dep = d1.cd_sequencial 
							 and dt_situacao <= '''+CONVERT(varchar(10),@comp_base_f,101)+' 23:59''
						   order by convert(date,dt_situacao) desc, cd_sequencial desc) in (select cd_situacao_historico from situacao_historico where fl_incluir_ans =1 ) '
    
  if isnull(@cd_centro_custo,0)> 0 
     Set @SQL = @SQL + ' and e.cd_centro_custo = '+CONVERT(varchar(10),@cd_centro_custo)			
  if isnull(@cd_grupo,0)> 0 
     Set @SQL = @SQL + ' and e.cd_grupo = '+CONVERT(varchar(10),@cd_grupo)			 
  if isnull(@cd_plano,0)> 0 
     Set @SQL = @SQL + ' and p.cd_plano = '+CONVERT(varchar(10),@cd_plano)			 
  if isnull(@cd_empresa,0)> 0 
     Set @SQL = @SQL + ' and e.cd_empresa = '+CONVERT(varchar(10),@cd_empresa)			 

  Set @SQL = @SQL + '						   
	group by e.cd_centro_custo , cc.ds_centro_custo , 
			e.cd_grupo , g.nm_grupo, 
			e.cd_empresa, e.NM_FANTASIA , 
			p.cd_plano, p.nm_plano '

 print @SQL 
 
 exec('insert #Ativos(cd_centro_custo,ds_centro_custo, cd_grupo, nm_grupo, cd_empresa, NM_FANTASIA, cd_plano, nm_plano, inc, exc, total, valor) '+ @SQL)
 
-- Cancelados que tiveram a empresa e/ou plano cancelados por completo 
Set @SQL = ' 
 select e.cd_centro_custo,cc.ds_centro_custo, e.cd_grupo, g.nm_grupo, e.cd_empresa, e.NM_FANTASIA, p.cd_plano, p.nm_plano, 0, COUNT(0), 0, 0
           from HISTORICO as h inner join DEPENDENTES as d on h.CD_SEQUENCIAL_dep = d.CD_SEQUENCIAL 
                  inner join ASSOCIADOS as a on d.CD_ASSOCIADO = a.cd_associado
                  inner join empresa as e on a.cd_empresa = e.cd_empresa
		           left join grupo as g on e.cd_grupo = g.cd_grupo 
		           left join Centro_Custo as cc on e.cd_centro_custo = cc.cd_centro_custo
		          inner join PLANOS as p on d.cd_plano = p.cd_plano  
		  where h.CD_SITUACAO=2
            and h.DT_SITUACAO>='''+convert(varchar(10),@comp_base_i,101)+''' 
            and h.DT_SITUACAO<='''+convert(varchar(10),@comp_base_f,101)+' 23:59'' 
            and convert(varchar(10),e.cd_empresa)+''-''+convert(varchar(10),p.cd_plano) not in (select convert(varchar(10),cd_empresa)+''-''+convert(varchar(10),cd_plano) from #Ativos)
            '
  if isnull(@traspInTipoEmpresa,'') <> '' 
	Set @SQL = @SQL + ' and e.TP_EMPRESA in ('+ @traspInTipoEmpresa +')'
  else
	Set @SQL = @SQL + ' and e.TP_EMPRESA < 10'        
  if isnull(@cd_centro_custo,0)> 0 
     Set @SQL = @SQL + ' and e.cd_centro_custo = '+CONVERT(varchar(10),@cd_centro_custo)			
  if isnull(@cd_grupo,0)> 0 
     Set @SQL = @SQL + ' and e.cd_grupo = '+CONVERT(varchar(10),@cd_grupo)			 
  if isnull(@cd_plano,0)> 0 
     Set @SQL = @SQL + ' and p.cd_plano = '+CONVERT(varchar(10),@cd_plano)			 
  if isnull(@cd_empresa,0)> 0 
     Set @SQL = @SQL + ' and e.cd_empresa = '+CONVERT(varchar(10),@cd_empresa)			 
  
  Set @SQL = @SQL + '						   
	group by e.cd_centro_custo , cc.ds_centro_custo , 
			e.cd_grupo , g.nm_grupo, 
			e.cd_empresa, e.NM_FANTASIA , 
			p.cd_plano, p.nm_plano '
 
  print @SQL 

 exec('insert #Ativos(cd_centro_custo,ds_centro_custo, cd_grupo, nm_grupo, cd_empresa, NM_FANTASIA, cd_plano, nm_plano, inc, exc, total, valor) '+ @SQL)

 select * from #Ativos order by ds_centro_custo , nm_grupo, NM_FANTASIA , nm_plano  
         
End 
