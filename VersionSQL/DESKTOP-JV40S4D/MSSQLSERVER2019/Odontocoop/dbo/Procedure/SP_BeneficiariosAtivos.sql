/****** Object:  Procedure [dbo].[SP_BeneficiariosAtivos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_BeneficiariosAtivos] @cd_centro_custo SMALLINT,
	@cd_@dept INT,
	@cd_grupo INT,
	@cd_grupoAnalise INT,
	@tipo int=-1,
	@perfilVendedor int = -1,
	@cd_equipe varchar(max)='',
	@cd_funcionario_vendedor int=-1
AS
BEGIN
/*
	Ticket 9186: Ajuste para permitir a busca sem informar o centro de custo
	Ticket 24334: Ajustado o relatório USUÁRIOS ATIVOS X CENTRO DE CUSTO X EMPRESA para o perfil corretor conforme orientações para PRIMAVIDA
*/
	DECLARE @cc VARCHAR(10) = convert(VARCHAR(10), @cd_centro_custo)
	DECLARE @dept VARCHAR(10) = convert(VARCHAR(10), @cd_@dept)
	DECLARE @grupo VARCHAR(10) = convert(VARCHAR(10), @cd_grupo)
	DECLARE @grupoAnalise VARCHAR(10) = convert(VARCHAR(10), @cd_grupoAnalise)
	DECLARE @sql VARCHAR(max)

	SET @sql = 
		'  
    select a.cd_empresa cd_associado, a.NM_FANTASIA nm_responsavel, e.ds_empresa, a.dt_vencimento, ufSigla, nm_tipo_pagamento, sh.NM_SITUACAO_HISTORICO, isnull(ua.qt_tit,0) as qt_tit, isnull(ua.qt_dep,0) as qt_dep,isnull(ua.qt_agregado,0) AS qt_agregado, 
   
    isnull(ua.valorParticipacaoEmpresaTitular,0) as valorParticipacaoEmpresaTitular ,  
    isnull(ua.valorParticipacaoEmpresaDependente,0) as valorParticipacaoEmpresaDependente ,  
    isnull(ua.valorParticipacaoEmpresaAgregado,0) as valorParticipacaoEmpresaAgregado,   
    isnull(ua.qt_cadastro_ok_ans,0) as qt_cadastrocompleto,   
    isnull(a.qt_funcionarios,0) as qt_funcionarios,   
    convert(varchar(10),a.DT_FECHAMENTO_CONTRATO,103) DT_FECHAMENTO_CONTRATO, a.dia_inicio_cobertura, mu.NM_MUNICIPIO,  
      
    (SELECT COUNT(0)  
          FROM MENSALIDADES T1  
          WHERE CD_ASSOCIADO_empresa = a.CD_EMPRESA  
          AND T1.CD_TIPO_RECEBIMENTO = 0  
          AND CASE  
          WHEN dbo.FS_ContaDiasUteisVencimento(isnull(T1.dt_vencimento_new,T1.DT_VENCIMENTO),isnull(T1.dt_pagamento,getdate())) > 0  
          THEN dbo.FS_ContaDiasUteisVencimento(isnull(T1.dt_vencimento_new,T1.DT_VENCIMENTO),getdate())  
          ELSE 0  
          END > 0 ) as QtdeParcelasAtraso,tt2.NOME_TIPO,a.endcomplemento,tt3.baidescricao,dbo.fs_retornacontato(a.cd_empresa,3,1) telefones,dbo.fs_retornacontato(a.cd_empresa,3,2) ''E-mail'' , isnull(ua.vl_plano,0) vl_plano, isnull(a.qt_funcionarios, 0) as qt_vida  
      
    from empresa as a '

	IF @dept > - 1
	BEGIN
		SET @sql += 'INNER JOIN Departamento_Empresa as dept on a.cd_empresa = dept.cd_empresa'
	END

	SET @sql += ' left join GrupoAnalise_Empresa t4 on a.CD_EMPRESA = t4.CD_EMPRESA  
         left join GrupoAnalise t5 on t4.CD_GRUPOAnalise = t5.CD_GRUPOAnalise  
         inner join TB_tipologradouro tt2 on a.chave_tipologradouro = tt2.chave_tipologradouro  
         inner join bairro tt3 on a.baiid = tt3.baiid   
    left join (select * from dbo.VW_UsuariosAtivos) as ua on a.CD_EMPRESA=ua.cd_empresa, tipo_pagamento as tp, uf, tipo_empresa as e, HISTORICO as h, SITUACAO_HISTORICO as sh, MUNICIPIO as mu  
    where a.cd_tipo_pagamento = tp.cd_tipo_pagamento  
    and a.ufid = uf.ufID  
    and a.TP_EMPRESA = e.tp_empresa  
    and a.CD_Sequencial_historico = h.cd_sequencial  
    and h.CD_SITUACAO = sh.CD_SITUACAO_HISTORICO  
    and mu.cd_municipio = a.cd_municipio  
    and sh.fl_incluir_ans = 1  
    and a.TP_EMPRESA <> 10'

	IF @cc > - 1
	BEGIN
		SET @sql += 'and a.cd_centro_Custo = ' + @cc + ' '
	END

	IF @dept > - 1
	BEGIN
		SET @sql += 'AND dept.depId = ' + @dept + ' '
	END

	IF @cd_grupo > - 1
	BEGIN
		SET @sql += 'and a.cd_grupo = ' + @grupo + ' '
	END

	IF @cd_grupoAnalise > - 1
	BEGIN
		SET @sql += 'and t5.CD_GRUPOAnalise = ' + @grupoAnalise + ' '
	END

	If @cd_equipe <> '' and @perfilVendedor = 2
	begin
		set @sql += ' and (select count(0) 
						from funcionario tt1 
						inner join equipe_vendas tt2 on tt2.cd_equipe = tt1.cd_equipe 
						where tt1.cd_funcionario = a.cd_func_vendedor and tt2.cd_equipe in (' + @cd_equipe + ') )> 0 '
    End 

    If @cd_funcionario_vendedor > -1 and @perfilVendedor in (3,4)
	begin
        set @sql += ' and  a.cd_func_vendedor = ' + convert(varchar,@cd_funcionario_vendedor)
    End 

	SET @sql += ' order by 2,3'

	PRINT @sql

	EXEC (@sql)
END
select top 1 * from empresa
