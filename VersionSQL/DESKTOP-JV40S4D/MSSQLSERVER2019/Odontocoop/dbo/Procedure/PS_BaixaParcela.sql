/****** Object:  Procedure [dbo].[PS_BaixaParcela]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_BaixaParcela (
                 @CD_Empresa INT ,
                 @DT_Vencimento VARCHAR(10) ,
                 @Usuario VARCHAR
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 16:29
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    DECLARE @CD_Grupo INT
    DECLARE @WL_EmpresaGrupo INT

    BEGIN TRANSACTION

    SELECT @CD_Grupo = CD_Grupo
    FROM EMPRESA
    WHERE CD_Empresa = @CD_Empresa

    IF @CD_Grupo IS NULL

      BEGIN

        -- Fechar a parcela dos associados que não foram tirados da mensalidade da empresa.
        UPDATE ABS1..MENSALIDADES
               SET CD_TIPO_RECEBIMENTO = 0 ,
                   DT_PAGAMENTO = GETDATE() ,
                   VL_PAGO = VL_PARCELA ,
                   DT_BAIXA = GETDATE() ,
                   CD_USUARIO_BAIXA = @Usuario ,
                   CD_TIPO_RECEBIMENTO = 15
        WHERE TP_ASSOCIADO_EMPRESA = 1
               AND
               YEAR(DT_VENCIMENTO) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
               AND
               MONTH(DT_VENCIMENTO) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
               AND
               CD_ASSOCIADO_empresa IN (SELECT CD_ASSOCIADO_empresa
                   FROM ABS1..MENSALIDADES
                   WHERE TP_ASSOCIADO_EMPRESA = 1
                         AND
                         CD_PARCELA <= 31999
                         AND
                         CD_ASSOCIADO_empresa IN (SELECT t100.cd_associado
                             FROM Abs1..ASSOCIADOS t100
                             WHERE cd_empresa = @CD_Empresa
                         )
                         AND
                         YEAR(DT_VENCIMENTO) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
                         AND
                         MONTH(DT_VENCIMENTO) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
                         AND
                         CD_ASSOCIADO_empresa NOT IN (SELECT cd_associado
                             FROM TB_LancamentoDesconto T200
                             WHERE cd_empresa = @CD_Empresa
                                   AND
                                   YEAR(Data_Vencimento) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
                                   AND
                                   MONTH(Data_Vencimento) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
                         )
               )
      END
    ELSE
      BEGIN
        -- Abrindo cursor para pegar as empresas.                                                            
        DECLARE Empresas_Cursor CURSOR
        FOR SELECT cd_empresa
          FROM ABS1..EMPRESA
          WHERE cd_grupo = @CD_Grupo

        OPEN Empresas_Cursor
        FETCH NEXT FROM Empresas_Cursor
        INTO @WL_EmpresaGrupo

        WHILE (@@fetch_status <> -1)
          BEGIN

            -- Fechar a parcela dos associados que não foram tirados da mensalidade da empresa.
            UPDATE ABS1..MENSALIDADES
                   SET CD_TIPO_RECEBIMENTO = 0 ,
                       DT_PAGAMENTO = GETDATE() ,
                       VL_PAGO = VL_PARCELA ,
                       DT_BAIXA = GETDATE() ,
                       CD_USUARIO_BAIXA = @Usuario ,
                       CD_TIPO_RECEBIMENTO = 15
            WHERE TP_ASSOCIADO_EMPRESA = 1
                   AND
                   YEAR(DT_VENCIMENTO) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
                   AND
                   MONTH(DT_VENCIMENTO) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
                   AND
                   CD_ASSOCIADO_empresa IN (SELECT CD_ASSOCIADO_empresa
                       FROM ABS1..MENSALIDADES
                       WHERE TP_ASSOCIADO_EMPRESA = 1
                             AND
                             CD_PARCELA <= 31999
                             AND
                             CD_ASSOCIADO_empresa IN (SELECT t100.cd_associado
                                 FROM Abs1..ASSOCIADOS t100
                                 WHERE cd_empresa = @WL_EmpresaGrupo
                             )
                             AND
                             YEAR(DT_VENCIMENTO) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
                             AND
                             MONTH(DT_VENCIMENTO) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
                             AND
                             CD_ASSOCIADO_empresa NOT IN (SELECT cd_associado
                                 FROM TB_LancamentoDesconto T200
                                 WHERE cd_empresa = @CD_Empresa
                                       AND
                                       YEAR(Data_Vencimento) = YEAR(CONVERT(SMALLDATETIME , @DT_Vencimento))
                                       AND
                                       MONTH(Data_Vencimento) = MONTH(CONVERT(SMALLDATETIME , @DT_Vencimento))
                             )
                   )

            --Baixa das empresas do grupo.
            UPDATE ABS1..MENSALIDADES
                   SET vl_multa = 0 ,
                       VL_PAGO = (SELECT SUM(VL_PARCELA)
                           FROM MENSALIDADES
                           WHERE CD_TIPO_RECEBIMENTO > 2
                                 AND
                                 TP_ASSOCIADO_EMPRESA = 2
                                 AND
                                 DT_VENCIMENTO = CONVERT(SMALLDATETIME , @DT_Vencimento)
                                 AND
                                 CD_ASSOCIADO_empresa = @WL_EmpresaGrupo
                       ) ,
                       vl_juros = 0 ,
                       VL_Desconto = 0 ,
                       CD_TIPO_RECEBIMENTO = 15 ,
                       DT_BAIXA = GETDATE() ,
                       DT_PAGAMENTO = GETDATE() ,
                       CD_USUARIO_BAIXA = @Usuario
            WHERE CD_ASSOCIADO_empresa = @WL_EmpresaGrupo
                   AND
                   TP_ASSOCIADO_EMPRESA = 2
                   AND
                   DT_VENCIMENTO = CONVERT(SMALLDATETIME , @DT_Vencimento)
                   AND
                   CD_PARCELA < 32000

            FETCH NEXT FROM Empresas_Cursor
            INTO @WL_EmpresaGrupo

          END
        CLOSE Empresas_Cursor
        DEALLOCATE Empresas_Cursor

      END

    COMMIT TRANSACTION
  END
