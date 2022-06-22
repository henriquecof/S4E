/****** Object:  Table [dbo].[pagamento_dentista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[pagamento_dentista](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_funcionario] [int] NULL,
	[dt_abertura] [datetime] NULL,
	[dt_fechamento] [datetime] NULL,
	[dt_previsao_pagamento] [datetime] NULL,
	[cd_sequencial_caixa] [int] NULL,
	[dt_caixa] [datetime] NULL,
	[qt_procedimentos] [int] NULL,
	[vl_parcela] [money] NULL,
	[dt_pagamento] [datetime] NULL,
	[fl_fechado] [bit] NULL,
	[vl_antesglosa] [money] NULL,
	[vl_acerto] [money] NULL,
	[motivo_acerto] [varchar](500) NULL,
	[cd_filial] [int] NULL,
	[data_impressao] [datetime] NULL,
	[data_corte] [datetime] NULL,
	[nm_arquivo] [varchar](100) NULL,
	[data_xml] [datetime] NULL,
	[cd_modelo_pgto_prestador] [smallint] NULL,
	[cd_pgto_dentista_lanc] [int] NULL,
	[usuario_abertura] [int] NULL,
	[chaId] [int] NULL,
	[cd_lote_solus] [int] NULL,
	[cd_empresa] [int] NULL,
	[nr_Lancamento] [int] NULL,
	[fl_ExibicaoDetalhada] [bit] NULL,
	[cd_centro_custo] [smallint] NULL,
	[dt_protocolo] [datetime] NULL,
	[fl_importado] [bit] NULL,
	[TipoLiberacaoVisualizacao] [tinyint] NULL,
	[dt_liberacao_visualizacao] [datetime] NULL,
	[exibir] [bit] NULL,
	[ExecutarTrigger] [bit] NULL,
	[dt_competencia_pagamento] [date] NULL,
	[cd_filialOriginal] [int] NULL,
	[tipoFaturamento] [tinyint] NULL,
	[idConvenio_ans] [int] NULL,
 CONSTRAINT [PK_pagamento_dentista] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_pagamento_dentista] ON [dbo].[pagamento_dentista]
(
	[cd_pgto_dentista_lanc] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_pagamento_dentista_2] ON [dbo].[pagamento_dentista]
(
	[cd_sequencial_caixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[pagamento_dentista]  WITH CHECK ADD  CONSTRAINT [FK_pagamento_dentista_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[pagamento_dentista] CHECK CONSTRAINT [FK_pagamento_dentista_Centro_Custo]
ALTER TABLE [dbo].[pagamento_dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_pagamento_dentista_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[pagamento_dentista] CHECK CONSTRAINT [FK_pagamento_dentista_FILIAL]
ALTER TABLE [dbo].[pagamento_dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_pagamento_dentista_Modelo_Pagamento_Prestador] FOREIGN KEY([cd_modelo_pgto_prestador])
REFERENCES [dbo].[Modelo_Pagamento_Prestador] ([cd_modelo_pgto_prestador])
ALTER TABLE [dbo].[pagamento_dentista] CHECK CONSTRAINT [FK_pagamento_dentista_Modelo_Pagamento_Prestador]
ALTER TABLE [dbo].[pagamento_dentista]  WITH NOCHECK ADD  CONSTRAINT [FK_pagamento_dentista_Pagamento_Dentista_Lancamento] FOREIGN KEY([cd_pgto_dentista_lanc])
REFERENCES [dbo].[Pagamento_Dentista_Lancamento] ([cd_pgto_dentista_lanc])
ALTER TABLE [dbo].[pagamento_dentista] CHECK CONSTRAINT [FK_pagamento_dentista_Pagamento_Dentista_Lancamento]
