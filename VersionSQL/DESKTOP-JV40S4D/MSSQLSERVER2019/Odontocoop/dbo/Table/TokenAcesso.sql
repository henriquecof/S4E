/****** Object:  Table [dbo].[TokenAcesso]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TokenAcesso](
	[token] [uniqueidentifier] NOT NULL,
	[idTokenCredencial] [int] NOT NULL,
	[idTokenChavePublica] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[dataValidade] [datetime] NOT NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_TokenAcesso_1] PRIMARY KEY CLUSTERED 
(
	[token] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TokenAcesso]  WITH CHECK ADD  CONSTRAINT [FK_TokenAcesso_TokenChavePublica] FOREIGN KEY([idTokenChavePublica])
REFERENCES [dbo].[TokenChavePublica] ([id])
ALTER TABLE [dbo].[TokenAcesso] CHECK CONSTRAINT [FK_TokenAcesso_TokenChavePublica]
ALTER TABLE [dbo].[TokenAcesso]  WITH CHECK ADD  CONSTRAINT [FK_TokenAcesso_TokenCredencial] FOREIGN KEY([idTokenCredencial])
REFERENCES [dbo].[TokenCredencial] ([id])
ALTER TABLE [dbo].[TokenAcesso] CHECK CONSTRAINT [FK_TokenAcesso_TokenCredencial]
ALTER TABLE [dbo].[TokenAcesso]  WITH CHECK ADD  CONSTRAINT [FK_TokenAcesso_TokenCredencial1] FOREIGN KEY([idTokenCredencial])
REFERENCES [dbo].[TokenCredencial] ([id])
ALTER TABLE [dbo].[TokenAcesso] CHECK CONSTRAINT [FK_TokenAcesso_TokenCredencial1]
