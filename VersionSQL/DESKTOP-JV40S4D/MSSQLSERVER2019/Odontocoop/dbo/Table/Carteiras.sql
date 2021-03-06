/****** Object:  Table [dbo].[Carteiras]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Carteiras](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[sq_lote] [int] NOT NULL,
	[cd_Associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[Cod_Carteira] [varchar](20) NULL,
	[fl_cob2via] [bit] NULL,
	[obs] [varchar](100) NULL,
	[dataEntrega] [datetime] NULL,
	[dataRecebimento] [datetime] NULL,
 CONSTRAINT [PK_Carteiras] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_Carteiras] UNIQUE NONCLUSTERED 
(
	[sq_lote] ASC,
	[cd_Associado] ASC,
	[cd_sequencial_dep] ASC,
	[dt_exclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Carteiras_1] ON [dbo].[Carteiras]
(
	[Cod_Carteira] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Carteiras_2] ON [dbo].[Carteiras]
(
	[cd_Associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Carteiras_3] ON [dbo].[Carteiras]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Carteiras]  WITH NOCHECK ADD  CONSTRAINT [FK_Carteiras_Lotes_Carteiras] FOREIGN KEY([sq_lote])
REFERENCES [dbo].[Lotes_Carteiras] ([SQ_Lote])
ALTER TABLE [dbo].[Carteiras] CHECK CONSTRAINT [FK_Carteiras_Lotes_Carteiras]
