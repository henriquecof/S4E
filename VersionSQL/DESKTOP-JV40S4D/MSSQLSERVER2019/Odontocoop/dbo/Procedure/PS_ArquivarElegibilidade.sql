/****** Object:  Procedure [dbo].[PS_ArquivarElegibilidade]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_ArquivarElegibilidade
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 16:21
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN
    INSERT INTO dbo.ElegibilidadeBKP
           SELECT *
           FROM dbo.Elegibilidade
           WHERE eleDtValidade < GETDATE()

    DELETE dbo.Elegibilidade
    WHERE eleDtValidade < GETDATE()
  END
