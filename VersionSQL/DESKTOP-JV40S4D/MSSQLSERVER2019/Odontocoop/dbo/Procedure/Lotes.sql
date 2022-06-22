/****** Object:  Procedure [dbo].[Lotes]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[Lotes]
	@Cod_USU AS VARCHAR(10),
	@cod_fase AS VARCHAR(10)

/*
Data e Hora.: 2022-05-24 14:26:43
Usuário.: henrique.almeida
Database.: S4ECLEAN
Servidor.: 10.1.1.10\homologacao
Comentário.: REALIZADO PADRONIZAÇÃO T-SQL E FORMATAÇÃO.
QUERY ANTIGA DEIXADA COMENTADA PARA HISTORICO.
*/

AS
  /*
  DECLARE @COD_LOTE AS VARCHAR(5),@COD_FASSE AS VARCHAR(5)
  SET @COD_LOTE  = ''
  SET @COD_FASSE ='%'
  */ IF @Cod_USU = '-1' BEGIN
		SET @Cod_USU = '%'
	END

	IF @cod_fase = '-1' BEGIN
		SET @cod_fase = '%'
	END

	--SELECT DISTINCT
	--   	   dbo.Fase_Lote.Cd_Lote ,
	--   	   dbo.Fase.Nm_Fase ,
	--   	   CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Fase , 103) Dt_Fase ,
	--   	   dbo.USUARIO.cd_usuario AS repassou ,
	--   	   USUARIO_1.cd_usuario AS recebeu ,
	--   	   ISNULL(CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Recebimento , 103) , '-Pendente-') Dt_Recebimento
	--   FROM dbo.Lote,
	--   	dbo.Fase_Lote,
	--   	dbo.Fase,
	--   	dbo.USUARIO,
	--   	dbo.USUARIO USUARIO_1
	--   WHERE (dbo.Fase.Cd_Fase LIKE @cod_fase)
	--   AND dbo.Fase_Lote.Cd_UsuarioRecebeu LIKE @Cod_USU
	--   AND dbo.Lote.Cd_Lote = dbo.Fase_Lote.Cd_Lote
	--   AND dbo.Fase_Lote.Cd_fase = dbo.Fase.Cd_Fase
	--   AND dbo.Fase_Lote.Cd_UsuarioMandou = dbo.USUARIO.Cd_SequecialUsu
	--   AND dbo.Fase_Lote.Cd_UsuarioRecebeu = USUARIO_1.Cd_SequecialUsu
	--   AND dbo.Fase_Lote.Dt_Fase = (SELECT
	--                                	MAX(A.Dt_Fase)
	--                                FROM dbo.Fase_Lote AS A
	--                                WHERE dbo.Fase_Lote.Cd_Lote = A.Cd_Lote    )


	SELECT DISTINCT
    	   dbo.Fase_Lote.Cd_Lote ,
    	   dbo.Fase.Nm_Fase ,
    	   CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Fase , 103) Dt_Fase ,
    	   dbo.USUARIO.cd_usuario AS repassou ,
    	   USUARIO_1.cd_usuario AS recebeu ,
    	   ISNULL(CONVERT(VARCHAR(12) , dbo.Fase_Lote.Dt_Recebimento , 103) , '-Pendente-') Dt_Recebimento
    FROM dbo.Lote
    	INNER JOIN dbo.Fase_Lote ON dbo.Lote.Cd_Lote = dbo.Fase_Lote.Cd_Lote
    	INNER JOIN dbo.Fase ON dbo.Fase_Lote.Cd_fase = dbo.Fase.Cd_Fase
    	INNER JOIN dbo.USUARIO ON dbo.Fase_Lote.Cd_UsuarioMandou = dbo.USUARIO.Cd_SequecialUsu
    	INNER JOIN dbo.USUARIO USUARIO_1 ON dbo.Fase_Lote.Cd_UsuarioRecebeu = USUARIO_1.Cd_SequecialUsu
    WHERE (dbo.Fase.Cd_Fase LIKE @cod_fase)
    AND dbo.Fase_Lote.Cd_UsuarioRecebeu LIKE @Cod_USU
    AND dbo.Fase_Lote.Dt_Fase = (SELECT
                                 	MAX(A.Dt_Fase)
                                 FROM dbo.Fase_Lote AS A
                                 WHERE dbo.Fase_Lote.Cd_Lote = A.Cd_Lote )
