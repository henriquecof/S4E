/****** Object:  Procedure [dbo].[SP_TESTE]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[SP_TESTE]
	@aviso varChar(30),
	@assinatura varChar(30)
AS
BEGIN
   INSERT INTO AVISOS
   (nm_aviso, nm_assinatura, dt_aviso)
   VALUES
   (@aviso, @assinatura, getDate())
END
