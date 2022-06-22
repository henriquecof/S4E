/****** Object:  Table [dbo].[TB_ContatoAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContatoAssociado](
	[cd_associado] [int] NULL,
	[cd_empresa] [int] NULL,
	[Contato1] [varchar](100) NULL,
	[Contato2] [varchar](100) NULL,
	[Contato3] [varchar](100) NULL,
	[Contato4] [varchar](100) NULL,
	[Email] [varchar](100) NULL
) ON [PRIMARY]

CREATE CLUSTERED INDEX [IX_TB_ContatoAssociado] ON [dbo].[TB_ContatoAssociado]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_ContatoAssociado_Empresa] ON [dbo].[TB_ContatoAssociado]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_ContatoAssociado]  WITH CHECK ADD  CONSTRAINT [FK_cd_associado] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[TB_ContatoAssociado] CHECK CONSTRAINT [FK_cd_associado]
ALTER TABLE [dbo].[TB_ContatoAssociado]  WITH CHECK ADD  CONSTRAINT [FK_TB_ContatoAssociado_cd_associado] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[TB_ContatoAssociado] CHECK CONSTRAINT [FK_TB_ContatoAssociado_cd_associado]
