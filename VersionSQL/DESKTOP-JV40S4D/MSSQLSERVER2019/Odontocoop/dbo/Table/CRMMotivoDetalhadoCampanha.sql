/****** Object:  Table [dbo].[CRMMotivoDetalhadoCampanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CRMMotivoDetalhadoCampanha](
	[mdcId] [int] IDENTITY(1,1) NOT NULL,
	[mdeId] [smallint] NOT NULL,
	[mdcQtRenitencia] [tinyint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT1] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT2] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT3] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT4] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT5] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT6] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT7] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT8] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT9] [smallint] NOT NULL,
	[mdcQtMinutosVoltaCampanhaT10] [smallint] NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
 CONSTRAINT [PK_MotivoDetalhadoRenitencia] PRIMARY KEY CLUSTERED 
(
	[mdcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhadoCampanha] ON [dbo].[CRMMotivoDetalhadoCampanha]
(
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhadoCampanha_1] ON [dbo].[CRMMotivoDetalhadoCampanha]
(
	[mdeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CRMMotivoDetalhadoCampanha_2] ON [dbo].[CRMMotivoDetalhadoCampanha]
(
	[mdeId] ASC,
	[cd_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CRMMotivoDetalhadoCampanha]  WITH CHECK ADD  CONSTRAINT [FK_MotivoDetalhadoCampanha_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[CRMMotivoDetalhadoCampanha] CHECK CONSTRAINT [FK_MotivoDetalhadoCampanha_Campanha]
ALTER TABLE [dbo].[CRMMotivoDetalhadoCampanha]  WITH CHECK ADD  CONSTRAINT [FK_MotivoDetalhadoCampanha_CRMMotivoDetalhado] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[CRMMotivoDetalhadoCampanha] CHECK CONSTRAINT [FK_MotivoDetalhadoCampanha_CRMMotivoDetalhado]
