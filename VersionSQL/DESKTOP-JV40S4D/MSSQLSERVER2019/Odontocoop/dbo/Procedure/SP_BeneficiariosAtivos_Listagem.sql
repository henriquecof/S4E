/****** Object:  Procedure [dbo].[SP_BeneficiariosAtivos_Listagem]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE Procedure [dbo].[SP_BeneficiariosAtivos_Listagem]
(@cd_centro_custo smallint,
@CD_GRUPOAnalise int,
@depid int,
@cd_grupo int)
As
Begin 

  Declare @sql varchar(max)
  Declare @competencia varchar(6) = ''
  
  Select top 1 @competencia = competencia from ANS order by competencia desc
  
  Set @sql = 'SELECT
  (select distinct top 1 nm_grau_parentesco from grau_parentesco where cd_grau_parentesco = d1.cd_grau_parentesco ) as parentesco,
  (SELECT TOP 1 t200.nm_empregado
   FROM consultas t100,
        funcionario t200
   WHERE t200.cd_funcionario = t100.cd_funcionario
     AND t100.cd_sequencial_dep = d1.cd_sequencial
     AND t100.cd_servico = 86000357
   ORDER BY dt_servico DESC) AS nm_prestador,
       a.cd_associado AS Codigo,
       d2.NM_DEPENDENTE AS Titular,
       d1.NM_DEPENDENTE AS Usuário,
       p.nm_plano,
       cans.ds_classificacao,
       e.NM_FANTASIA,
       convert(varchar(10),d1.dt_assinaturaContrato,103) AS dt_assinaturaContrato,
       convert(varchar(10),d1.DT_NASCIMENTO,103) AS DT_NASCIMENTO,
       d1.nr_cpf_dep,
       d1.nm_mae_dep,
       Case when d1.cco is not null then ''''
            when b.cd_arquivo_envio_inc is not null and ans.dt_retorno is null then ''Em lote, aguardando retorno,''
            when convert(varchar(6),d1.dt_assinaturaContrato,112)>' + @competencia + ' then ''Competência ainda nao gerada,'' 
            else
			   CASE
				   WHEN
						  (SELECT COUNT(0)
						   FROM Ans_Beneficiarios AS b1
						   WHERE cd_sequencial_dep IS NOT NULL
							 AND dt_exclusao IS NULL
							 AND nr_cpf=d1.nr_cpf_dep
							 AND cd_sequencial_dep<>d1.CD_SEQUENCIAL) >0 THEN ''CPF ativo na ANS,''
				   ELSE ''''
			   END +
			   CASE WHEN p.cd_classificacao IS NULL THEN ''Classificação ANS não relacionada,''
					ELSE ''''
			   END + 
			   CASE WHEN (d1.CD_GRAU_PARENTESCO = 1
					  OR (d1.CD_GRAU_PARENTESCO > 1 AND dbo.FS_Idade(d1.dt_nascimento,GETDATE())>=18))
					  AND d1.nr_cpf_dep IS NULL THEN ''Cpf Obrigatorio,''
					ELSE ''''
			   END + 
			   CASE WHEN rtrim(isnull(d1.nm_mae_dep,''''))='''' THEN ''Nome da Mãe Obrigatorio,''
					ELSE ''''
			   end		
  
       END AS Motivo,
       d1.cco,
       b.cd_arquivo_envio_inc
FROM associados AS a
INNER JOIN dependentes AS d1 ON a.cd_Associado = d1.cd_Associado
INNER JOIN EMPRESA AS e ON a.cd_empresa=e.CD_EMPRESA
INNER JOIN Centro_Custo AS c ON e.cd_centro_custo = c.cd_centro_custo
INNER JOIN planos AS p ON d1.cd_plano= p.cd_plano
INNER JOIN historico AS h1 ON d1.cd_sequencial_historico = h1.cd_sequencial
INNER JOIN situacao_historico AS s1 ON h1.cd_situacao = s1.cd_situacao_historico
AND s1.fl_incluir_ans=1 -- Usuario

INNER JOIN dependentes AS d2 ON d1.CD_ASSOCIADO = d2.cd_associado
AND d2.CD_GRAU_PARENTESCO = 1
INNER JOIN historico AS h2 ON d2.cd_sequencial_historico = h2.cd_sequencial
INNER JOIN situacao_historico AS s2 ON h2.cd_situacao = s2.cd_situacao_historico
AND s2.fl_incluir_ans=1 -- Titular

INNER JOIN historico AS h3 ON e.CD_Sequencial_historico=h3.cd_sequencial
INNER JOIN situacao_historico AS s3 ON h3.CD_SITUACAO= s3.CD_SITUACAO_HISTORICO
AND s3.fl_incluir_ans=1 -- Empresa

LEFT JOIN CLASSIFICACAO_ANS AS cans ON p.cd_classificacao = cans.cd_classificacao
LEFT JOIN Ans_Beneficiarios AS b ON d1.CD_SEQUENCIAL = b.cd_sequencial_dep
AND b.cd_sequencial_dep IS NOT NULL
AND b.dt_exclusao IS NULL
left join ans on b.cd_arquivo_envio_inc = ans.cd_sequencial 
WHERE -- d1.CD_GRAU_PARENTESCO = 1 and
 e.TP_EMPRESA<10
  AND e.ufid IS NOT NULL '
		   
		   if (@cd_centro_custo > -1)
		   Set @sql = @sql+ ' and e.cd_centro_custo = ' + CONVERT(varchar(10),@cd_centro_custo) + ''
		   
		   if @CD_GRUPOAnalise > 0
			begin
				Set @sql += ' and e.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise = ' + CONVERT(varchar(10), @CD_GRUPOAnalise) + ')' 	 
			end 
			   
			if @depid > 0
			begin
				Set @sql += ' and e.cd_empresa in (select cd_empresa from Departamento_Empresa where depid = ' + CONVERT(varchar(10), @depid) + ')' 	 
			end    

			if @cd_grupo > 0
			begin
				Set @sql += ' and e.cd_grupo = ' + CONVERT(varchar(10), @cd_grupo) + '' 	 
			end 
		   
		 Set @sql = @sql+ 'order by a.cd_associado , d1.CD_GRAU_PARENTESCO '
   
   exec(@sql)
   print(@sql)		 
 
End
