/****** Object:  Table [dbo].[CampanhaRenitencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CampanhaRenitencia](
	[creId] [int] IDENTITY(1,1) NOT NULL,
	[cd_campanha] [smallint] NOT NULL,
	[cd_campanha_lote] [int] NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[chaId] [int] NOT NULL,
	[creDtCadastro] [datetime] NOT NULL,
	[creDtPrevisaoRetorno] [datetime] NOT NULL,
	[creDtRetorno] [datetime] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial_dep] [int] NULL,
	[cd_empresa] [int] NULL,
	[mdeId] [smallint] NOT NULL,
	[cd_filial] [int] NULL,
	[cd_funcionario] [bit] NULL,
 CONSTRAINT [PK_CampanhaRenitencia] PRIMARY KEY CLUSTERED 
(
	[creId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_CampanhaRenitencia] ON [dbo].[CampanhaRenitencia]
(
	[cd_funcionarioCadastro] ASC,
	[creDtPrevisaoRetorno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_ASSOCIADOS] FOREIGN KEY([cd_associado])
REFERENCES [dbo].[ASSOCIADOS] ([cd_associado])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_ASSOCIADOS]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_Campanha] FOREIGN KEY([cd_campanha])
REFERENCES [dbo].[Campanha] ([cd_campanha])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_Campanha]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_CampanhaLote] FOREIGN KEY([cd_campanha_lote])
REFERENCES [dbo].[CampanhaLote] ([cd_campanha_lote])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_CampanhaLote]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_Centro_Custo]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_CRMChamado] FOREIGN KEY([chaId])
REFERENCES [dbo].[CRMChamado] ([chaId])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_CRMChamado]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_CRMMotivoDetalhado] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_CRMMotivoDetalhado]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_DEPENDENTES]
ALTER TABLE [dbo].[CampanhaRenitencia]  WITH CHECK ADD  CONSTRAINT [FK_CampanhaRenitencia_FUNCIONARIO] FOREIGN KEY([cd_funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[CampanhaRenitencia] CHECK CONSTRAINT [FK_CampanhaRenitencia_FUNCIONARIO]
