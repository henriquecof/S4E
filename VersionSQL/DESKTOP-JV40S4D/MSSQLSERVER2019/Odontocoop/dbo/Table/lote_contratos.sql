/****** Object:  Table [dbo].[lote_contratos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[lote_contratos](
	[cd_sequencial] [int] NOT NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_finalizado] [datetime] NULL,
	[qt_contratos] [smallint] NULL,
	[cd_usuario_cadastro] [varchar](50) NULL,
	[vl_total] [money] NULL,
	[cd_Equipe] [smallint] NULL,
	[cd_empresa] [int] NULL,
	[data_horarecebimento] [datetime] NULL,
	[usuario_recebimento] [varchar](20) NULL,
 CONSTRAINT [PK_lote_contratos] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_lote_contratos] ON [dbo].[lote_contratos]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_contratos_1] ON [dbo].[lote_contratos]
(
	[cd_Equipe] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_contratos_2] ON [dbo].[lote_contratos]
(
	[dt_cadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[lote_contratos]  WITH NOCHECK ADD  CONSTRAINT [FK_lote_contratos_lote_contratos] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[lote_contratos] ([cd_sequencial])
ALTER TABLE [dbo].[lote_contratos] CHECK CONSTRAINT [FK_lote_contratos_lote_contratos]
