/****** Object:  Table [dbo].[preco_plano]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[preco_plano](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_plano] [int] NOT NULL,
	[cd_empresa] [int] NOT NULL,
	[dt_Inicio] [datetime] NOT NULL,
	[dt_fim_comercializacao] [datetime] NULL,
	[Vl_tit] [money] NOT NULL,
	[Vl_dep] [money] NULL,
	[fl_exige_adesao] [bit] NOT NULL,
	[fl_valor_fixo] [bit] NOT NULL,
	[vl_base_comissao_tit] [money] NULL,
	[vl_base_comissao_dep] [money] NULL,
	[Vl_adesao_tit] [money] NULL,
	[Vl_adesao_dep] [money] NULL,
	[qt_dias_adesao] [int] NULL,
	[cd_tipo_pagamento_adesao] [int] NULL,
	[fl_inativo] [smallint] NULL,
	[fl_altera_precopre] [bit] NULL,
	[qt_parcelas_anual] [smallint] NULL,
	[id_reajuste] [int] NULL,
	[nr_contrato_plano] [varchar](50) NULL,
	[vl_agregado] [money] NULL,
	[vl_dep1] [money] NULL,
	[vl_dep2] [money] NULL,
	[vl_dep3] [money] NULL,
	[vl_dep4] [money] NULL,
	[vl_dep5] [money] NULL,
	[dt_suspensao] [datetime] NULL,
	[dt_assinaturaContrato_pp] [date] NULL,
	[moedaParticipacaoEmpresaTitular] [bit] NULL,
	[valorParticipacaoEmpresaTitular] [money] NULL,
	[moedaParticipacaoEmpresaDependente] [bit] NULL,
	[valorParticipacaoEmpresaDependente] [money] NULL,
	[moedaParticipacaoEmpresaAgregado] [bit] NULL,
	[valorParticipacaoEmpresaAgregado] [money] NULL,
	[isento_pagamento] [int] NULL,
	[clausula] [varchar](50) NULL,
	[flMigracao] [int] NULL,
	[migracaoIdadeLimite] [int] NULL,
	[migracaoCdPlano] [int] NULL,
	[vl_titular_net] [money] NULL,
	[vl_dependente_net] [money] NULL,
	[vl_agregado_net] [money] NULL,
 CONSTRAINT [PK_preco_empresa] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_preco_empresa] ON [dbo].[preco_plano]
(
	[cd_empresa] ASC,
	[Vl_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_preco_plano] ON [dbo].[preco_plano]
(
	[cd_empresa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_preco_plano_1] ON [dbo].[preco_plano]
(
	[cd_plano] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[preco_plano] ADD  CONSTRAINT [DF_preco_empresa_dt_preco]  DEFAULT (getdate()) FOR [dt_Inicio]
ALTER TABLE [dbo].[preco_plano] ADD  CONSTRAINT [DF_preco_plano_fl_exige_adesao]  DEFAULT ((0)) FOR [fl_exige_adesao]
ALTER TABLE [dbo].[preco_plano]  WITH NOCHECK ADD  CONSTRAINT [FK_preco_plano_PLANOS] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[preco_plano] CHECK CONSTRAINT [FK_preco_plano_PLANOS]
ALTER TABLE [dbo].[preco_plano]  WITH CHECK ADD  CONSTRAINT [FK_preco_plano_reajuste] FOREIGN KEY([id_reajuste])
REFERENCES [dbo].[reajuste] ([id_reajuste])
ALTER TABLE [dbo].[preco_plano] CHECK CONSTRAINT [FK_preco_plano_reajuste]
ALTER TABLE [dbo].[preco_plano]  WITH NOCHECK ADD  CONSTRAINT [FK_preco_plano_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento_adesao])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[preco_plano] CHECK CONSTRAINT [FK_preco_plano_TIPO_PAGAMENTO]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Plano|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'cd_plano'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'cd_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Inicial|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'dt_Inicio'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Final|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'dt_fim_comercializacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Titular|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'Vl_tit'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Dependente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'Vl_dep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Titular|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'Vl_adesao_tit'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Dependente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'preco_plano', @level2type=N'COLUMN',@level2name=N'Vl_adesao_dep'
