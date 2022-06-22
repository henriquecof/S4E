/****** Object:  Procedure [dbo].[historico_visa]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.historico_visa
                 @cdass INT
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 10:46
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    DECLARE @NomeTab VARCHAR(6)
    DECLARE @sqlSt VARCHAR(1000)
    SET @sqlSt = ''

    DECLARE cursor_visa CURSOR
    FOR SELECT name
      FROM sysobjects
      WHERE name LIKE 'VI0%'
            OR
            name LIKE 'VI1%'
      ORDER BY crdate
    OPEN cursor_visa
    FETCH NEXT FROM cursor_visa INTO @NomeTab
    WHILE (@@fetch_status <> -1)
      BEGIN
        PRINT @NomeTab
        SET @sqlSt = @sqlSt + 'select dt_vencimento, nm_status,''' + @NomeTab + ''' from ' + @NomeTab + ' 
				inner join _visanet_status on  ' + @NomeTab + '.cd_rejeicao = _visanet_status.cd_status
				where cd_rejeicao != 0 and cd_associado = ' + CONVERT(VARCHAR(6) , @cdass) + ' union '

        FETCH NEXT FROM cursor_visa INTO @NomeTab
      END
    DEALLOCATE cursor_visa

    SET @sqlSt = @sqlSt + ' select '','',''' /**left(@sqlSt,len(@sqlSt)-7)
  	if (len(@sqlSt) > 7) **/
    EXECUTE (@sqlSt)
  END
