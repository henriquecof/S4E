/****** Object:  Procedure [dbo].[Peona_2014]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.Peona_2014
-- =============================================
-- Author:      henrique.almeida
-- Create date: 13/09/2021 11:05
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


AS
  BEGIN

    --- Observar e dar o erro na qt_diasminimo
    DECLARE @arquivo VARCHAR(200)  -- alterei aqui
    DECLARE @caminho VARCHAR(255)
    DECLARE @retEcho INT --variavel para verificar se o comando foi executado com exito ou ocorreu alguma falha 
    DECLARE @Linha VARCHAR(8000)

    DECLARE @ans VARCHAR(6)
    DECLARE @dt_ocorr VARCHAR(6)
    DECLARE @dt_aviso VARCHAR(6)
    DECLARE @valor MONEY

    SELECT TOP 1 @caminho = pasta_site , @ans = nr_ANS
    FROM Configuracao -- Verificar o caminho a ser gravado os arquivos

    IF @@ROWCOUNT = 0
      BEGIN -- 1.1
        RAISERROR ('Pasta dos Arquivos não definida.' , 16 , 1)
        RETURN
      END -- 1.1

    SET @arquivo = @caminho + '\arquivos\' + @ans + '_2014_PEONA.txt'

    IF @ans = '410420' -- prevdont
      BEGIN
        DECLARE cursor_peona CURSOR
        FOR SELECT CONVERT(VARCHAR(6) , dt_ocorrencia , 112) AS dt_ocorr , CONVERT(VARCHAR(6) , dt_aviso , 112) AS dt_avis , SUM(valor) AS valor
          FROM peona
          GROUP BY CONVERT(VARCHAR(6) , dt_ocorrencia , 112) , CONVERT(VARCHAR(6) , dt_aviso , 112)
          ORDER BY CONVERT(VARCHAR(6) , dt_ocorrencia , 112) , CONVERT(VARCHAR(6) , dt_aviso , 112)
      END

    IF @ans = '417131' -- MD 
      BEGIN
        DECLARE cursor_peona CURSOR
        FOR SELECT CONVERT(VARCHAR(6) , dt_servico , 112) , CONVERT(VARCHAR(6) , DT_BAIXA , 112) , SUM(vl_pago_produtividade)
          FROM Consultas AS c
          WHERE c.nr_numero_lote IS NOT NULL
                AND
                c.dt_servico >= '01/01/2012'
                AND
                c.dt_servico < '01/01/2014'
                AND
                c.dt_baixa >= '01/01/2012'
                AND
                c.dt_baixa < '04/01/2014'
                AND
                CONVERT(VARCHAR(6) , dt_baixa , 112) >= CONVERT(VARCHAR(6) , dt_servico , 112)
          GROUP BY CONVERT(VARCHAR(6) , dt_servico , 112) , CONVERT(VARCHAR(6) , dt_baixa , 112)
          ORDER BY CONVERT(VARCHAR(6) , dt_servico , 112) , CONVERT(VARCHAR(6) , dt_baixa , 112)
      END

    IF @ans = '414387' -- Odontoart 
      BEGIN
        DECLARE cursor_peona CURSOR
        FOR SELECT dt_ocorrencia AS dt_ocorr , dt_aviso AS dt_avis , SUM(valor) AS valor
          FROM peona
          GROUP BY CONVERT(VARCHAR(6) , dt_ocorrencia , 112) , CONVERT(VARCHAR(6) , dt_aviso , 112)
          ORDER BY CONVERT(VARCHAR(6) , dt_ocorrencia , 112) , CONVERT(VARCHAR(6) , dt_aviso , 112)
      END

    OPEN cursor_peona
    FETCH NEXT FROM cursor_peona INTO @dt_ocorr , @dt_aviso , @valor

    WHILE (@@FETCH_STATUS <> -1)
      BEGIN  -- 4.2        

        SET @linha = @ans + ';' + RIGHT(@dt_ocorr , 2) + LEFT(@dt_ocorr , 4) + ';' + RIGHT(@dt_aviso , 2) + LEFT(@dt_aviso , 4) + ';' + REPLACE(CONVERT(VARCHAR(16) , @valor) , '.' , ',')

        IF @Linha IS NULL
          OR
          @Linha = ''
          BEGIN -- 2.2.6
            SET @linha = 'Del ' + @arquivo
            EXEC SP_Shell @linha , 0 -- Excluir se o arquivo já existir
            RAISERROR ('Erro na geração do Arquivo.' , 16 , 1)
            RETURN
          END -- 2.2.6

        SET @linha = 'ECHO ' + @linha + '>> ' + @arquivo
        EXEC SP_Shell @linha

        FETCH NEXT FROM cursor_peona INTO @dt_ocorr , @dt_aviso , @valor
      END
    CLOSE cursor_peona
    DEALLOCATE cursor_peona

  END
