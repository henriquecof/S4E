/****** Object:  Procedure [dbo].[PS_Fecha_Crm_15dias]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_Fecha_Crm_15dias]
AS
BEGIN

    DECLARE @tempCRM TABLE
    (
        chaid [INT] NOT NULL
    );

    BEGIN TRANSACTION;

    INSERT INTO @tempCRM
    SELECT T1.chaId
    FROM dbo.CRMChamado T1
        INNER JOIN dbo.CRMChamadoOcorrencia T2
            ON T1.chaId = T2.chaId
    WHERE T1.sitId = 2
          AND
          (
              SELECT COUNT(0)
              FROM dbo.CRMChamadoOcorrencia T3
              WHERE T3.chaId = T1.chaId
                    AND T3.cocDtCadastro >= DATEADD(DAY, -15, GETDATE())
          ) = 0
          AND T1.chaDtFechamento IS NULL;


    UPDATE dbo.CRMChamado
    SET sitId = 3,
        chaDtFechamento = GETDATE()
    WHERE chaId IN
          (
              SELECT chaid FROM @tempCRM
          );


    INSERT INTO dbo.CRMChamadoOcorrencia
    SELECT T1.chaid,
           'Chamado fechado por falta de interação',
           GETDATE(),
           1,
           7021,
           NULL,
           NULL,
           NULL
    FROM @tempCRM T1;

    COMMIT TRANSACTION;
END;
