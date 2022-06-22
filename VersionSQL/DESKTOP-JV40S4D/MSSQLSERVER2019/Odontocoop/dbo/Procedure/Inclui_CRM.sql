/****** Object:  Procedure [dbo].[Inclui_CRM]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Inclui_CRM
                 -- =============================================
                 -- Author:      henrique.almeida
                 -- Create date: 13/09/2021 10:51
                 -- Database:    S4ECLEAN
                 -- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
                 -- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
                 -- =============================================


                 @id INT
AS
  BEGIN

    IF @id = 1 -- Processo 01: Faturamento // 03:Processos bancos
      BEGIN -- 1

        IF (SELECT COUNT(0)
              FROM Log_Mensalidades
              WHERE CONVERT(VARCHAR(10) , dt_gerado , 101) = CONVERT(VARCHAR(10) , GETDATE() , 101)
                    AND
                    fl_regerado = 0
          ) > 0
          BEGIN -- 1.1
            PRINT 'Incluir no CRM'  -- Processo:1
          END -- 1.1

        IF (SELECT COUNT(0)
              FROM Lote_Processos_Bancos
              WHERE dt_finalizado IS NULL
          ) > 0

          BEGIN -- 1.2
            PRINT 'Incluir no CRM' -- Processo:3
          END -- 1.2

      END -- 1

    IF @id = 2 -- Processo 02: Comissao
      BEGIN -- 1

        IF (SELECT COUNT(*)
              FROM lote_comissao
              WHERE CONVERT(VARCHAR(10) , dt_cadastro , 101) = CONVERT(VARCHAR(10) , GETDATE() , 101)
          ) > 0
          BEGIN -- 1.1
            PRINT 'Incluir no CRM'  -- Processo:1
          END -- 1.1

      END -- 1


  END
