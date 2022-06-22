/****** Object:  Table [dbo].[cm_vendedor]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[cm_vendedor](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NOT NULL,
	[cd_parcela] [nvarchar](50) NOT NULL,
	[perc_pagamento] [money] NOT NULL,
	[fl_vendedor_reteu] [bit] NOT NULL,
	[cd_tipo_comissao] [smallint] NOT NULL,
	[cd_empresa] [int] NULL,
	[cd_periodicidade] [smallint] NOT NULL,
	[cd_tipo_pagamento] [int] NULL,
	[tp_empresa] [smallint] NULL,
	[cd_plano] [int] NULL,
	[dt_assinatura_contrato_inicial] [date] NULL,
	[dt_assinatura_contrato_final] [date] NULL,
	[dia_assinatura] [int] NULL,
	[fl_mostra_plataforma] [smallint] NULL,
	[dt_cadastro] [datetime] NULL,
	[usuario_cadastro] [int] NULL,
	[moeda] [bit] NULL,
	[pagamentoComissao] [int] NULL,
	[cd_grupo] [int] NULL,
	[fl_grau_parentesco] [smallint] NULL,
	[cd_equipe] [int] NULL,
	[fl_vip] [smallint] NULL,
 CONSTRAINT [PK_cm_vendedor] PRIMARY KEY NONCLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_cm_vendedor] ON [dbo].[cm_vendedor]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[cm_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_cm_vendedor_Periodicidade] FOREIGN KEY([cd_periodicidade])
REFERENCES [dbo].[Periodicidade] ([cd_periodicidade])
ALTER TABLE [dbo].[cm_vendedor] CHECK CONSTRAINT [FK_cm_vendedor_Periodicidade]
ALTER TABLE [dbo].[cm_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_cm_vendedor_plano] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[cm_vendedor] CHECK CONSTRAINT [FK_cm_vendedor_plano]
ALTER TABLE [dbo].[cm_vendedor]  WITH NOCHECK ADD  CONSTRAINT [FK_cm_vendedor_Tipo_Comissao] FOREIGN KEY([cd_tipo_comissao])
REFERENCES [dbo].[Tipo_Comissao] ([cd_tipo_comissao])
ALTER TABLE [dbo].[cm_vendedor] CHECK CONSTRAINT [FK_cm_vendedor_Tipo_Comissao]
ALTER TABLE [dbo].[cm_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_cm_vendedor_tipo_empresa] FOREIGN KEY([tp_empresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[cm_vendedor] CHECK CONSTRAINT [FK_cm_vendedor_tipo_empresa]
ALTER TABLE [dbo].[cm_vendedor]  WITH CHECK ADD  CONSTRAINT [FK_cm_vendedor_tipo_pagamento] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[cm_vendedor] CHECK CONSTRAINT [FK_cm_vendedor_tipo_pagamento]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Funcionário|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'cd_funcionario'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Parcela|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'cd_parcela'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Porcentagem Pagamento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'perc_pagamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vendedor Reteu|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'fl_vendedor_reteu'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo Comissão|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'cd_tipo_comissao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'cd_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Periodicidade|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'cd_periodicidade'
EXEC sys.sp_addextendedproperty @name=N'descricao_cm_vendedor_pagamentoComissao', @value=N'0 - VALOR PAGO; 1 - VALOR PARCELA' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cm_vendedor', @level2type=N'COLUMN',@level2name=N'pagamentoComissao'
