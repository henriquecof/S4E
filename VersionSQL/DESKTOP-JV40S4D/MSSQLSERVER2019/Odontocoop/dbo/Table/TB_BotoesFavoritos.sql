/****** Object:  Table [dbo].[TB_BotoesFavoritos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_BotoesFavoritos](
	[cd_funcionario] [int] NOT NULL,
	[tpsId] [smallint] NOT NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_BotoesFavoritos]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_BotoesFavoritos_TipoPermissaoSistema] FOREIGN KEY([tpsId])
REFERENCES [dbo].[TipoPermissaoSistema] ([tpsId])
ALTER TABLE [dbo].[TB_BotoesFavoritos] CHECK CONSTRAINT [FK_TB_BotoesFavoritos_TipoPermissaoSistema]
