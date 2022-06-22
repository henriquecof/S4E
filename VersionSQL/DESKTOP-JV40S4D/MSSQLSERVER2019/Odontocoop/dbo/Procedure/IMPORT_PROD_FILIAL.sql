/****** Object:  Procedure [dbo].[IMPORT_PROD_FILIAL]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:48
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



CREATE PROCEDURE dbo.IMPORT_PROD_FILIAL
                 @FIL_OR AS SMALLINT ,
                 @FIL_DEST AS SMALLINT
AS
  DECLARE @cd_servico AS INTEGER ,
  @vl_pago_produtividade AS MONEY ,
  @vl_pago_produtividade_cred AS MONEY

  BEGIN

      BEGIN TRANSACTION
      DELETE FROM PRODUTIVIDADE_FILIAL
      WHERE cd_filial = @FIL_DEST
      DECLARE cursor_a CURSOR
      FOR SELECT cd_servico , vl_pago_produtividade , vl_pago_produtividade_cred
        FROM PRODUTIVIDADE_FILIAL
        WHERE cd_filial = @FIL_OR

      OPEN cursor_a
      FETCH NEXT FROM cursor_a INTO @cd_servico , @vl_pago_produtividade , @vl_pago_produtividade_cred
      WHILE (@@FETCH_STATUS <> -1)
        BEGIN

          INSERT INTO produtividade_filial (cd_filial , cd_servico , vl_pago_produtividade , vl_pago_produtividade_cred)
          VALUES (@FIL_DEST , @cd_servico , @vl_pago_produtividade , @vl_pago_produtividade_cred)


          FETCH NEXT FROM cursor_a INTO @cd_servico , @vl_pago_produtividade , @vl_pago_produtividade_cred
        END
      DEALLOCATE cursor_a
      --print convert(varchar(10), @wl_acumula,101)

      COMMIT TRANSACTION
  END
