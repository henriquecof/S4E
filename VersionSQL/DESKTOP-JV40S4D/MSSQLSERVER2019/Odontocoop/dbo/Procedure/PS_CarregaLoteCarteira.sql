/****** Object:  Procedure [dbo].[PS_CarregaLoteCarteira]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_CarregaLoteCarteira] (
		-- Add the parameters for the stored procedure here
		@sq_lote INT,
		@centro_custo INT,
		@tipo_empresa INT,
		@cd_plano INT,
		@transpinempresa VARCHAR(500),
		@transpnotinempresa VARCHAR(500),
		@dt_adesaoini VARCHAR(10),
		@dt_adesaofin VARCHAR(10),
		@dt_cadastroini VARCHAR(10),
		@dt_cadastrofin VARCHAR(10),
		@fl_regeralote SMALLINT,
		@transpingrupo VARCHAR(500),
		@transpinfuncionario VARCHAR(500),
		@transpincd_grupo VARCHAR(500),
		@transincontrato VARCHAR(500))
AS
BEGIN
	BEGIN TRANSACTION

	DECLARE @sql VARCHAR(MAX)
	DECLARE @tipolote INT
	DECLARE @licensas4e VARCHAR(50)
	DECLARE @layoutcarteira VARCHAR(50)

	SELECT TOP 1
		@licensas4e = LicencaS4E
	FROM dbo.Configuracao

	SELECT
		@tipolote = ISNULL(Tp_empresa, 0)
	FROM dbo.Lotes_Carteiras
	WHERE SQ_Lote = @sq_lote

	--Lotes Separados por Layout  
	SELECT
		@layoutcarteira = end_LayoutCarteira
	FROM dbo.Lotes_Carteiras
	WHERE SQ_Lote = @sq_lote

	SET @sql = ''

	---Inicia o insert  
	SET @sql = 'INSERT INTO Carteiras (sq_lote, cd_sequencial_dep, cd_Associado, dt_exclusao, Cod_Carteira ) '
	+ ' select distinct top 140000 '
	+ CONVERT(VARCHAR(10), @sq_lote)
	+ ', T1.cd_sequencial, T1.CD_ASSOCIADO, NULL, T1.nr_carteira '
	+ ' FROM   
		   DEPENDENTES AS T1 INNER JOIN PLANOS AS T2 ON T1.cd_plano = T2.cd_plano
		   INNER JOIN ASSOCIADOS AS T3 ON T1.cd_associado = T3.cd_associado
		   INNER JOIN EMPRESA AS T4 ON T3.CD_EMPRESA = T4.CD_EMPRESA
		   INNER JOIN lote_contratos_contratos_vendedor AS T5 ON T1.CD_SEQUENCIAL = T5.cd_sequencial_dep
		   LEFT OUTER JOIN Departamento AS T6 ON T3.depId = T6.depId
		   LEFT OUTER JOIN DEPENDENTES AS TT1 ON T3.CD_ASSOCIADO = TT1.CD_ASSOCIADO
		   INNER JOIN HISTORICO AS T7 ON T7.cd_sequencial = (select top 1 cd_sequencial from historico where cd_sequencial_dep = T1.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc)
		   INNER JOIN HISTORICO AS T8 ON T8.CD_SEQUENCIAL = (select top 1 cd_sequencial from historico where cd_sequencial_dep = TT1.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc)
		   INNER JOIN HISTORICO AS T9 ON T9.CD_SEQUENCIAL = (select top 1 cd_sequencial from historico where cd_empresa = T4.cd_empresa order by convert(date,dt_situacao) desc, cd_sequencial desc) '
	+
	--' from dependentes as T1, dependentes TT1, planos T2, associados T3, empresa T4, lote_contratos_contratos_vendedor t5, Departamento t6, HISTORICO T7, HISTORICO t8, HISTORICO t9' +
	' where 1=1 '
	+
	--Historico da empresa 
	--'       and T9.cd_sequencial = (select top 1 cd_sequencial from historico where cd_empresa = T4.cd_empresa order by convert(date,dt_situacao) desc, cd_sequencial desc)' + -- INNER JOIN
	--Historico do Titular 
	--'       and T8.cd_sequencial = (select top 1 cd_sequencial from historico where cd_sequencial_dep = TT1.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc)' + -- INNER JOIN
	'		and TT1.cd_grau_parentesco = 1 '
	+
	--'		and t3.cd_associado *= tt1.cd_associado' + -- LEFT OUTER JOIN 
	--Historico do dependente 
	--'       and T7.cd_sequencial = (select top 1 cd_sequencial from historico where cd_sequencial_dep = T1.cd_sequencial order by convert(date,dt_situacao) desc, cd_sequencial desc)' + -- INNER JOIN
	--Situacao real de cada dependente
	'  and dbo.FS_RetornaSituacao(t9.cd_situacao,t8.cd_situacao,t7.cd_situacao) in (select cd_situacao_historico from situacao_historico where fl_gera_carteira = 1)'
	+
	--joins
	--'  and T1.cd_plano = T2.cd_plano ' + -- INNER JOIN
	--'  and T1.cd_associado = T3.cd_associado ' + -- INNER JOIN
	--'  and T3.cd_empresa = T4.cd_empresa ' + -- INNER JOIN
	'  AND (t4.fl_gera_carteira = 1	
	or ( t4.fl_gera_carteira = 2 and 
	(select count(0) from mensalidades m, mensalidades_planos mp where mp.cd_parcela_mensalidade = m.cd_parcela and mp.cd_sequencial_dep = T1.CD_SEQUENCIAL and m.CD_TIPO_RECEBIMENTO > 2 ) > 0)
		) ' + '  and T4.TP_empresa < 10 '

	--'  and t1.cd_sequencial = t5.cd_sequencial_dep ' + -- INNER JOIN
	--'  and t3.depid *= t6.depid ' -- LEFT OUTER JOIN 

	---Regera Lote  
	IF ISNULL(@fl_regeralote, 0) = 0
	BEGIN
		SET @sql = @sql + ' and T1.CD_SEQUENCIAL not in (select T2.cd_Sequencial_Dep from Carteiras T2 where T2.dt_exclusao is null) '
		SET @sql = @sql + ' and (select top 1 isnull(fl_gera_carteira,1) from situacao_historico sh where t7.cd_situacao = sh.cd_situacao_historico) = 1 '
	END
	ELSE
	BEGIN
		SET @sql = @sql + ' and (select top 1 isnull(fl_gera_carteira,1) from situacao_historico sh where t7.cd_situacao = sh.cd_situacao_historico) = 1 '
	END

	--Grupo de Faturamento  
	IF @transpingrupo <> ''
	BEGIN
		SET @sql = @sql + ' and t3.depid in (' + @transpingrupo + ')'
	END

	--Grupo de empresa 
	IF @transpincd_grupo <> ''
	BEGIN
		SET @sql = @sql + ' and t4.cd_grupo in (' + @transpincd_grupo + ')'
	END

	IF @licensas4e = 'QJSH717634HGSD981276SDSCVJHSD8721365SAAUS7A615002'
		OR @licensas4e = 'AJGFGFUYHURHTRJHFGJDGHJDVJIUGIRFHGIFHHSDUGDSUY017'
		OR @licensas4e = 'UHGFIYUFGJVBBGJGDUFTYEFEHJFHDFDFDGYTSDSUIUTRYF018'
	BEGIN ---Inicio Licença  
		IF @tipolote = 0
		BEGIN
			IF ISNULL(@tipo_empresa, 0) > 0
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (' + CONVERT(VARCHAR(5), @tipo_empresa) + ') '
			END
		END
		ELSE
		IF @tipolote = 2
		BEGIN
			IF ISNULL(@tipo_empresa, 0) > 0
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (' + CONVERT(VARCHAR(5), @tipo_empresa) + ') '
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (2,8,7) '
			END
		END
		ELSE
		IF @tipolote = 3
		BEGIN
			IF ISNULL(@tipo_empresa, 0) > 0
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (' + CONVERT(VARCHAR(5), @tipo_empresa) + ') '
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (3) '
			END
		END
		ELSE
		IF @tipolote = 4
		BEGIN
			IF ISNULL(@tipo_empresa, 0) > 0
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (' + CONVERT(VARCHAR(5), @tipo_empresa) + ') '
			END
			ELSE
			BEGIN
				SET @sql = @sql + ' and T4.TP_empresa in (1,4,5) '
			END
		END
	END
	ELSE
	BEGIN --Else da Licença  
		PRINT 'else'

		IF ISNULL(@tipo_empresa, 0) > 0
		BEGIN
			SET @sql = @sql + ' and T4.TP_empresa in (' + CONVERT(VARCHAR(5), @tipo_empresa) + ') '
		END
	END

	-- Fim da Licença  

	---LayoutCarteira  
	IF @layoutcarteira <> ''
	BEGIN
		SET @sql = @sql + ' and T2.end_LayoutCarteira = ''' + @layoutcarteira + ''''
	END

	---Centro de custo  
	IF ISNULL(@centro_custo, 0) > 0
	BEGIN
		SET @sql = @sql + ' and t4.cd_centro_custo = ' + CONVERT(VARCHAR(10), @centro_custo) + ''
	END

	--Grupo de Empresas  
	IF ISNULL(@transpinempresa, '') <> ''
		OR ISNULL(@transincontrato, '') <> ''
	BEGIN
		SET @sql = @sql + ' and (t4.cd_empresa in ('
		+ ISNULL(@transpinempresa, 'NULL')
		+ ') or t3.nr_contrato in (select distinct nr_contrato from ASSOCIADOS where nr_contrato in ('
		+ ISNULL(@transincontrato, 'NULL') + ')))'
	END

	--Exceto Grupo de Empresas  
	IF @transpnotinempresa <> ''
	BEGIN
		SET @sql = @sql + ' and t4.cd_empresa not in (' + @transpnotinempresa + ')'
	END

	IF @transpinfuncionario <> ''
	BEGIN
		SET @sql = @sql + ' and t1.cd_funcionario_vendedor in (' + @transpinfuncionario + ')'
	END

	IF @dt_adesaoini <> ''
		AND @dt_adesaofin <> ''
	BEGIN
		SET @sql = @sql + ' and t1.dt_assinaturaContrato >= ''' + @dt_adesaoini + ''' and t1.dt_assinaturaContrato <= ''' + @dt_adesaofin + ''''
	END

	IF @dt_cadastroini <> ''
		AND @dt_cadastrofin <> ''
	BEGIN
		SET @sql = @sql + ' and t5.dt_cadastro >= ''' + @dt_cadastroini + ''' and t5.dt_cadastro <= ''' + @dt_cadastrofin + ''''
	END

	---PLANO  
	IF ISNULL(@cd_plano, 0) > 0
	BEGIN
		SET @sql = @sql + ' and t2.cd_plano = ' + CONVERT(VARCHAR(10), @cd_plano) + ''
	END

	PRINT @sql

	EXEC (@sql)

	COMMIT TRANSACTION
END
