/****** Object:  Procedure [dbo].[confere_inventario]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE dbo.confere_inventario (
                 @CD_inventario AS INT ,
                 @CD_PRODUTO AS INT ,
                 @QT_inv AS FLOAT ,
                 @CD_FILIAL AS INT
)
-- =============================================
-- Author:      henrique.almeida
-- Create date: 10/09/2021 10:42
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- =============================================



/*
ESSA VARIAVEL INICIA COM PARAMETRO DE ENTRADA.:
@CD_inventario AS INT,
@CD_PRODUTO AS INT,
@QT_inv AS float, 
@CD_FILIAL as INT

NO INICIO É DECLARADA DUAS VARIAVEIS.:
@QT_est AS float,
@fl_inv as bit

USADO PRINT NA VARIAVEL @CD_inventario SE IF <> ''.
 REALIZADO ABERTURA EM BEGIN NA CONDIÇÃO IF <>0 E DENTRO REALIZADO SELECT NA TABELA movimento_inventario, USANDO COMO CONDIÇÃO NA CLAUSULA WHERE
 cd_inventario = @cd_inventario.
  
  1º - REALIZADO SELECT NA TABELA movimento_inventario, USANDO COMO CONDIÇÃO NA CLAUSULA WHERE cd_inventario = @cd_inventario.
  2º - REALIZADO DELETE NA TABELA movimento_inventario USANDO COMO CONDIÇÃO NA CLAUSULA  WHERE cd_inventario = @cd_inventario and cd_produto = @CD_PRODUTO 
  3º - REALIZADO SELECT NA TABELA ESTOQUE, USANDO COMO CLAUSULA NA CONDIÇÃO WHERE cd_filial = @CD_FILIAL and cd_produto =@cd_produto
  4º - USANDO PRINT NA VARIAVEL @QT_est.
  5º - REALIZANDO OUTRO IF E ESPECIFICANDO ALGUMAS CONDIÇÕES.:
		5.1 @QT_est <> @QT_inv ABERTO BEGIN
			5.1.1  @QT_est < @QT_inv ABERTO OUTRO BEGIN SETANDO O VALOR @fl_inv = 1	E FECHADO O IF COM END.
			5.1.2 ABERTO OUTRO IF @QT_est > @QT_inv E OUTRO BEGIN SETANDO O VALOR @fl_inv = 0 E FECHADO O IF COM END.
			5.1.3 REALIZADO INSERT NA TABELA.: movimento_inventario USANDO COMO VALORES.:
			@cd_inventario,
			@CD_PRODUTO,
			abs(@QT_est - @QT_inv),
			@fl_inv

			REALIZADO PRINT EM abs(@QT_est - @QT_inv)
			REALIZADO PRINT EM @fl_Inv
			FECHADO BEGIN DO ITEM 5.1
			FECHADO BEGIN INICIAL.
*/
AS
  DECLARE @QT_est AS FLOAT ,
  @fl_inv AS BIT

  PRINT @cd_inventario

  IF @cd_inventario <> ''
    BEGIN

      IF (SELECT COUNT(cd_inventario)
            FROM movimento_inventario
            WHERE cd_inventario = @cd_inventario
        ) <> 0
        BEGIN
          DELETE FROM movimento_inventario
          WHERE cd_inventario = @cd_inventario
                AND
                cd_produto = @CD_PRODUTO
        END

      SELECT @QT_est = qt_estoque
      FROM estoque
      WHERE cd_filial = @CD_FILIAL
            AND
            cd_produto = @cd_produto
      PRINT @QT_est

      IF @QT_est <> @QT_inv
        BEGIN

          IF @QT_est < @QT_inv
            BEGIN
              SET @fl_inv = 1
            END

          IF @QT_est > @QT_inv
            BEGIN
              SET @fl_inv = 0
            END

          INSERT INTO movimento_inventario (cd_inventario , cd_produto , QUANTIDADE , MOVIMENTO)
          VALUES (@cd_inventario , @CD_PRODUTO , ABS(@QT_est - @QT_inv) , @fl_inv)
          PRINT ABS(@QT_est - @QT_inv)
          PRINT @fl_inv
        END

    END
