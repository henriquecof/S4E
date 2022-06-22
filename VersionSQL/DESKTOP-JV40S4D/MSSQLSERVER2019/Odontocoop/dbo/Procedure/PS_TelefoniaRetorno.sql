/****** Object:  Procedure [dbo].[PS_TelefoniaRetorno]    Committed by VersionSQL https://www.versionsql.com ******/

CREATE PROCEDURE [dbo].[PS_TelefoniaRetorno]
AS
BEGIN
	SET NOCOUNT ON;
	
	--Vincular a gravação x ocorrência no CRM
	update CRMChamadoOcorrencia
	set cocProtocoloPABX = T1.treUniqueID
	from TelefoniaRetorno T1
	where CRMChamadoOcorrencia.cocProtocolo = T1.cocProtocolo
	and T1.treDialedTime is not null
	and T1.treProcessado = 0
	and cocProtocoloPABX is null
	
	update TelefoniaRetorno
	set treProcessado = 1
	where treProcessado = 0
END
