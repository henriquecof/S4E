/****** Object:  Table [dbo].[OdontogramaSituacaoInicial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[OdontogramaSituacaoInicial](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_sequencialConsulta] [int] NULL,
	[doencaPeriodontal] [bit] NULL,
	[alteracaoTecidosMoles] [bit] NULL,
	[observacao] [varchar](1000) NULL,
	[dataCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioDentista] [int] NOT NULL,
	[cd_filial] [int] NOT NULL,
	[dente11] [varchar](10) NULL,
	[dente12] [varchar](10) NULL,
	[dente13] [varchar](10) NULL,
	[dente14] [varchar](10) NULL,
	[dente15] [varchar](10) NULL,
	[dente16] [varchar](10) NULL,
	[dente17] [varchar](10) NULL,
	[dente18] [varchar](10) NULL,
	[dente21] [varchar](10) NULL,
	[dente22] [varchar](10) NULL,
	[dente23] [varchar](10) NULL,
	[dente24] [varchar](10) NULL,
	[dente25] [varchar](10) NULL,
	[dente26] [varchar](10) NULL,
	[dente27] [varchar](10) NULL,
	[dente28] [varchar](10) NULL,
	[dente51] [varchar](10) NULL,
	[dente52] [varchar](10) NULL,
	[dente53] [varchar](10) NULL,
	[dente54] [varchar](10) NULL,
	[dente55] [varchar](10) NULL,
	[dente61] [varchar](10) NULL,
	[dente62] [varchar](10) NULL,
	[dente63] [varchar](10) NULL,
	[dente64] [varchar](10) NULL,
	[dente65] [varchar](10) NULL,
	[dente81] [varchar](10) NULL,
	[dente82] [varchar](10) NULL,
	[dente83] [varchar](10) NULL,
	[dente84] [varchar](10) NULL,
	[dente85] [varchar](10) NULL,
	[dente71] [varchar](10) NULL,
	[dente72] [varchar](10) NULL,
	[dente73] [varchar](10) NULL,
	[dente74] [varchar](10) NULL,
	[dente75] [varchar](10) NULL,
	[dente41] [varchar](10) NULL,
	[dente42] [varchar](10) NULL,
	[dente43] [varchar](10) NULL,
	[dente44] [varchar](10) NULL,
	[dente45] [varchar](10) NULL,
	[dente46] [varchar](10) NULL,
	[dente47] [varchar](10) NULL,
	[dente48] [varchar](10) NULL,
	[dente31] [varchar](10) NULL,
	[dente32] [varchar](10) NULL,
	[dente33] [varchar](10) NULL,
	[dente34] [varchar](10) NULL,
	[dente35] [varchar](10) NULL,
	[dente36] [varchar](10) NULL,
	[dente37] [varchar](10) NULL,
	[dente38] [varchar](10) NULL,
	[necessidadeOrtodontia] [bit] NULL,
 CONSTRAINT [PK_OdontogramaSituacaoInicial] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_cd_filial] ON [dbo].[OdontogramaSituacaoInicial]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_funcionarioDentista] ON [dbo].[OdontogramaSituacaoInicial]
(
	[cd_funcionarioDentista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_sequencial_dep] ON [dbo].[OdontogramaSituacaoInicial]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_cd_sequencialConsulta] ON [dbo].[OdontogramaSituacaoInicial]
(
	[cd_sequencialConsulta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[OdontogramaSituacaoInicial]  WITH CHECK ADD  CONSTRAINT [FK_OdontogramaSituacaoInicial_Consultas] FOREIGN KEY([cd_sequencialConsulta])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[OdontogramaSituacaoInicial] CHECK CONSTRAINT [FK_OdontogramaSituacaoInicial_Consultas]
ALTER TABLE [dbo].[OdontogramaSituacaoInicial]  WITH CHECK ADD  CONSTRAINT [FK_OdontogramaSituacaoInicial_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[OdontogramaSituacaoInicial] CHECK CONSTRAINT [FK_OdontogramaSituacaoInicial_DEPENDENTES]
ALTER TABLE [dbo].[OdontogramaSituacaoInicial]  WITH CHECK ADD  CONSTRAINT [FK_OdontogramaSituacaoInicial_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[OdontogramaSituacaoInicial] CHECK CONSTRAINT [FK_OdontogramaSituacaoInicial_FILIAL]
