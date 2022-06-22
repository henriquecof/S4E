/****** Object:  Procedure [dbo].[PS_CriaLoteComissaoVendedor]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 10:04
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_CriaLoteComissaoVendedor (@Dia SMALLINT)
AS
BEGIN
  DECLARE @Funcionario INT
  DECLARE @data_inicial DATETIME
  DECLARE @data_final DATETIME
  DECLARE @dt DATETIME

  IF @Dia = 0
    SET @Dia = DAY(GETDATE())

  IF @Dia NOT IN (5, 20)
    RETURN

  IF @Dia = 5
  BEGIN
    SET @data_inicial = CONVERT(VARCHAR(2), MONTH(DATEADD(MONTH, -1, GETDATE()))) + '/01/' + CONVERT(VARCHAR(4), YEAR(DATEADD(MONTH, -1, GETDATE())))
    SET @data_final = CONVERT(VARCHAR(2), MONTH(DATEADD(MONTH, -1, GETDATE()))) + '/15/' + CONVERT(VARCHAR(4), YEAR(DATEADD(MONTH, -1, GETDATE()))) + ' 23:59'
  END

  IF @Dia = 20
  BEGIN
    SET @data_inicial = CONVERT(VARCHAR(2), MONTH(DATEADD(MONTH, -1, GETDATE()))) + '/16/' + CONVERT(VARCHAR(4), YEAR(DATEADD(MONTH, -1, GETDATE())))
    SET @data_final = DATEADD(DAY, -1, CONVERT(VARCHAR(2), MONTH(GETDATE())) + '/01/' + CONVERT(VARCHAR(4), YEAR(GETDATE())) + ' 23:59')
  END

  PRINT @Dia
  PRINT @data_inicial
  PRINT @data_final
  --   return 

  DECLARE cursor_lote_comissao CURSOR FOR SELECT
    f.cd_funcionario
   ,(SELECT
        l.dt_base_ini
      FROM lote_comissao AS l
      WHERE l.cd_funcionario = f.cd_funcionario
      AND l.dt_finalizado IS NULL
      AND l.cd_tipo IS NULL)
  FROM FUNCIONARIO AS f
  WHERE cd_cargo IN (SELECT
      cd_cargo
    FROM CARGO
    WHERE fl_geracomissao = 1)
  AND cd_situacao = 1

  OPEN cursor_lote_comissao
  FETCH NEXT FROM cursor_lote_comissao INTO @Funcionario, @dt

  WHILE (@@fetch_status <> -1)
  BEGIN
  SET @dt =
  CASE
    WHEN @dt IS NULL THEN @data_inicial
    ELSE @dt
  END

  EXEC PS_GeraLoteComissaoVendedor @Funcionario
                                  ,NULL
                                  ,@dt
                                  ,@data_final

  FETCH NEXT FROM cursor_lote_comissao INTO @Funcionario, @dt
  END
  CLOSE cursor_lote_comissao
  DEALLOCATE cursor_lote_comissao

END
