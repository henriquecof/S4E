/****** Object:  Procedure [dbo].[excluir_usuario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.excluir_usuario
                 @cd_usuario VARCHAR(10)

-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 09:26
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================


AS
  BEGIN

    BEGIN TRANSACTION
    DELETE FROM usuario
    WHERE cd_usuario = @cd_usuario
    DELETE FROM usuario_sistema
    WHERE cd_usuario = @cd_usuario
    DELETE FROM usuario_filial
    WHERE cd_usuario = @cd_usuario
    COMMIT TRANSACTION

  END
