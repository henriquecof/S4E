/****** Object:  Table [dbo].[GTOOcorrencias]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GTOOcorrencias](
	[gocId] [int] IDENTITY(1,1) NOT NULL,
	[gloId] [int] NOT NULL,
	[gocOcorrencia] [varchar](1000) NOT NULL,
	[gocDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[gocDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_GTOOcorrencias] PRIMARY KEY CLUSTERED 
(
	[gocId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_GTOOcorrencias_gloId] ON [dbo].[GTOOcorrencias]
(
	[gloId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[GTOOcorrencias]  WITH CHECK ADD  CONSTRAINT [FK_GTOOcorrencias_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GTOOcorrencias] CHECK CONSTRAINT [FK_GTOOcorrencias_FUNCIONARIO]
ALTER TABLE [dbo].[GTOOcorrencias]  WITH CHECK ADD  CONSTRAINT [FK_GTOOcorrencias_FUNCIONARIO1] FOREIGN KEY([cd_funcionarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[GTOOcorrencias] CHECK CONSTRAINT [FK_GTOOcorrencias_FUNCIONARIO1]
ALTER TABLE [dbo].[GTOOcorrencias]  WITH CHECK ADD  CONSTRAINT [FK_GTOOcorrencias_GTOLote] FOREIGN KEY([gloId])
REFERENCES [dbo].[GTOLote] ([gloId])
ALTER TABLE [dbo].[GTOOcorrencias] CHECK CONSTRAINT [FK_GTOOcorrencias_GTOLote]
