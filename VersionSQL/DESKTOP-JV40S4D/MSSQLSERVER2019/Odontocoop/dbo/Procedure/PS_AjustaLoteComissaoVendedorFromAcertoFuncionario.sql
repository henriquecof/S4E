/****** Object:  Procedure [dbo].[PS_AjustaLoteComissaoVendedorFromAcertoFuncionario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_AjustaLoteComissaoVendedorFromAcertoFuncionario
                 -- =============================================
                 -- Author:      henrique.almeida
                 -- Create date: 13/09/2021 11:25
                 -- Database:    S4ECLEAN
                 -- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
                 -- =============================================


                 @lote INT
AS
  BEGIN
    DECLARE @cd_funcionario INT

    SELECT @cd_funcionario = CD_FUNCIONARIO
    FROM lote_comissao
    WHERE cd_sequencial = @lote
    PRINT 'Funcionario'
    PRINT @cd_funcionario

    UPDATE dbo.acerto_comissao_vendedor
           SET cd_sequencial_lote_comissao = @lote
    WHERE data_exclusao IS NULL
           AND
           cd_sequencial_lote_comissao IS NULL
           AND
           cd_funcionario_vendedor = @cd_funcionario

  END
