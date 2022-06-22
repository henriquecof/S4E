/****** Object:  Procedure [dbo].[SP_BeneficiariosInativosANSAtivos_Listagem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_BeneficiariosInativosANSAtivos_Listagem] (@cd_centro_custo smallint)
As
Begin 

  Declare @sql varchar(max)
  
  Set @sql = ' 
	Select	T3.cd_associado as codigo, 
			T3.nm_completo as nm_titular, 
			T2.NM_DEPENDENTE as nm_usuario,
			T5.nm_plano as nm_plano,
			T6.ds_classificacao as ANS,
			T4.NM_FANTASIA as nm_empresa,
			convert(varchar(10),T2.dt_assinaturaContrato,103) as dt_assinaturaContrato, 
			convert(varchar(10),T2.DT_NASCIMENTO,103) as DT_NASCIMENTO, 
			T2.nr_cpf_dep as nr_cpf, 
			T2.nm_mae_dep as nm_mae,
			T1.cco , 
			T1.cd_arquivo_envio_inc
	from Ans_Beneficiarios T1
		join DEPENDENTES T2 on T1.cd_sequencial_dep = T2.CD_SEQUENCIAL
		join ASSOCIADOS T3 on T3.cd_associado = T2.CD_ASSOCIADO 
		join EMPRESA T4 on T3.CD_EMPRESA = T4.CD_EMPRESA
		join PLANOS T5 on T2.cd_plano = T5.cd_plano
		join CLASSIFICACAO_ANS T6 on T5.cd_classificacao = T6.cd_classificacao 
	where dt_exclusao is null
	and cd_sequencial_dep not in(
	Select d1.CD_SEQUENCIAL
	from associados as a 
		inner join dependentes as d1 on a.cd_Associado = d1.cd_Associado 
		inner join EMPRESA as e on a.cd_empresa=e.CD_EMPRESA
		inner join Centro_Custo as c on e.cd_centro_custo = c.cd_centro_custo
		inner join planos as p on  d1.cd_plano= p.cd_plano   
		inner join historico as h1 on d1.cd_sequencial_historico = h1.cd_sequencial 
		inner join situacao_historico as s1 on h1.cd_situacao = s1.cd_situacao_historico and s1.fl_incluir_ans=1 -- Usuario 
		inner join dependentes as d2 on d1.CD_ASSOCIADO = d2.cd_associado and d2.CD_GRAU_PARENTESCO = 1 
		inner join historico as h2 on d2.cd_sequencial_historico = h2.cd_sequencial 
		inner join situacao_historico as s2 on h2.cd_situacao = s2.cd_situacao_historico and s2.fl_incluir_ans=1  -- Titular
		inner join historico as h3 on e.CD_Sequencial_historico=h3.cd_sequencial 
		inner join situacao_historico as s3 on h3.CD_SITUACAO= s3.CD_SITUACAO_HISTORICO and s3.fl_incluir_ans=1 -- Empresa
		left join CLASSIFICACAO_ANS as cans on p.cd_classificacao = cans.cd_classificacao 
		left join Ans_Beneficiarios as b on d1.CD_SEQUENCIAL = b.cd_sequencial_dep and b.cd_sequencial_dep is not null and b.dt_exclusao is null 
	where -- d1.CD_GRAU_PARENTESCO = 1 and
	e.TP_EMPRESA<10 and 
	e.ufid is not null
	)
   '
		   if(@cd_centro_custo > -1)
		   begin
		   Set @sql += ' and T4.cd_centro_custo = ' + CONVERT(varchar(10),@cd_centro_custo)
		   end
		   Set @sql += ' order by T3.cd_associado, T2.CD_GRAU_PARENTESCO  '

print @sql 

   exec(@sql)		 
 
End
 	
