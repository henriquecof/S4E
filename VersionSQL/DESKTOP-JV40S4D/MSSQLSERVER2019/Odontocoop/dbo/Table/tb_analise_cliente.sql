/****** Object:  Table [dbo].[tb_analise_cliente]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tb_analise_cliente](
	[id_analise] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[nr_autorizacao] [varchar](30) NULL,
	[dt_vencimento] [smalldatetime] NULL,
	[restricao] [varchar](500) NULL,
	[cd_sequencial_agenda] [int] NULL,
 CONSTRAINT [PK_tb_analise_cliente] PRIMARY KEY CLUSTERED 
(
	[id_analise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_tb_analise_cliente_1] ON [dbo].[tb_analise_cliente]
(
	[nr_autorizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_tb_analise_cliente_2] ON [dbo].[tb_analise_cliente]
(
	[cd_sequencial_agenda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
