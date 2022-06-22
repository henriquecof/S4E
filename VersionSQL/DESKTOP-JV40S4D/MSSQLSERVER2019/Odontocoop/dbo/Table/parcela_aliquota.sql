/****** Object:  Table [dbo].[parcela_aliquota]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[parcela_aliquota](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[cd_aliquota] [smallint] NOT NULL,
	[vl_referencia] [money] NOT NULL,
	[perc_aliquota] [float] NOT NULL,
	[valor_aliquota] [money] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[id_retido] [tinyint] NOT NULL,
	[cd_funcionarioCadastro] [int] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_parcela_aliquota] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[cd_parcela] ASC,
	[cd_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [dta_index_parcela_aliquota] ON [dbo].[parcela_aliquota]
(
	[cd_parcela] ASC,
	[dt_exclusao] ASC,
	[cd_aliquota] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IN_ParcelaAliquotaDT_Exclusao] ON [dbo].[parcela_aliquota]
(
	[dt_exclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IN_ParcelaAliquotaID_Retido] ON [dbo].[parcela_aliquota]
(
	[id_retido] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
