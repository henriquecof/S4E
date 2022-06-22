/****** Object:  Table [dbo].[lote_contratos_contratos_vendedor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[lote_contratos_contratos_vendedor](
	[cd_sequencial_lote] [int] NOT NULL,
	[cd_contrato] [varchar](20) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[vl_contrato] [money] NULL,
	[cd_equipe] [smallint] NULL,
	[dt_cadastro] [datetime] NULL,
	[fl_excluida] [int] NULL,
	[dt_assinaturaContrato] [datetime] NULL,
	[id] [bigint] IDENTITY(1,1) NOT NULL,
	[data_horarecebimento] [datetime] NULL,
	[usuario_recebimento] [int] NULL,
	[chave] [varchar](50) NULL,
 CONSTRAINT [PK_lote_contratos_contratos_vendedor_1] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_lote] ASC,
	[cd_contrato] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_lote_contratos_contratos_vendedo_34_933890694__K1_2] ON [dbo].[lote_contratos_contratos_vendedor]
(
	[cd_sequencial_lote] ASC
)
INCLUDE([cd_contrato]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_lote_contratos_contratos_vendedo_34_933890694__K1_K2_K3_4_6] ON [dbo].[lote_contratos_contratos_vendedor]
(
	[cd_sequencial_lote] ASC,
	[cd_contrato] ASC,
	[cd_sequencial_dep] ASC
)
INCLUDE([vl_contrato],[dt_cadastro]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_lote_contratos_contratos_vendedo_34_933890694__K1_K3_K2] ON [dbo].[lote_contratos_contratos_vendedor]
(
	[cd_sequencial_lote] ASC,
	[cd_sequencial_dep] ASC,
	[cd_contrato] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_contratos_contratos_vendedor] ON [dbo].[lote_contratos_contratos_vendedor]
(
	[cd_equipe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_contratos_contratos_vendedor_1] ON [dbo].[lote_contratos_contratos_vendedor]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_lote_contratos_contratos_vendedor_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor] CHECK CONSTRAINT [FK_lote_contratos_contratos_vendedor_DEPENDENTES]
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_lote_contratos_contratos_vendedor_equipe_vendas] FOREIGN KEY([cd_equipe])
REFERENCES [dbo].[equipe_vendas] ([cd_equipe])
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor] CHECK CONSTRAINT [FK_lote_contratos_contratos_vendedor_equipe_vendas]
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_lote_contratos_contratos_vendedor_lote_contratos] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[lote_contratos] ([cd_sequencial])
ALTER TABLE [dbo].[lote_contratos_contratos_vendedor] CHECK CONSTRAINT [FK_lote_contratos_contratos_vendedor_lote_contratos]
