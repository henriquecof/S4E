/****** Object:  Procedure [dbo].[PS_QuestionarioExame]    Committed by VersionSQL https://www.versionsql.com ******/

create PROCEDURE [dbo].[PS_QuestionarioExame]
AS
Begin
	update agenda
	set fl_QuestionarioExame = 1
	where convert(varchar(10),dt_compromisso,103) = convert(varchar(10),getdate(),103)
	and cd_associado is not null
	and (select count(0) from consultas where cd_associado = agenda.cd_associado and cd_sequencial_dep = agenda.cd_sequencial_dep and dt_cancelamento is null and dt_servico is null) = 0
End
