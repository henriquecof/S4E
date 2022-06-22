/****** Object:  Procedure [dbo].[Delete_BlackList_Telefones]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC dbo.Delete_BlackList_Telefones
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:23
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN

    DECLARE @telefone VARCHAR(13) = ''

    DECLARE cursor_acerto CURSOR
    FOR SELECT telefone
      FROM BlackListTelefones
      WHERE dataExclusao IS NULL

    OPEN cursor_acerto
    FETCH NEXT FROM cursor_acerto INTO @telefone
    WHILE (@@fetch_status <> -1)
      BEGIN

        PRINT @telefone
        DELETE TB_Contato
        WHERE tusTelefone = @telefone
              AND
              cd_origeminformacao IN (1 , 5)

        FETCH NEXT FROM cursor_acerto INTO @telefone
      END
    DEALLOCATE cursor_acerto

  END
