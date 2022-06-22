/****** Object:  Table [dbo].[orcamento_mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[orcamento_mensalidades](
	[cd_orcamento] [int] NOT NULL,
	[cd_associado_empresa] [int] NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[vl_parcela] [money] NULL,
	[dt_vencimento] [datetime] NULL,
	[fl_incorpora] [bit] NULL,
	[cd_tipo_pagamento] [smallint] NULL,
	[dt_lancamento_caixa] [datetime] NULL,
	[cd_sequencial_caixa] [int] NULL,
	[fl_taxa] [bit] NULL,
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[parcelaEntrada] [bit] NULL,
 CONSTRAINT [PK_orcamento_mensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades] ON [dbo].[orcamento_mensalidades]
(
	[cd_associado_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades_1] ON [dbo].[orcamento_mensalidades]
(
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades_2] ON [dbo].[orcamento_mensalidades]
(
	[cd_sequencial_caixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades_3] ON [dbo].[orcamento_mensalidades]
(
	[cd_orcamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades_4] ON [dbo].[orcamento_mensalidades]
(
	[dt_vencimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_orcamento_mensalidades_5] ON [dbo].[orcamento_mensalidades]
(
	[dt_lancamento_caixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[orcamento_mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_orcamento_mensalidades_orcamento_clinico] FOREIGN KEY([cd_orcamento])
REFERENCES [dbo].[orcamento_clinico] ([cd_orcamento])
ALTER TABLE [dbo].[orcamento_mensalidades] CHECK CONSTRAINT [FK_orcamento_mensalidades_orcamento_clinico]
