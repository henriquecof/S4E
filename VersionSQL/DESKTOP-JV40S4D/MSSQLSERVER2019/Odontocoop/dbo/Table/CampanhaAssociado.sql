/****** Object:  Table [dbo].[CampanhaAssociado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CampanhaAssociado](
	[casId] [int] IDENTITY(1,1) NOT NULL,
	[casDtCadastro] [datetime] NOT NULL,
	[cd_campanha] [smallint] NULL,
	[cd_campanha_lote] [int] NULL,
	[cd_associado] [int] NOT NULL,
	[cd_centro_custo] [smallint] NULL,
	[cd_funcionario] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
 CONSTRAINT [PK_CampanhaAssociado] PRIMARY KEY CLUSTERED 
(
	[casId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CampanhaAssociado_1] ON [dbo].[CampanhaAssociado]
(
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaAssociado_2] ON [dbo].[CampanhaAssociado]
(
	[cd_campanha_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaAssociado_3] ON [dbo].[CampanhaAssociado]
(
	[casDtCadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaAssociado_4] ON [dbo].[CampanhaAssociado]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CampanhaAssociado]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaAssociado_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[CampanhaAssociado] CHECK CONSTRAINT [FK_CampanhaAssociado_Centro_Custo]
