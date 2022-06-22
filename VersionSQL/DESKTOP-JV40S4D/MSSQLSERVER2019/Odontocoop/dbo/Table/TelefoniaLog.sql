/****** Object:  Table [dbo].[TelefoniaLog]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TelefoniaLog](
	[tloId] [int] IDENTITY(1,1) NOT NULL,
	[ttlId] [tinyint] NOT NULL,
	[traId] [int] NULL,
	[tfiId] [int] NULL,
	[tmpId] [tinyint] NULL,
	[cd_funcionarioOperacao] [int] NULL,
	[tloDtCadastro] [datetime] NOT NULL,
	[tloIP] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TelefoniaLog] PRIMARY KEY CLUSTERED 
(
	[tloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TelefoniaLog]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaLog_TelefoniaFila] FOREIGN KEY([tfiId])
REFERENCES [dbo].[TelefoniaFila] ([tfiId])
ALTER TABLE [dbo].[TelefoniaLog] CHECK CONSTRAINT [FK_TelefoniaLog_TelefoniaFila]
ALTER TABLE [dbo].[TelefoniaLog]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaLog_TelefoniaMotivoPausa] FOREIGN KEY([tmpId])
REFERENCES [dbo].[TelefoniaMotivoPausa] ([tmpId])
ALTER TABLE [dbo].[TelefoniaLog] CHECK CONSTRAINT [FK_TelefoniaLog_TelefoniaMotivoPausa]
ALTER TABLE [dbo].[TelefoniaLog]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaLog_TelefoniaRamal] FOREIGN KEY([traId])
REFERENCES [dbo].[TelefoniaRamal] ([traId])
ALTER TABLE [dbo].[TelefoniaLog] CHECK CONSTRAINT [FK_TelefoniaLog_TelefoniaRamal]
ALTER TABLE [dbo].[TelefoniaLog]  WITH CHECK ADD  CONSTRAINT [FK_TelefoniaLog_TelefoniaTipoLog] FOREIGN KEY([ttlId])
REFERENCES [dbo].[TelefoniaTipoLog] ([ttlId])
ALTER TABLE [dbo].[TelefoniaLog] CHECK CONSTRAINT [FK_TelefoniaLog_TelefoniaTipoLog]
