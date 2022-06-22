/****** Object:  Table [dbo].[Comentario]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Comentario](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_associado] [int] NOT NULL,
	[CD_TP_ASSOCIADO] [int] NOT NULL,
	[ds_comentario] [varchar](1500) NOT NULL,
	[dt_comentario] [datetime] NOT NULL,
	[cd_usuario] [varchar](50) NOT NULL,
	[cd_tp_comentario] [int] NULL,
	[cd_sequencial_agenda] [int] NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[cd_funcionario_inclusao] [int] NULL,
	[cd_status] [smallint] NULL,
	[faixa_dias_atraso] [smallint] NULL,
	[data_impressao] [datetime] NULL,
	[cd_parcela] [int] NULL,
	[sequencial] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
 CONSTRAINT [PK_Comentario] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Comentario] ON [dbo].[Comentario]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Comentario_1] ON [dbo].[Comentario]
(
	[cd_sequencial_agenda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Comentario_2] ON [dbo].[Comentario]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Comentario_3] ON [dbo].[Comentario]
(
	[dt_comentario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Comentario] ADD  CONSTRAINT [DF_Comentario_CD_TP_ASSOCIADO]  DEFAULT ((1)) FOR [CD_TP_ASSOCIADO]
ALTER TABLE [dbo].[Comentario] ADD  CONSTRAINT [DF_Comentario_dt_comentario]  DEFAULT (getdate()) FOR [dt_comentario]
