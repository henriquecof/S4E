/****** Object:  View [dbo].[Comentario_Autorizacao_Agenda]    Committed by VersionSQL https://www.versionsql.com ******/

create View [dbo].[Comentario_Autorizacao_Agenda]
As
Select cd_sequencial, cd_sequencial_agenda, ds_comentario from comentario where cd_sequencial_agenda is not null
