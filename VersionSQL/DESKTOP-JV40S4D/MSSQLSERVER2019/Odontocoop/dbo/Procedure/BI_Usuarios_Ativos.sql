/****** Object:  Procedure [dbo].[BI_Usuarios_Ativos]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[BI_Usuarios_Ativos] (
	@dt DATETIME = '01/01/1900',
	@ortodontia SMALLINT = 0
)
AS


/*
Data e Hora.: 2022-05-24 14:02:41
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
QUERY ANTIGA DEIXADA COMENTADA.
*/


  /*
  
  ESSA PROCEDURE SETA DUAS VARIAVEIS @DT DO TIPO DATETIME = '01/01/1900' E A VARIAVEL @ORTODONTIA DO TIPO SMALLINT = 0
  
  ESSA PROCEDURE REALIZA LIMPEZA NA TABELA PREVSYSTEMBI..USUARIOSATIVOS.
  APÓS ISSO SÃO DECLARADAS 4 VARIAVEIS.:
  @QT INTEGER
  @QT1 INTEGER
  @QT2 INTEGER
  @COMP VARCHAR(6)
  
  NA VARIAVEL @DT É REALIZADO UMA VERIFICADO NO INICIO DA CONDIÇÃO IF, PARA CASO FOR NULO OU IGUAL A DATA DE 01/01/1900, É SETADO A DATA COM BASE NA EXPRESSÃO
  DATEADD --OBS.: FOI RODADO SOMENTE A EXPRESSÃO E VISTO QUE PEGA O ANO ANTERIOR, O MÊS ATUAL INICIANDO NO DIA PRIMEIRO.
  
  ENQUANTO TIVER NA CONDIÇÃO, NO WHILE É VERIFICADO SE @DT<DATEADD(MONTH,1,GETDATE()), É REALIZADO A INSERÇÃO DENTRO DA TABELA.:
  PREVSYSTEMBI..USUARIOSATIVOS
  
  */ BEGIN

		DELETE PrevsystemBI..UsuariosAtivos -- Limpar a tabela

		DECLARE @qt INTEGER
		DECLARE @qt1 INTEGER
		DECLARE @qt2 INTEGER
		DECLARE @comp VARCHAR(6)

		IF @dt IS NULL
		OR @dt = '01/01/1900' SET @dt = DATEADD(YEAR , -1 , CONVERT(DATETIME , CONVERT(VARCHAR(2) , MONTH(GETDATE())) + '/01/' + CONVERT(VARCHAR(4) , YEAR(GETDATE()))))


		WHILE @dt < DATEADD(MONTH , 1 , GETDATE())
		BEGIN
			PRINT @dt

			--SELECT
			--         	@qt = ISNULL(COUNT(0) , 0)
			--         FROM PrevsystemBI..HistoricoResumo AS h,
			--         	DEPENDENTES AS d,
			--         	ASSOCIADOS AS a,
			--         	empresa AS e
			--         WHERE h.cd_sequencial_dep = d.cd_sequencial
			--         AND d.cd_associado = a.cd_associado
			--         AND a.cd_empresa = e.cd_empresa
			--         AND e.TP_EMPRESA < 10
			--         AND d.cd_plano IN (SELECT
			--                            	cd_plano
			--                            FROM PLANOS
			--                            WHERE fl_exige_dentista = @ortodontia
			--         )
			--         AND h.dt_inclusao < @dt
			--         AND ( h.dt_exclusao IS NULL
			--         OR h.dt_exclusao >= @dt )

			SELECT
            	@qt = ISNULL(COUNT(0) , 0)
            FROM ASSOCIADOS AS a
            	INNER JOIN DEPENDENTES AS d ON a.cd_associado = d.CD_ASSOCIADO
            	INNER JOIN EMPRESA AS e ON a.cd_empresa = e.CD_EMPRESA
            	CROSS JOIN PrevsystemBI.dbo.HistoricoResumo AS h
            WHERE (h.cd_sequencial_dep = d.CD_SEQUENCIAL)
            AND (e.TP_EMPRESA < 10)
            AND d.cd_plano IN
            (SELECT
             	cd_plano
             FROM PLANOS
             WHERE fl_exige_dentista = @ortodontia )
            AND h.dt_inclusao < @dt
            AND ( h.dt_exclusao IS NULL
            OR h.dt_exclusao >= @dt )

			INSERT PrevsystemBI..UsuariosAtivos ( ano,
			                                      mes,
			                                      qtde )
			VALUES ( YEAR(DATEADD(DAY , -1 , @dt)),
			         MONTH(DATEADD(DAY , -1 , @dt)),
			         @qt )

			SET @dt = DATEADD(MONTH , 1 , @dt)

		END

		SELECT
        	ano ,
        	mes ,
        	qtde AS dt
        FROM PrevsystemBI..UsuariosAtivos
        ORDER BY ano,
                 mes

	END
