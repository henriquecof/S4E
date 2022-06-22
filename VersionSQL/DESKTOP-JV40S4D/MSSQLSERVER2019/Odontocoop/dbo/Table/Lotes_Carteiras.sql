/****** Object:  Table [dbo].[Lotes_Carteiras]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lotes_Carteiras](
	[SQ_Lote] [int] IDENTITY(1,1) NOT NULL,
	[DT_Abertura] [datetime] NOT NULL,
	[DT_Fechamento] [datetime] NULL,
	[DT_Recebido] [datetime] NULL,
	[DT_Exclusao] [datetime] NULL,
	[CD_Empresa] [int] NULL,
	[CD_Grupo] [smallint] NULL,
	[nm_arquivo] [varchar](100) NULL,
	[fl_visivel] [bit] NULL,
	[Tp_empresa] [int] NULL,
	[end_LayoutCarteira] [varchar](50) NULL,
	[DT_Envio] [datetime] NULL,
	[cd_UsuarioEnvio] [int] NULL,
	[cd_UsuarioRecebimento] [int] NULL,
	[cd_usuariocadastro] [int] NULL,
	[ds_lote] [varchar](200) NULL,
 CONSTRAINT [PK_Lotes_Carteiras] PRIMARY KEY CLUSTERED 
(
	[SQ_Lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Lotes_Carteiras] ON [dbo].[Lotes_Carteiras]
(
	[DT_Abertura] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lotes_Carteiras_1] ON [dbo].[Lotes_Carteiras]
(
	[DT_Exclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lotes_Carteiras_2] ON [dbo].[Lotes_Carteiras]
(
	[DT_Fechamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lotes_Carteiras_3] ON [dbo].[Lotes_Carteiras]
(
	[CD_Empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
