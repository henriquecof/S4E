/****** Object:  Procedure [dbo].[SP_AnaliseCobranca_MensalidadeResumo]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_AnaliseCobranca_MensalidadeResumo]
AS
BEGIN
    RETURN;
    DECLARE @SQL VARCHAR(MAX);
    DECLARE @SQL_Associado VARCHAR(200);

    DECLARE @DataGeracao AS DATETIME;
    SET @DataGeracao = GETDATE() - 1;

    EXEC SP_AnaliseCobranca_Izzy 1, 0;

    -- Exclui parcelas virtual quando data de vencimento maior que data definida na configuração ou 7 dias.
    UPDATE
         MENSALIDADES
    SET
         CD_TIPO_RECEBIMENTO = 1,
         DT_BAIXA = GETDATE(),
         CD_USUARIO_BAIXA = (SELECT cd_funcionario FROM Processos WHERE cd_processo = 1)
    FROM MENSALIDADES T1
    WHERE
         T1.cd_tipo_parcela = 101
         AND T1.DT_VENCIMENTO < DATEADD(
                                           DAY,
                                           -ISNULL((SELECT TOP 1 qt_dias_expira_boletovirtual FROM Configuracao), 7),
                                           CONVERT(DATE, GETDATE())
                                       )
         AND CD_TIPO_RECEBIMENTO = 0; --ABERTA

    -- Processar mudancas de Situacoes

    IF NOT EXISTS
        (
            SELECT
                 *
            FROM sys.objects
            WHERE
                 object_id = OBJECT_ID(N'[dbo].[MensalidadeResumo]')
                 AND type IN ( N'U' )
        )
    BEGIN
        RAISERROR('Mensalidade Resumo não criada.', 16, 1);
        RETURN;
    END;

    IF  (SELECT COUNT(0)FROM MensalidadeResumo WHERE tipo IN ( 1, 2 )) = 0
    BEGIN
        RAISERROR('Mensalidade Resumo não povoada.', 16, 1);
        RETURN;
    END;


END;
