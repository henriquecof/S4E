/****** Object:  Table [dbo].[CampanhaLote]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CampanhaLote](
	[cd_campanha_lote] [int] IDENTITY(1,1) NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
	[dt_cadastro] [datetime] NOT NULL,
	[dt_inicio] [date] NULL,
	[dt_fim] [date] NULL,
	[hr_inicio] [smallint] NULL,
	[hr_fim] [smallint] NULL,
	[qt_total] [int] NOT NULL,
	[qt_positivo] [int] NOT NULL,
	[qt_negativo] [int] NOT NULL,
	[qt_neutro] [int] NOT NULL,
	[cd_campanha_tipo_modulo] [tinyint] NOT NULL,
 CONSTRAINT [PK_CampanhaLote] PRIMARY KEY CLUSTERED 
(
	[cd_campanha_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CampanhaLote] ON [dbo].[CampanhaLote]
(
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLote_1] ON [dbo].[CampanhaLote]
(
	[dt_inicio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLote_2] ON [dbo].[CampanhaLote]
(
	[dt_fim] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CampanhaLote_3] ON [dbo].[CampanhaLote]
(
	[cd_campanha_tipo_modulo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CampanhaLote]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLote_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[CampanhaLote] CHECK CONSTRAINT [FK_CampanhaLote_Campanha]
ALTER TABLE [dbo].[CampanhaLote]  WITH NOCHECK ADD  CONSTRAINT [FK_CampanhaLote_CampanhaTipoModulo] FOREIGN KEY([cd_campanha_tipo_modulo])
REFERENCES [dbo].[CampanhaTipoModulo] ([cd_campanha_tipo_modulo])
ALTER TABLE [dbo].[CampanhaLote] CHECK CONSTRAINT [FK_CampanhaLote_CampanhaTipoModulo]
