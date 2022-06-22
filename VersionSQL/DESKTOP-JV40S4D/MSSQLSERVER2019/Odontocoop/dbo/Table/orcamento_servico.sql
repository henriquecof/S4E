/****** Object:  Table [dbo].[orcamento_servico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[orcamento_servico](
	[cd_sequencial_pp] [int] NOT NULL,
	[fl_pp] [smallint] NOT NULL,
	[cd_orcamento] [int] NOT NULL,
	[vl_servico] [money] NULL,
	[vl_servicoFechadoOrcamento] [money] NULL,
	[dentistaAvaliador] [int] NULL,
	[parcelaProteseVinculada] [int] NULL,
 CONSTRAINT [PK_orcamento_servico] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_pp] ASC,
	[fl_pp] ASC,
	[cd_orcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_cd_sequencial_pp] ON [dbo].[orcamento_servico]
(
	[cd_sequencial_pp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_servico] ON [dbo].[orcamento_servico]
(
	[cd_orcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[orcamento_servico]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_servico_Consultas] FOREIGN KEY([cd_sequencial_pp])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[orcamento_servico] CHECK CONSTRAINT [FK_orcamento_servico_Consultas]
ALTER TABLE [dbo].[orcamento_servico]  WITH CHECK ADD  CONSTRAINT [FK_orcamento_servico_FUNCIONARIO] FOREIGN KEY([dentistaAvaliador])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[orcamento_servico] CHECK CONSTRAINT [FK_orcamento_servico_FUNCIONARIO]
ALTER TABLE [dbo].[orcamento_servico]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_servico_orcamento_clinico] FOREIGN KEY([cd_orcamento])
REFERENCES [dbo].[orcamento_clinico] ([cd_orcamento])
ALTER TABLE [dbo].[orcamento_servico] CHECK CONSTRAINT [FK_orcamento_servico_orcamento_clinico]
