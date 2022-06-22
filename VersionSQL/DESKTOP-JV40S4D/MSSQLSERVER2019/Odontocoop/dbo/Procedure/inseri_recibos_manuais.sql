/****** Object:  Procedure [dbo].[inseri_recibos_manuais]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.inseri_recibos_manuais
                 @qtd AS INT ,
                 @filial AS INT ,
                 @USUARIO AS VARCHAR(8)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:56
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  DECLARE @i AS INT
  DECLARE @cd AS INT
  DECLARE @nr AS VARCHAR(10)

  SET @i = 1

  BEGIN

      BEGIN TRANSACTION
      WHILE @i <= @qtd
        BEGIN
          SELECT @cd = ISNULL(MAX(CONVERT(INT , nr_recibo)) , 0) + 1
          FROM Recibos_manuais
          WHERE cd_filial = @filial
          SET @nr = CONVERT(VARCHAR(10) , @cd)
          INSERT INTO Recibos_manuais (nr_recibo , dt_impressao , cd_filial , cd_usuario)
          VALUES (@nr , GETDATE() , @filial , @USUARIO)
          SET @i = @i + 1
        END
  END

  COMMIT
