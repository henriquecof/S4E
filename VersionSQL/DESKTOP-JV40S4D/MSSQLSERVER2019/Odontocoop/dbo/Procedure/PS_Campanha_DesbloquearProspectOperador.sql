/****** Object:  Procedure [dbo].[PS_Campanha_DesbloquearProspectOperador]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.PS_Campanha_DesbloquearProspectOperador
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 16:59
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN
    SET NOCOUNT ON;

    DELETE CampanhaAssociado
    FROM CampanhaLoteItens T2
    WHERE CampanhaAssociado.cd_campanha_lote = T2.cd_campanha_lote
          AND
          CampanhaAssociado.cd_associado = CONVERT(INT , T2.ID_ERP_CRM)
          AND
          T2.chaId IS NULL
          AND
          CampanhaAssociado.casDtCadastro < DATEADD(HOUR , -1 , GETDATE())
          AND
          (SELECT COUNT(0)
              FROM Campanha
              WHERE cd_campanha = T2.cd_campanha
                    AND
                    cd_origem_campanha = 1
                    AND
                    fl_recarregar_dados = 1
          ) > 0
  END
