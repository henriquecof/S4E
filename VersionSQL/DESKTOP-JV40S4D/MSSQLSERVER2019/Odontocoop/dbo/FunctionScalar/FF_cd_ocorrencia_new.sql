/****** Object:  Function [dbo].[FF_cd_ocorrencia_new]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE FUNCTION [dbo].[FF_cd_ocorrencia_new] (
	 @banco INT
	,@cd_ocorrencia VARCHAR(5)
	)
RETURNS INT
AS
BEGIN
	DECLARE @cd_ocorrencia_new INT = 0 
	
	set @cd_ocorrencia_new = (
			SELECT TOP 1 T1.cd_ocorrencia_new
			FROM deb_automatico_cr_conversao T1
			WHERE banco = @banco
				AND cd_ocorrencia = @cd_ocorrencia
			)

	RETURN @cd_ocorrencia_new
END
