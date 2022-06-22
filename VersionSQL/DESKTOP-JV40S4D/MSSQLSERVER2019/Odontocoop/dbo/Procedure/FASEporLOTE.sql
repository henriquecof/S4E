/****** Object:  Procedure [dbo].[FASEporLOTE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[FASEporLOTE]
	@IntCd_Lote INTEGER

    /*
    Data e Hora.: 2022-05-24 14:19:51
    Usuário.: henrique.almeida
    Database.: S4ECLEAN
    Servidor.: 10.1.1.10\homologacao
    Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
    QUERY ANTIGA COMENTADA PARA HISTORICO.
    */

AS
  /*
  DECLARE @IntCd_Lote INTEGER 
  SET @IntCd_Lote = 20
  */

	--SELECT
	--   	ISNULL(CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Recebimento , 103) , '-PENDENTE-') AS Dt_Recebimento ,
	--   	dbo.USUARIO.cd_usuario USU_RECEBEU ,
	--   	dbo.Fase.Nm_Fase ,
	--   	USUARIO_1.cd_usuario AS cd_usurepass ,
	--   	CONVERT(VARCHAR(12) , dbo.Fase_Lote.DT_FASE , 103) DT_FASE
	--   FROM dbo.Fase,
	--   	dbo.Fase_Lote,
	--   	dbo.USUARIO,
	--   	dbo.USUARIO USUARIO_1
	--   WHERE dbo.Fase.Cd_Fase = dbo.Fase_Lote.Cd_fase
	--   AND dbo.Fase_Lote.Cd_UsuarioRecebeu = dbo.USUARIO.Cd_SequecialUsu
	--   AND dbo.Fase_Lote.Cd_UsuarioMandou = USUARIO_1.Cd_SequecialUsu
	--   AND dbo.Fase_Lote.Cd_Lote = @IntCd_Lote
	--   ORDER BY dbo.Fase_Lote.Cd_Lote_Fase DESC


	SELECT
    	ISNULL(CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Recebimento , 103) , '-PENDENTE-') AS Dt_Recebimento ,
    	dbo.USUARIO.cd_usuario USU_RECEBEU ,
    	dbo.Fase.Nm_Fase ,
    	USUARIO_1.cd_usuario AS cd_usurepass ,
    	CONVERT(VARCHAR(12) , dbo.Fase_Lote.DT_FASE , 103) DT_FASE
    FROM dbo.Fase
    	INNER JOIN dbo.Fase_Lote ON dbo.Fase.Cd_Fase = dbo.Fase_Lote.Cd_fase
    	INNER JOIN dbo.USUARIO ON dbo.Fase_Lote.Cd_UsuarioRecebeu = dbo.USUARIO.Cd_SequecialUsu
    	INNER JOIN dbo.USUARIO USUARIO_1 ON dbo.Fase_Lote.Cd_UsuarioMandou = USUARIO_1.Cd_SequecialUsu
    WHERE dbo.Fase_Lote.Cd_Lote = @IntCd_Lote
    ORDER BY dbo.Fase_Lote.Cd_Lote_Fase DESC
