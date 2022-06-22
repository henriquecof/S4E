/****** Object:  Table [dbo].[GrupoProcedimentoPlano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[GrupoProcedimentoPlano](
	[gppId] [int] IDENTITY(1,1) NOT NULL,
	[gprId] [smallint] NOT NULL,
	[cd_plano] [int] NOT NULL,
	[gppDiasCarencia] [smallint] NOT NULL,
	[gppDtCadastro] [datetime] NOT NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[gppDtExclusao] [datetime] NULL,
	[cd_funcionarioExclusao] [int] NULL,
 CONSTRAINT [PK_GrupoProcedimentoPlano] PRIMARY KEY CLUSTERED 
(
	[gppId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoPlano] ON [dbo].[GrupoProcedimentoPlano]
(
	[gprId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoPlano_1] ON [dbo].[GrupoProcedimentoPlano]
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_GrupoProcedimentoPlano_2] ON [dbo].[GrupoProcedimentoPlano]
(
	[gprId] ASC,
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[GrupoProcedimentoPlano]  WITH CHECK ADD  CONSTRAINT [FK_GrupoProcedimentoPlano_GrupoProcedimento] FOREIGN KEY([gprId])
REFERENCES [dbo].[GrupoProcedimento] ([gprId])
ALTER TABLE [dbo].[GrupoProcedimentoPlano] CHECK CONSTRAINT [FK_GrupoProcedimentoPlano_GrupoProcedimento]
ALTER TABLE [dbo].[GrupoProcedimentoPlano]  WITH CHECK ADD  CONSTRAINT [FK_GrupoProcedimentoPlano_PLANOS] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[GrupoProcedimentoPlano] CHECK CONSTRAINT [FK_GrupoProcedimentoPlano_PLANOS]
