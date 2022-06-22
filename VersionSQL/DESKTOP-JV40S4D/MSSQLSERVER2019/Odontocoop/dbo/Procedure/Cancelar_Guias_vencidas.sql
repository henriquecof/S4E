/****** Object:  Procedure [dbo].[Cancelar_Guias_vencidas]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 08:52
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================



/*ESSA PROCEDURE REALIZA DECLARAÇÃO DE 2 VARIAVEIS.:
@wl_seq integer
@wl_mens varchar(1000)

NO INICIO DE BEGIN TRANSACTION É DECLARADO UM cursor_guia COM SELECT REFERENCIANDO A TABELA.:
procedimentos_pendentes.
NA CONDIÇÃO DA CLAUSULA WHERE.:
nr_autorizacao is null and 
nr_guia is not null and 
dt_cancelado is  null and 
fl_baixa = 0 and 
nr_guia in (
select distinct nr_guia from 
procedimentos_pendentes 
where nr_autorizacao is null and 
nr_guia is not null 
and dt_cancelado is null group by nr_guia having max(dt_servico)<= getdate()-60)
 
 O CURSOR É ABERTO E REALIZADO FETCH NEXT FROM cursor_guia REALIZANDO INSERT NA VARIAVAL @wl_seq
 ENQUANTO WHILE (@@fetch_status<>-1) É ABERTO BEGIN E FEITO UPDATE NA TABELA.:
 procedimentos_pendentes.
 SETANDO OS VALORES.:
	dt_cancelado =getdate(),
	motivo_cancelamento = 'Guia vencida automaticamente'
E NAS CLAUSULA WHERE USADO A CONDIÇÃO.:
cd_sequencial=@wl_seq.

SAINDO DESSA CONDIÇÃO REALIZANDO OUTRO FETCH NEXT FROM EM cursor_guia REALIZANDO INSERT NA VARIAVEL @wl_seq.
FEITO DEALLOCATE NO CURSOR cursor_guia.

REALIZADO SELECT SEQUINTE SELECT NA TABELA E-MAILS BUSCANDO O CAMPO.:
@wl_seq= isnull(max(cd_sequencial)+1,1) 

DEPOIS REALIZADO SELECT NA VARIAVEL @wl_mens.

APÓS REALIZADO INSERT NA TABELA EMAILS.
*/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:37
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================



CREATE PROCEDURE dbo.Cancelar_Guias_vencidas
AS
  DECLARE @wl_seq INTEGER
  DECLARE @wl_mens VARCHAR(1000)
  BEGIN TRANSACTION


  DECLARE cursor_guia CURSOR
  FOR SELECT cd_sequencial
    FROM procedimentos_pendentes
    WHERE nr_autorizacao IS NULL
          AND
          nr_guia IS NOT NULL
          AND
          dt_cancelado IS NULL
          AND
          fl_baixa = 0
          AND
          nr_guia IN (SELECT DISTINCT nr_guia
              FROM procedimentos_pendentes
              WHERE nr_autorizacao IS NULL
                    AND
                    nr_guia IS NOT NULL
                    AND
                    dt_cancelado IS NULL
              GROUP BY nr_guia
              HAVING MAX(dt_servico) <= GETDATE() - 60
          ) OPEN cursor_guia
  FETCH NEXT FROM cursor_guia INTO @wl_seq
  WHILE (@@fetch_status <> -1)
    BEGIN

      UPDATE procedimentos_pendentes
             SET dt_cancelado = GETDATE() ,
                 MOTIVO_CANCELAMENTO = 'Guia vencida automaticamente'
      WHERE cd_sequencial = @wl_seq

      FETCH NEXT FROM cursor_guia INTO @wl_seq
    END
  DEALLOCATE cursor_guia

  SELECT @wl_seq = ISNULL(MAX(cd_sequencial) + 1 , 1)
  FROM emails

  SELECT @wl_mens = '<html><a href="http://intranet.absonline.com.br/guias_impressas.asp?txtdata1=' + CONVERT(VARCHAR(10) , GETDATE() , 103) + '&txtdata2=' + CONVERT(VARCHAR(10) , GETDATE() , 103) + '&auto=1"><font size=1 face=arial>Guias Canceladas por ultrapassarem 60 dias em ' + CONVERT(VARCHAR(10) , GETDATE() , 103) + '</font></a></BR><a href="http://intranet.absonline.com.br/carta_cancelados.asp?dt_ini=' + CONVERT(VARCHAR(10) , GETDATE() , 103) + '&dt_fim=' + CONVERT(VARCHAR(10) , GETDATE() , 103) + ' "><font size=1 face=arial>Imprimir Cartas</font></a></html>'

  INSERT INTO emails (cd_sequencial , nm_endereco , nm_mensagem , nm_assunto , fl_enviado)
  VALUES (@wl_seq , 'washington@absonline.com.br,claudia@absonline.com.br' , @wl_mens , 'ABS Online-Guias Canceladas' , 0)

  --,carlos@absonline.com.br,washington@absonline.com.br
  --,ubiratan@absonline.com.br,claudia@absonline.com.br
  COMMIT
