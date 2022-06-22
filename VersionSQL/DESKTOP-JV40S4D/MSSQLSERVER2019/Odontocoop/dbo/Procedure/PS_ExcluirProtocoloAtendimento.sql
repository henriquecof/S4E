/****** Object:  Procedure [dbo].[PS_ExcluirProtocoloAtendimento]    Committed by VersionSQL https://www.versionsql.com ******/

--**********************

CREATE Procedure [dbo].[PS_ExcluirProtocoloAtendimento]
As
Begin
delete ProtocoloAtendimento where datediff(day,patDtCadastro,getdate()) > 0
End


--**********************
