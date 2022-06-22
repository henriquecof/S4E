/****** Object:  Table [dbo].[tbLOGDesmarcacaoConsulta]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[tbLOGDesmarcacaoConsulta](
	[ldcId] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario_desmarcacao] [int] NULL,
	[cd_associado_desmarcacao] [int] NULL,
	[cd_sequencial_dep_desmarcacao] [int] NULL,
	[cd_empresa_desmarcacao] [int] NULL,
	[cd_associado] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_sequencial_agenda] [int] NOT NULL,
	[dt_compromisso] [datetime] NOT NULL,
	[hr_compromisso] [int] NOT NULL,
	[ldcDtLOG] [datetime] NOT NULL,
	[cd_filial] [int] NULL,
	[cd_funcionario_dentista] [int] NULL,
	[motivo_desmarcacao] [varchar](500) NULL,
 CONSTRAINT [PK_LOGDesmarcacaoConsulta] PRIMARY KEY CLUSTERED 
(
	[ldcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_LOGDesmarcacaoConsulta] ON [dbo].[tbLOGDesmarcacaoConsulta]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_LOGDesmarcacaoConsulta_1] ON [dbo].[tbLOGDesmarcacaoConsulta]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
