/****** Object:  Procedure [dbo].[PS_CriaLoteCarteira]    Committed by VersionSQL https://www.versionsql.com ******/

-- =============================================
-- Author:      henrique.almeida
-- Create date: 17/09/2021 10:02
-- Database:    S4ECLEAN
-- Description: REALIZADO PADRONIZAÇÃO E FORMATAÇÃO DE ESTILO T-SQL
-- REALIZAR DOCUMENTAÇÃO DA PROCEDURE USANDO EXTENDED PROPERTIES
-- =============================================


CREATE PROCEDURE dbo.PS_CriaLoteCarteira (
-- Add the parameters for the stored procedure here
@Centro_custo INT,
@Tipo_Empresa INT,
@cd_plano INT,
@TranspInEmpresa VARCHAR(500),
@TranspNotInEmpresa VARCHAR(500),
@Dt_AdesaoIni VARCHAR(10),
@Dt_AdesaoFin VARCHAR(10),
@Dt_CadastroIni VARCHAR(10),
@Dt_CadastroFin VARCHAR(10),
@fl_LoteVazio INT,
@fl_RegeraLote SMALLINT,
@TranspInGrupo VARCHAR(500),
@cd_funcionarioCadastro INT,
@ds_lote VARCHAR(200),
@TranspInFuncionario VARCHAR(500),
@TRANSPincd_Grupo VARCHAR(500),
@TRANSInContrato VARCHAR(500))
AS
BEGIN
  DECLARE @NovoLoteCarteira INT
  DECLARE @LayoutCarteira VARCHAR(50)
  DECLARE @LicensaS4E VARCHAR(50)

  SELECT TOP 1
    @LicensaS4E = LicencaS4E
  FROM Configuracao

  BEGIN TRANSACTION
  IF @LicensaS4E = 'QJSH717634HGSD981276SDSCVJHSD8721365SAAUS7A615002'
    OR @LicensaS4E = 'AJGFGFUYHURHTRJHFGJDGHJDVJIUGIRFHGIFHHSDUGDSUY017'
    OR @LicensaS4E = 'UHGFIYUFGJVBBGJGDUFTYEFEHJFHDFDFDGYTSDSUIUTRYF018'
  BEGIN
    IF @Tipo_Empresa <= 0
    BEGIN --Indiferente
      PRINT 'Indiferente/TODOS'
      --** PESSOA JURIDICA **-- 
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 2, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END

      --** PESSOA FÍSICA **--
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 3, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END

      --** Servidor **--
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 4, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END
    END	--Fim Indiferente

    ELSE
    IF @Tipo_Empresa = 3
    BEGIN--Pessoa Fisica
      PRINT 'Pessoa Física'
      --** PESSOA FÍSICA **--
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 3, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END
    END --Fim Pessoa Fisica

    ELSE
    IF @Tipo_Empresa = 2
      OR @Tipo_Empresa = 7
      OR @Tipo_Empresa = 8
    BEGIN--Pessoa Juridica
      PRINT 'Pessoa Juridica'
      --** PESSOA JURIDICA **-- 
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 2, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END
    END	--Fim Pessoa Juridica

    ELSE
    IF @Tipo_Empresa = 1
      OR @Tipo_Empresa = 4
      OR @Tipo_Empresa = 5
    BEGIN--Servidor
      PRINT 'Servidor'
      --** Servidor **--
      INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, TP_EMPRESA, cd_usuariocadastro)
        VALUES (GETDATE(), 'True', 4, @cd_funcionarioCadastro)

      SELECT
        @NovoLoteCarteira = MAX(sq_lote)
      FROM Lotes_Carteiras
      IF @fl_LoteVazio = 0
      BEGIN
        EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                      ,@Centro_custo
                                      ,@Tipo_Empresa
                                      ,@cd_plano
                                      ,@TranspInEmpresa
                                      ,@TranspNotInEmpresa
                                      ,@Dt_AdesaoIni
                                      ,@Dt_AdesaoFin
                                      ,@Dt_CadastroIni
                                      ,@Dt_CadastroFin
                                      ,@fl_RegeraLote
                                      ,@TranspInGrupo
                                      ,@TranspInFuncionario
                                      ,@TRANSPincd_Grupo
                                      ,@TRANSInContrato
      END
    END	--Fim Servidor			 
  END

  ELSE
  BEGIN
    PRINT 'else'
    DECLARE @SQL VARCHAR(MAX)
    DECLARE @Result TABLE (
      LayoutCarteira VARCHAR(50)
    );

    SET @SQL = ''
    SET @SQL = @SQL + 'select distinct end_LayoutCarteira from planos where end_LayoutCarteira is not null '

    IF @LicensaS4E = 'THFIEW74WDESD0905423JHGF87454FRDH65232986560SS009'
      OR @LicensaS4E = '0061FKGFVHJU567YTREDFGHJKJHY54RTFDSAWERTYUIOIU76H'
    BEGIN
      SET @SQL = @SQL + ' and end_LayoutCarteira <> ''LayoutIndefinido.jpg'' '
    END

    IF ISNULL(@cd_plano, 0) > 0
    BEGIN
      SET @SQL = @SQL + '	and cd_plano = ' + CONVERT(VARCHAR(10), @cd_plano)
    END

    INSERT INTO @Result EXEC (@SQL);

    DECLARE cursor_LayoutCart CURSOR FOR SELECT
      LayoutCarteira
    FROM @Result

    BEGIN TRANSACTION
    OPEN cursor_LayoutCart
    FETCH NEXT FROM cursor_LayoutCart INTO @LayoutCarteira
    WHILE (@@fetch_status <> -1)
    BEGIN--Cursor
    --** Busca Layouts **-- 
    PRINT 'entrou layout'
    INSERT INTO Lotes_Carteiras (dt_abertura, fl_visivel, end_LayoutCarteira, cd_usuariocadastro)
      VALUES (GETDATE(), 'True', @LayoutCarteira, @cd_funcionarioCadastro)

    SELECT
      @NovoLoteCarteira = ISNULL(MAX(sq_lote), 1)
    FROM Lotes_Carteiras
    IF @fl_LoteVazio = 0
    BEGIN
      EXECUTE PS_CarregaLoteCarteira @NovoLoteCarteira
                                    ,@Centro_custo
                                    ,@Tipo_Empresa
                                    ,@cd_plano
                                    ,@TranspInEmpresa
                                    ,@TranspNotInEmpresa
                                    ,@Dt_AdesaoIni
                                    ,@Dt_AdesaoFin
                                    ,@Dt_CadastroIni
                                    ,@Dt_CadastroFin
                                    ,@fl_RegeraLote
                                    ,@TranspInGrupo
                                    ,@TranspInFuncionario
                                    ,@TRANSPincd_Grupo
                                    ,@TRANSInContrato;
    END

    FETCH NEXT FROM cursor_LayoutCart INTO @LayoutCarteira
    END--Fim Cursor
    COMMIT TRANSACTION
    CLOSE cursor_LayoutCart
    DEALLOCATE cursor_LayoutCart
  END

  COMMIT TRANSACTION
  SELECT
    @NovoLoteCarteira

END
