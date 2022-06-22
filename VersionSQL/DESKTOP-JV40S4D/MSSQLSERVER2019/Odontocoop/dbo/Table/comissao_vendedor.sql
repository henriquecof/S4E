/****** Object:  Table [dbo].[comissao_vendedor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[comissao_vendedor](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_dependente] [int] NULL,
	[cd_parcela_comissao] [int] NOT NULL,
	[cd_sequencial_mensalidade_planos] [bigint] NULL,
	[cd_funcionario] [int] NOT NULL,
	[valor] [money] NOT NULL,
	[perc_pagamento] [float] NOT NULL,
	[fl_vendedor_reteu] [bit] NOT NULL,
	[dt_inclusao] [smalldatetime] NOT NULL,
	[cd_sequencial_lote] [int] NULL,
	[dt_exclusao] [datetime] NULL,
	[cd_orcamento] [int] NULL,
	[cd_empresa] [bigint] NULL,
	[cd_parcela] [int] NULL,
	[nr_vidas] [int] NULL,
	[fl_vitalicio] [bit] NULL,
	[cd_sequencial_origem] [int] NULL,
	[id_debito] [int] NULL,
	[id_credito] [int] NULL,
	[cd_parcela_imp] [int] NULL,
	[fl_mostra_plataforma] [smallint] NULL,
	[cd_func_adesionista_cv] [int] NULL,
	[pagamentoComissao] [int] NULL,
	[moeda] [bit] NULL,
	[valor_old] [money] NULL,
 CONSTRAINT [PK_comissao_vendedor] PRIMARY KEY NONCLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_comissao_vendedor_7_65395998__K2_K5_K4] ON [dbo].[comissao_vendedor]
(
	[cd_sequencial_dependente] ASC,
	[cd_funcionario] ASC,
	[cd_sequencial_mensalidade_planos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_comissao_vendedor] ON [dbo].[comissao_vendedor]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_comissao_vendedor_1] ON [dbo].[comissao_vendedor]
(
	[cd_sequencial_dependente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_comissao_vendedor_2] ON [dbo].[comissao_vendedor]
(
	[cd_sequencial_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_comissao_vendedor_3] ON [dbo].[comissao_vendedor]
(
	[cd_sequencial_mensalidade_planos] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_comissao_vendedor_comissao_vendedor] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[comissao_vendedor] ([cd_sequencial])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_comissao_vendedor]
ALTER TABLE [dbo].[comissao_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_comissao_vendedor_DEPENDENTES] FOREIGN KEY([cd_sequencial_dependente])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_DEPENDENTES]
ALTER TABLE [dbo].[comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_comissao_vendedor_EMPRESA] FOREIGN KEY([cd_empresa])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ON UPDATE CASCADE
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_EMPRESA]
ALTER TABLE [dbo].[comissao_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_comissao_vendedor_FUNCIONARIO] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_FUNCIONARIO]
ALTER TABLE [dbo].[comissao_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_comissao_vendedor_lote_comissao] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[lote_comissao] ([cd_sequencial])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_lote_comissao]
ALTER TABLE [dbo].[comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_comissao_vendedor_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_MENSALIDADES]
ALTER TABLE [dbo].[comissao_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_comissao_vendedor_Mensalidades_Planos] FOREIGN KEY([cd_sequencial_mensalidade_planos])
REFERENCES [dbo].[Mensalidades_Planos] ([cd_sequencial])
ALTER TABLE [dbo].[comissao_vendedor] CHECK CONSTRAINT [FK_comissao_vendedor_Mensalidades_Planos]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Comissão Vendedor' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_sequencial'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dependente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_sequencial_dependente'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcela Comissão|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_parcela_comissao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Mensalidade|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_sequencial_mensalidade_planos'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionário|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_funcionario'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Pagamento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'valor'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcela Pagamento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'perc_pagamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendedor RETEU|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'fl_vendedor_reteu'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Inclusao|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'dt_inclusao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Lote|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'cd_sequencial_lote'
EXEC sys.sp_addextendedproperty @name=N'descricao_comissao_vendedor_pagamentoComissao', @value=N'0 - VALOR PAGO; 1 - VALOR PARCELA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'comissao_vendedor', @level2type=N'COLUMN',@level2name=N'pagamentoComissao'
