/****** Object:  Procedure [dbo].[Aviso_48_Horas]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Aviso_48_Horas

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 08:37
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO NO ESTILO DA T-SQL
-- =============================================



/***
ESSA PROCEDURE REALIZA UM INSERT NA TABELA EMAILS E DISPARA OS EMAILS CONFORME CONFIGURADO
***/


AS

  DECLARE @wl_venc DATETIME
  DECLARE @wl_tp INTEGER
  DECLARE @wl_seq INTEGER
  DECLARE @wl_mens VARCHAR(255)


  BEGIN

      DECLARE cursor_h CURSOR
      FOR SELECT dt_vencimento , cd_tipo_pagamento
        FROM gerado_arquivo
        WHERE dt_envio IS NULL
              AND
              dt_vencimento >= GETDATE() - 2
              AND
              dt_vencimento <= GETDATE()
              AND
              cd_tipo_pagamento NOT IN (21 , 81 , 69 , 80)
      OPEN cursor_h
      FETCH NEXT FROM cursor_h INTO @wl_venc , @wl_tp
      WHILE (@@FETCH_STATUS <> -1)
        BEGIN

          DECLARE cursor_a CURSOR
          FOR SELECT MAX(cd_sequencial) + 1
            FROM emails
          OPEN cursor_a
          FETCH NEXT FROM cursor_a INTO @wl_seq
          DEALLOCATE cursor_a

          SELECT @wl_mens = '<font size=1 face=arial>Arquivo ainda não enviado - Vencimento: ' + CONVERT(CHAR(10) , @wl_venc) + ' - Tipo de Pagamento: '

          IF @wl_tp = 1
            SELECT @wl_mens = @wl_mens + 'PAGUE MENOS'

          IF @wl_tp = 8
            SELECT @wl_mens = @wl_mens + 'BANCO DO BRASIL - DEB.AUTOMATICO'

          IF @wl_tp = 10
            SELECT @wl_mens = @wl_mens + 'BRADESCO - DEB.AUTOMATICO'
          /*if @wl_tp = 21 select @wl_mens = @wl_mens + 'VISANET'		*/

          IF @wl_tp = 50
            SELECT @wl_mens = @wl_mens + 'SP ESTADUAL/CE'
          /*if @wl_tp = 69 select @wl_mens = @wl_mens + 'BANCO REAL - DEB.AUTOMATICO'*/

          IF @wl_tp = 70
            SELECT @wl_mens = @wl_mens + 'BANCO DO ESTADO DO MARANHÃO'
          /*if @wl_tp = 80 select @wl_mens = @wl_mens + 'PREFEITURA MUNICIPAL DE SÃO LUIS'*/
          /*if @wl_tp = 81 select @wl_mens = @wl_mens + 'SP FEDERAL - SIAPE'*/

          IF @wl_tp = 82
            SELECT @wl_mens = @wl_mens + 'PREFEITURA MUNICIPAL DE FORTALEZA'

          IF @wl_tp = 85
            SELECT @wl_mens = @wl_mens + 'SP ESTADUAL/RN - ERGON'

          IF @wl_tp = 86
            SELECT @wl_mens = @wl_mens + 'CHEGUE-PAGUE'

          IF @wl_tp = 87
            SELECT @wl_mens = @wl_mens + 'LAB.LOUIS PASTEUR'

          SET @wl_mens = @wl_mens + '</font>'


          IF @wl_tp = 50
            OR
            @wl_tp = 80
            OR /*@wl_tp = 81 or */
            @wl_tp = 82
            OR
            @wl_tp = 85
            BEGIN
              INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
              VALUES (@wl_seq , 'washington@absonline.com.br' , @wl_mens , 'ABS Online-Prazo dos Arquivos' , 0)
            END
          ELSE

          IF @wl_tp = 87
            BEGIN
              INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
              VALUES (@wl_seq , 'washington@absonline.com.br' , @wl_mens , 'ABS Online-Prazo dos Arquivos' , 0)
            END
          ELSE
            BEGIN
              INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
              VALUES (@wl_seq , 'washington@absonline.com.br' , @wl_mens , 'ABS Online-Prazo dos Arquivos' , 0)
            END


          FETCH NEXT FROM cursor_h INTO @wl_venc , @wl_tp
        END
      DEALLOCATE cursor_h


      DECLARE cursor_h CURSOR
      FOR SELECT dt_vencimento , cd_tipo_pagamento
        FROM gerado_arquivo
        WHERE dt_envio IS NULL
              AND
              GETDATE() > dt_vencimento
              AND
              cd_tipo_pagamento NOT IN (21 , 81 , 69 , 80)
      OPEN cursor_h
      FETCH NEXT FROM cursor_h INTO @wl_venc , @wl_tp
      WHILE (@@FETCH_STATUS <> -1)
        BEGIN

          DECLARE cursor_a CURSOR
          FOR SELECT MAX(cd_sequencial) + 1
            FROM emails
          OPEN cursor_a
          FETCH NEXT FROM cursor_a INTO @wl_seq
          DEALLOCATE cursor_a

          SELECT @wl_mens = '<font size=1 face=arial>Prazo para envio do arquivo esgotado! - Vencimento: ' + CONVERT(VARCHAR(11) , @wl_venc) + ' - Tipo de Pagamento: '

          IF @wl_tp = 1
            SELECT @wl_mens = @wl_mens + 'PAGUE MENOS'

          IF @wl_tp = 8
            SELECT @wl_mens = @wl_mens + 'BANCO DO BRASIL - DEB.AUTOMATICO'

          IF @wl_tp = 10
            SELECT @wl_mens = @wl_mens + 'BRADESCO - DEB.AUTOMATICO'
          /*if @wl_tp = 21 select @wl_mens = @wl_mens + 'VISANET'		*/

          IF @wl_tp = 50
            SELECT @wl_mens = @wl_mens + 'SP ESTADUAL/CE'
          /*if @wl_tp = 69 select @wl_mens = @wl_mens + 'BANCO REAL - DEB.AUTOMATICO'*/

          IF @wl_tp = 70
            SELECT @wl_mens = @wl_mens + 'BANCO DO ESTADO DO MARANHÃO'
          /*if @wl_tp = 80 select @wl_mens = @wl_mens + 'PREFEITURA MUNICIPAL DE SÃO LUIS'*/
          /*if @wl_tp = 81 select @wl_mens = @wl_mens + 'SP FEDERAL - SIAPE'*/

          IF @wl_tp = 82
            SELECT @wl_mens = @wl_mens + 'PREFEITURA MUNICIPAL DE FORTALEZA'

          IF @wl_tp = 85
            SELECT @wl_mens = @wl_mens + 'SP ESTADUAL/RN - ERGON'

          IF @wl_tp = 86
            SELECT @wl_mens = @wl_mens + 'CHEGUE-PAGUE'

          IF @wl_tp = 87
            SELECT @wl_mens = @wl_mens + 'LAB.LOUIS PASTEUR'

          SET @wl_mens = @wl_mens + '</font>'

          PRINT LEN(@wl_mens)
          PRINT @wl_mens

          INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
          VALUES (@wl_seq , 'carlos@absonline.com.br' , @wl_mens , 'ABS Online-Prazo Esgotado!' , 0)

          SELECT @wl_seq = @wl_seq + 1

          INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
          VALUES (@wl_seq , 'washington@absonline.com.br' , @wl_mens , 'ABS Online-Prazo Esgotado!' , 0)

          FETCH NEXT FROM cursor_h INTO @wl_venc , @wl_tp
        END
      DEALLOCATE cursor_h


  END
