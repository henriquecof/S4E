/****** Object:  Procedure [dbo].[PS_Cancelados]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 17:02
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DE PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_Cancelados (
                 @cd_equipe INT ,
                 @data1 VARCHAR(30) ,
                 @data2 VARCHAR(30) ,
                 @cc INT ,
                 @cd_vendedor INT = 0 ,
                 @supervisor INT = 0 ,
                 @cpfvendedor VARCHAR(11) = '' ,
                 @empresa INT = 0 ,
                 @func_cancelamento BIGINT = 0 ,
                 @motivos VARCHAR(50) = '' ,
                 @somente_titulares TINYINT = 0 ,
                 @situacao VARCHAR(50) = '' ,
                 @grupoAnalise INT = NULL ,
                 @depId INT = NULL ,
                 @cd_grupo INT = NULL ,
                 @uf INT = NULL ,
                 @municipio INT = NULL ,
                 @planos VARCHAR(100) = NULL ,
                 @tipoEmpresa VARCHAR(100) = NULL ,
                 @tipoPagamento VARCHAR(100) = NULL ,
                 @listCentroC VARCHAR(MAX) = NULL ,
                 @tipoRecebimento VARCHAR(1000) = ''
)
AS
  BEGIN

    DECLARE @sql VARCHAR(MAX)
    SET @sql = 'SELECT t1700.nm_situacao_historico AS situacao,
 		   T1000.nm_empregado adesionista,
 		   T300.DT_SITUACAO,
 		   T100.nm_dependente,
 		   T200.NM_Empregado,
 		   T400.CD_Associado,
 		   T400.nm_completo,
 		   t500.nm_plano,
 		   t100.vl_plano,
 		   convert(varchar(10),T300.DT_SITUACAO,103) AS DATA,
 		   t600.nm_fantasia,
 		   t700.nm_motivo_cancelamento,
 		   convert(varchar(10),t100.dt_assinaturaContrato, 103) AS dt_assinaturaContrato,
 		   dbo.FS_RetornaContato(t100.CD_SEQUENCIAL,5,1) AS contato,
 		   T100.cd_funcionario_dentista,
 		   t800.nm_empregado AS dentista,
 		   CONVERT(varchar(10),T300.dt_situacao,103) AS dt_sit,
 		   t300.nm_comentario,
 		   t900.NM_Empregado AS nm_FuncHistorico,
 		   T100.cd_sequencial AS cd_sequencial_dep,
 		   isnull(T300.cd_empresaDependente,t600.cd_empresa) as cd_empresaDependente,
 		   isnull(T1100.NM_RAZSOC,t600..NM_RAZSOC) as NM_RAZSOC,
 		   T400.EndLogradouro,
 		   T400.EndNumero,
 		   T400.EndComplemento,
 		   T1200.baidescricao,
 		   T1300.nm_municipio,
 		   T1400.ufsigla,
 		   T1500.nome_tipo,
 		   t1600.nm_grau_parentesco,
 		   T100.nr_contrato,
 		   
 		   dbo.FS_RetornaContato(T400.CD_Associado, 1, 2) as email_associado,
		   t600.cd_tipo_pagamento,
		   T600.cd_centro_custo,
 		   
 		   Convert(varchar (10),t100.DT_NASCIMENTO,103) AS DT_NASCIMENTO,
 dbo.FS_Idade(t100.DT_NASCIMENTO,NULL) AS idade,
 CASE
     WHEN T100.fl_sexo = 0 THEN ''Feminino''
     WHEN T100.fl_sexo = 1 THEN ''Masculino''
                                                 END AS sexo,
 
   dep.depDescricao,
 
 (SELECT count(distinct cd_parcela_mensalidade)
 		   FROM Dependentes T1,
 				mensalidades_planos T2,
 				mensalidades T3
 		   WHERE T1.CD_SEQUENCIAL = T2.cd_sequencial_dep
 			 AND T3.CD_PARCELA = T2.cd_parcela_mensalidade
 			 and T2.dt_exclusao is null
 			 AND T3.CD_TIPO_RECEBIMENTO > 2
 			 AND T1.CD_SEQUENCIAL = t100.CD_SEQUENCIAL
 		   GROUP BY T1.CD_SEQUENCIAL,
 					t1.NM_DEPENDENTE) AS parcela_paga
 					
 			,(select SUM(T2.valor) 
 				from 
 				Dependentes T1,
 				mensalidades_planos T2,
 				mensalidades T3 
 				where T1.CD_SEQUENCIAL = T2.cd_sequencial_dep
 				and T3.CD_PARCELA = T2.cd_parcela_mensalidade
 				and T2.dt_exclusao is null
 				and T3.CD_TIPO_RECEBIMENTO > 2
 				and T1.CD_SEQUENCIAL = t100.CD_SEQUENCIAL
 				group by T1.CD_SEQUENCIAL,t1.NM_DEPENDENTE) as valor_parcela_paga,
 				T200.nm_empregado as corretor,
 				datediff(month,T100.dt_assinaturaContrato, 
				T300.DT_SITUACAO) mesesPermanencia,
 				t600.tp_empresa, 
				dbo.FS_RetornaContato(T400.CD_Associado, 1, 2) as EmailTitular, 
				T300.chaId, 
				t600.cd_empresa, 

	            isnull( (select isnull(sum((isnull(cm.valor,0) * (isnull(cm.perc_pagamento,0)/100))),0) 
					from comissao_vendedor cm inner join lote_comissao lc on cm.cd_sequencial_lote = lc.cd_sequencial
					        inner join TB_FormaLancamento fl on lc.cd_sequencial_caixa = fl.sequencial_lancamento
					where cm.dt_exclusao is null 
					  and lc.dt_finalizado is not null
					  and lc.cd_sequencial_caixa is not null
					  and fl.data_pagamento is not null
					  and cm.cd_sequencial_dependente = t100.cd_sequencial),0) as valor_comissao, 

 				 isnull((select sum(isnull(T5.vl_pago_produtividade,0)+isnull(t5.vl_acerto_pgto_produtividade,0)) as valorInformado
						 from  Consultas T5
						 where  T5.dt_servico is not null
						   and T5.dt_cancelamento is null
						   and (T5.vl_pago_produtividade>0)
						   and t5.status in (3,6,7)
						   and t5.cd_sequencial_dep = t100.cd_sequencial),0) as eventos_conhecidos, 

 				(select isnull(sum(isnull(m.vl_pago,0)),0) 
				   from mensalidades_planos mp inner join mensalidades m on mp.cd_parcela_mensalidade = m.cd_parcela 
				  where mp.dt_exclusao is null 
				    and m.cd_tipo_recebimento not in (1,2) 
					and mp.cd_sequencial_dep = t100.cd_sequencial) as valor_total_pago
	   
 	FROM Dependentes T100 inner join Funcionario T200 on T100.cd_funcionario_vendedor = T200.cd_funcionario
 		    inner join Historico T300 on t100.CD_Sequencial_historico = t300.cd_sequencial   
 		    inner join Associados T400 on T100.cd_associado = T400.cd_associado  
			 left join Departamento dep on t400.depid = dep.depid
			inner join Planos T500 on T100.cd_plano = T500.cd_plano 
 		    inner join EMPRESA t600 on t400.cd_empresa = t600.CD_EMPRESA  
 		     left join MOTIVO_CANCELAMENTO t700 on T300.cd_MOTIVO_CANCELAMENTO = t700.cd_motivo_cancelamento  
 		     left join funcionario t800 on T100.cd_funcionario_dentista = t800.cd_funcionario ' + CASE
                                                                                                          WHEN @func_cancelamento > 0
                                                                                                          THEN 'inner '
                                                                                                          ELSE 'left '
                                                                                             END + 'join funcionario t900 on T300.cd_usuario = T900.cd_funcionario
 		     left join Funcionario t1000 on T100.cd_funcionario_adesionista = T1000.cd_funcionario
			 left join Empresa T1100 on T300.cd_empresaDependente = T1100.cd_empresa  
			 left join Bairro T1200 on T400.baiid =  T1200.baiid  
			 left join Municipio T1300 on T400.cidid = T1300.cd_municipio   
			 left join Uf T1400 on T400.ufid = T1400.ufid
			 left join TB_TIPOLOGRADOURO T1500 on T400.chave_tipologradouro = T1500.chave_tipologradouro
			inner join grau_parentesco t1600 on T100.cd_grau_parentesco = T1600.cd_grau_parentesco 
			 left join situacao_historico t1700 on T300.cd_situacao = t1700.cd_situacao_historico '

    SET @sql = @sql + ' WHERE t600.tp_empresa < 10 '

    IF @cpfvendedor <> ''
      SET @sql = @sql + ' And T200.nr_cpf = ''' + @cpfVendedor + ''' '

    IF @cd_equipe > 0
      SET @sql = @sql + ' And T200.cd_equipe = ' + CONVERT(VARCHAR(10) , @cd_equipe)

    IF @supervisor > 0
      SET @sql = @sql + ' And T200.cd_equipe in ( Select cd_equipe From equipe_vendas  where cd_equipe is not null  and (CD_CHEFE = ' + CONVERT(VARCHAR(10) , @supervisor) + '  or CD_CHEFE1 = ' + CONVERT(VARCHAR(10) , @supervisor) + ' or CD_CHEFE2 = ' + CONVERT(VARCHAR(10) , @supervisor) + ')) '

    IF @cd_vendedor > 0
      SET @sql = @sql + ' And T200.cd_funcionario = ' + CONVERT(VARCHAR(10) , @cd_vendedor)

    IF @cc > 0
      SET @sql = @sql + ' and T600.cd_centro_custo = ' + CONVERT(VARCHAR(10) , @cc)

    IF @empresa > 0
      SET @sql = @sql + ' and T400.cd_empresa = ' + CONVERT(VARCHAR(10) , @empresa)

    IF ISNULL(@listCentroC , '') <> ''
      SET @sql = @sql + ' and T600.cd_centro_custo in ( ' + @listCentroC + ' )'

    IF @func_cancelamento > 0
      SET @sql = @sql + ' And t900.cd_funcionario = ' + CONVERT(VARCHAR(20) , @func_cancelamento)

    IF @motivos <> ''
      SET @sql = @sql + ' And T300.cd_MOTIVO_CANCELAMENTO in (' + CONVERT(VARCHAR(50) , @motivos) + ')'

    IF @somente_titulares > 0
      SET @sql = @sql + ' and T100.cd_grau_parentesco = 1'

    IF @situacao <> ''
      SET @sql = @sql + ' and t300.cd_situacao in (' + CONVERT(VARCHAR(50) , @situacao) + ')'
    ELSE
      SET @sql = @sql + ' and t300.cd_situacao in (2)'

    IF @grupoAnalise > -1
      BEGIN
        SET @sql = @sql + ' and t400.cd_empresa in (select cd_empresa from GrupoAnalise_Empresa where CD_GRUPOAnalise = ' + CONVERT(VARCHAR(10) , @grupoAnalise) + ')'
      END

    IF @depId > -1
      BEGIN
        SET @sql = @sql + ' and t400.cd_empresa in (select cd_empresa from Departamento_Empresa where depid = ' + CONVERT(VARCHAR(10) , @depId) + ')'
      END

    IF @cd_grupo > -1
      BEGIN
        SET @sql = @sql + ' and t600.cd_grupo = ' + CONVERT(VARCHAR(10) , @cd_grupo) + ''
      END

    IF @uf > -1
      BEGIN
        SET @sql = @sql + ' and T400.ufid in (' + CONVERT(VARCHAR(10) , @uf) + ') '
      END

    IF @municipio > -1
      BEGIN
        SET @sql = @sql + ' and T400.cidid in (' + CONVERT(VARCHAR(10) , @municipio) + ') '
      END

    IF @planos <> ''
      BEGIN
        SET @sql = @sql + ' and T100.cd_plano  in (' + CONVERT(VARCHAR(10) , @planos) + ') '
      END

    IF @tipoEmpresa <> ''
      BEGIN
        SET @sql = @sql + ' and t600.tp_empresa  in (' + CONVERT(VARCHAR(10) , @tipoEmpresa) + ') '
      END

    IF @tipoPagamento <> ''
      BEGIN
        SET @sql = @sql + ' and t600.cd_tipo_pagamento  in (' + CONVERT(VARCHAR(10) , @tipoPagamento) + ') '
      END

    IF (@tipoRecebimento <> '')
      BEGIN
        SET @sql = @sql + 'and (select count(0)                                 
						from mensalidades_planos t1000,                     
								mensalidades t2000                             
						where t1000.cd_sequencial_dep = T100.cd_sequencial
						and t2000.cd_parcela = t1000.cd_parcela_mensalidade 
						and t2000.cd_tipo_recebimento in (' + @tipoRecebimento + ') 
						) > 0 '
      END

    SET @sql = @sql + ' And T300.DT_SITUACAO between ''' + @data1 + ''' and ''' + @data2 + ''' 
order by t100.cd_Associado, t100.cd_grau_parentesco, t100.cd_sequencial'

    EXEC (@sql)
    PRINT @sql


  END
