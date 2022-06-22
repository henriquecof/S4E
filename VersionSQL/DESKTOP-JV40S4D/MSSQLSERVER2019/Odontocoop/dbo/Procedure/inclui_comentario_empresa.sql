/****** Object:  Procedure [dbo].[inclui_comentario_empresa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROC dbo.inclui_comentario_empresa
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:49
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMTAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================



                 @cdep INT ,
                 @coment NVARCHAR(1500) ,
                 @usuario CHAR(10)

AS

  BEGIN

    DECLARE @cdass INT

    BEGIN TRANSACTION

    DECLARE cursor_jk CURSOR
    FOR SELECT cd_Associado
      FROM ASSOCIADOS
      WHERE CD_empresa = @cdep
    OPEN cursor_jk
    FETCH NEXT FROM cursor_jk INTO @cdass
    WHILE (@@fetch_status <> -1)
      BEGIN
        INSERT INTO Comentario (cd_associado , CD_TP_ASSOCIADO , ds_comentario , dt_comentario , cd_usuario)
        VALUES (@cdass , 1 , @coment , GETDATE() , @usuario)

        FETCH NEXT FROM cursor_jk INTO @cdass
      END
    DEALLOCATE cursor_jk


    INSERT INTO Comentario (cd_associado , CD_TP_ASSOCIADO , ds_comentario , dt_comentario , cd_usuario)
    VALUES (@cdep , 2 , @coment , GETDATE() , @usuario)

    COMMIT
  END
