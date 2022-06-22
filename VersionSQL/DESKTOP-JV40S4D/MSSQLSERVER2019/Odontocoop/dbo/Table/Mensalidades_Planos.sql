/****** Object:  Table [dbo].[Mensalidades_Planos]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Mensalidades_Planos](
	[cd_sequencial] [bigint] IDENTITY(1,1) NOT NULL,
	[cd_parcela_mensalidade] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_plano] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_funcionario_exclusao] [int] NULL,
	[cd_empresa_filha] [int] NULL,
	[cd_tipo_parcela] [smallint] NULL,
	[id_mensalidade_avulsa] [int] NULL,
	[cd_sequencial_consulta] [int] NULL,
	[valorPago] [money] NULL,
	[vl_net] [money] NULL,
	[executarTrigger] [bit] NULL,
	[vl_dmed] [money] NULL,
	[vl_base_comissao] [money] NULL,
 CONSTRAINT [PK_Mensalidades_Planos] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_Mensalidades_Planos_7_2104863061__K2_K6_K1_K3_5] ON [dbo].[Mensalidades_Planos]
(
	[cd_parcela_mensalidade] ASC,
	[dt_exclusao] ASC,
	[cd_sequencial] ASC,
	[cd_sequencial_dep] ASC
)
INCLUDE([valor]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_CdParcela_CdPlano] ON [dbo].[Mensalidades_Planos]
(
	[cd_parcela_mensalidade] ASC,
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Mensalidades_Planos] ON [dbo].[Mensalidades_Planos]
(
	[cd_parcela_mensalidade] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Mensalidades_Planos_1] ON [dbo].[Mensalidades_Planos]
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Mensalidades_Planos_2] ON [dbo].[Mensalidades_Planos]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_mensalidades_planos_cd_sequencial_consulta] ON [dbo].[Mensalidades_Planos]
(
	[cd_sequencial_consulta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_MensalidadesPlanos_cd_sequencial_dep] ON [dbo].[Mensalidades_Planos]
(
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH CHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_cd_tipo_parcela] FOREIGN KEY([cd_tipo_parcela])
REFERENCES [dbo].[Tipo_parcela] ([cd_tipo_parcela])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_cd_tipo_parcela]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH NOCHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_DEPENDENTES]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH NOCHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_FUNCIONARIO] FOREIGN KEY([cd_funcionario_exclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_FUNCIONARIO]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH NOCHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_MENSALIDADES] FOREIGN KEY([cd_parcela_mensalidade])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_MENSALIDADES]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH CHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_Mensalidades_Avulsas] FOREIGN KEY([id_mensalidade_avulsa])
REFERENCES [dbo].[Mensalidades_Avulsas] ([id])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_Mensalidades_Avulsas]
ALTER TABLE [dbo].[Mensalidades_Planos]  WITH NOCHECK ADD  CONSTRAINT [FK_Mensalidades_Planos_Mensalidades_Planos] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[Mensalidades_Planos] CHECK CONSTRAINT [FK_Mensalidades_Planos_Mensalidades_Planos]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcela' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Mensalidades_Planos', @level2type=N'COLUMN',@level2name=N'cd_parcela_mensalidade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dependente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Mensalidades_Planos', @level2type=N'COLUMN',@level2name=N'cd_sequencial_dep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Mensalidades_Planos', @level2type=N'COLUMN',@level2name=N'valor'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Exclusão|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Mensalidades_Planos', @level2type=N'COLUMN',@level2name=N'dt_exclusao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Usuário Exclusão|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Mensalidades_Planos', @level2type=N'COLUMN',@level2name=N'cd_funcionario_exclusao'
