/****** Object:  Procedure [dbo].[PS_BuscaPontoFunc]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_BuscaPontoFunc
                 -- =============================================
                 -- Author:      henrique.almeida
                 -- Create date: 13/09/2021 16:51
                 -- Database:    S4ECLEAN
                 -- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
                 -- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
                 -- =============================================


                 -- Add the parameters for the stored procedure here
                 @Funcionario INT ,
                 @DataIni SMALLDATETIME ,
                 @DataFinal SMALLDATETIME
AS
  BEGIN

    CREATE TABLE #Resultado (
               Nome                         VARCHAR(100) NOT NULL ,
               Data                         VARCHAR(10) ,
               Entrada                      VARCHAR(10) ,
               IP_Entrada                   VARCHAR(20) ,
               Saida_ALmoco                 VARCHAR(10) ,
               IP_Saida_ALmoco              VARCHAR(20) ,
               Entrada_Almoco               VARCHAR(10) ,
               IP_Entrada_Almoco            VARCHAR(20) ,
               Saida                        VARCHAR(10) ,
               IP_Saida                     VARCHAR(20) ,
               justificativa_Entrada        VARCHAR(50) ,
               justificativa_Saida_ALmoco   VARCHAR(50) ,
               justificativa_Entrada_Almoco VARCHAR(50) ,
               justificativa_Saida          VARCHAR(50) ,
               cd_sequencial                INT ,
               IdsObs                       VARCHAR(300) ,
               QtdeImagemUpload             INT ,
               obs                          INT
             );


    WHILE (@DataIni <= @DataFinal)
      BEGIN

        INSERT INTO #Resultado (Nome , Data , Entrada , IP_Entrada , Saida_ALmoco , IP_Saida_ALmoco , Entrada_Almoco , IP_Entrada_Almoco , Saida , IP_Saida , justificativa_Entrada , justificativa_Saida_ALmoco , justificativa_Entrada_Almoco , justificativa_Saida , cd_sequencial , IdsObs , QtdeImagemUpload , obs)
               SELECT F.nm_empregado , CONVERT(VARCHAR(10) , @DataIni , 103) AS Data , (SELECT TOP 1 CONVERT(VARCHAR(10) , T1.data_ponto , 108) AS data_ponto FROM Funcionario_BatePonto T1 WHERE T1.cd_funcionario = F.cd_funcionario AND T1.periodo = 1 AND T1.data_ponto <= @DataIni + ' 23:59:59' AND T1.data_ponto >= @DataIni + ' 00:00:00' AND T1.fl_excluido IS NULL) Entrada , (SELECT TOP 1 T1.ip_maquina_ponto FROM Funcionario_BatePonto T1 WHERE T1.cd_funcionario = F.cd_funcionario AND T1.periodo = 1 AND T1.data_ponto <= @DataIni + ' 23:59:59' AND T1.data_ponto >= @DataIni + ' 00:00:00' AND T1.fl_excluido IS NULL) IP_Entrada , (SELECT TOP 1 CONVERT(VARCHAR(10) , T2.data_ponto , 108) AS data_ponto FROM Funcionario_BatePonto T2 WHERE T2.cd_funcionario = F.cd_funcionario AND T2.periodo = 2 AND T2.data_ponto <= @DataIni + ' 23:59:59' AND T2.data_ponto >= @DataIni + ' 00:00:00' AND T2.fl_excluido IS NULL) Saida_ALmoco , (SELECT TOP 1 T2.ip_maquina_ponto FROM Funcionario_BatePonto T2 WHERE T2.cd_funcionario = F.cd_funcionario AND T2.periodo = 2 AND T2.data_ponto <= @DataIni + ' 23:59:59' AND T2.data_ponto >= @DataIni + ' 00:00:00' AND T2.fl_excluido IS NULL) IP_Saida_ALmoco , (SELECT TOP 1 CONVERT(VARCHAR(10) , T3.data_ponto , 108) AS data_ponto FROM Funcionario_BatePonto T3 WHERE T3.cd_funcionario = F.cd_funcionario AND T3.periodo = 3 AND T3.data_ponto <= @DataIni + ' 23:59:59' AND T3.data_ponto >= @DataIni + ' 00:00:00' AND T3.fl_excluido IS NULL) Entrada_Almoco , (SELECT TOP 1 T3.ip_maquina_ponto FROM Funcionario_BatePonto T3 WHERE T3.cd_funcionario = F.cd_funcionario AND T3.periodo = 3 AND T3.data_ponto <= @DataIni + ' 23:59:59' AND T3.data_ponto >= @DataIni + ' 00:00:00' AND T3.fl_excluido IS NULL) IP_Entrada_Almoco , (SELECT TOP 1 CONVERT(VARCHAR(10) , T4.data_ponto , 108) AS data_ponto FROM Funcionario_BatePonto T4 WHERE T4.cd_funcionario = F.cd_funcionario AND T4.periodo = 4 AND T4.data_ponto <= @DataIni + ' 23:59:59' AND T4.data_ponto >= @DataIni + ' 00:00:00' AND T4.fl_excluido IS NULL) Saida , (SELECT TOP 1 T4.ip_maquina_ponto FROM Funcionario_BatePonto T4 WHERE T4.cd_funcionario = F.cd_funcionario AND T4.periodo = 4 AND T4.data_ponto <= @DataIni + ' 23:59:59' AND T4.data_ponto >= @DataIni + ' 00:00:00' AND T4.fl_excluido IS NULL) IP_Saida , (SELECT TOP 1 T5.justificativa FROM Funcionario_BatePonto T5 WHERE T5.cd_funcionario = F.cd_funcionario AND T5.periodo = 1 AND T5.data_ponto <= @DataIni + ' 23:59:59' AND T5.data_ponto >= @DataIni + ' 00:00:00' AND T5.fl_excluido IS NULL) justificativa_Entrada , (SELECT TOP 1 T6.justificativa FROM Funcionario_BatePonto T6 WHERE T6.cd_funcionario = F.cd_funcionario AND T6.periodo = 2 AND T6.data_ponto <= @DataIni + ' 23:59:59' AND T6.data_ponto >= @DataIni + ' 00:00:00' AND T6.fl_excluido IS NULL) justificativa_Saida_ALmoco , (SELECT TOP 1 T7.justificativa FROM Funcionario_BatePonto T7 WHERE T7.cd_funcionario = F.cd_funcionario AND T7.periodo = 3 AND T7.data_ponto <= @DataIni + ' 23:59:59' AND T7.data_ponto >= @DataIni + ' 00:00:00' AND T7.fl_excluido IS NULL) justificativa_Entrada_Almoco , (SELECT TOP 1 T8.justificativa FROM Funcionario_BatePonto T8 WHERE T8.cd_funcionario = F.cd_funcionario AND T8.periodo = 4 AND T8.data_ponto <= @DataIni + ' 23:59:59' AND T8.data_ponto >= @DataIni + ' 00:00:00' AND T8.fl_excluido IS NULL) justificativa_Saida , (SELECT MAX(T4.cd_sequencial) FROM Funcionario_BatePonto T4 WHERE T4.cd_funcionario = F.cd_funcionario AND T4.data_ponto <= @DataIni + ' 23:59:59' AND T4.data_ponto >= @DataIni + ' 00:00:00' AND T4.fl_excluido IS NULL) cd_sequencial , (SELECT REPLACE(SUBSTRING((SELECT DISTINCT '_ ' + CONVERT(VARCHAR(10) , T4.cd_sequencial) AS 'data()' FROM Funcionario_BatePonto T4 WHERE T4.cd_funcionario = F.cd_funcionario AND T4.data_ponto <= @DataIni + ' 23:59:59' AND T4.data_ponto >= @DataIni + ' 00:00:00' AND T4.fl_excluido IS NULL AND T4.obs IS NOT NULL FOR XML PATH ('')) , 2 , 1000) , ' ' , '')) IdsOBS , (SELECT COUNT(0) FROM ArquivoPonto ap WHERE ap.cd_sequencial = (SELECT MAX(T4.cd_sequencial) FROM Funcionario_BatePonto T4 WHERE T4.cd_funcionario = F.cd_funcionario AND T4.data_ponto <= @DataIni + ' 23:59:59' AND T4.data_ponto >= @DataIni + ' 00:00:00' AND T4.fl_excluido IS NULL) AND ap.arpDtExclusao IS NULL) QtdeImagemUpload , (SELECT COUNT(0) FROM Funcionario_BatePonto T9 WHERE T9.cd_funcionario = F.cd_funcionario AND T9.data_ponto <= @DataIni + ' 23:59:59' AND T9.data_ponto >= @DataIni + ' 00:00:00' AND T9.fl_excluido IS NULL AND T9.obs IS NOT NULL) obs
               FROM FUNCIONARIO F
               WHERE F.cd_funcionario = @Funcionario

        SET @DataIni = DATEADD(DAY , 1 , @DataIni)

        CONTINUE;
      --IF @intFlag = 4 -- This will never executed
      --BREAK;
      END

    SELECT Nome , Data , Entrada , IP_Entrada , Saida_ALmoco , IP_Saida_ALmoco , Entrada_Almoco , IP_Entrada_Almoco , Saida , IP_Saida , justificativa_Entrada , justificativa_Saida_ALmoco , justificativa_Entrada_Almoco , justificativa_Saida , cd_sequencial , IdsObs , QtdeImagemUpload , obs
    FROM #Resultado

  END
