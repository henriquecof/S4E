/****** Object:  Procedure [dbo].[PS_CriaLoteCarteira_BKP]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 10:03
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_CriaLoteCarteira_BKP
AS
BEGIN
  DECLARE @NovoLoteCarteira INT
  DECLARE @LayoutCarteira VARCHAR(50)

  DECLARE cursor_LayoutCart CURSOR FOR SELECT DISTINCT
    end_LayoutCarteira
  FROM PLANOS
  WHERE end_LayoutCarteira IS NOT NULL

  BEGIN TRANSACTION
  OPEN cursor_LayoutCart
  FETCH NEXT FROM cursor_LayoutCart INTO @LayoutCarteira
  WHILE (@@fetch_status <> -1)
  BEGIN


  --** Busca Layouts **-- 
  INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, end_LayoutCarteira)
    VALUES (GETDATE(), 'True', @LayoutCarteira)

  SELECT
    @NovoLoteCarteira = MAX(sq_lote)
  FROM Lotes_Carteiras

  EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira;


  FETCH NEXT FROM cursor_LayoutCart INTO @LayoutCarteira
  END
  COMMIT TRANSACTION
  CLOSE cursor_LayoutCart
  DEALLOCATE cursor_LayoutCart

  SELECT
    @NovoLoteCarteira

END
