/****** Object:  Table [dbo].[lote_comissao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[lote_comissao](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[dt_cadastro] [datetime] NULL,
	[dt_finalizado] [datetime] NULL,
	[qt_comissoes] [int] NULL,
	[cd_usuario_cadastro] [varchar](50) NULL,
	[vl_total] [money] NULL,
	[cd_funcionario] [int] NULL,
	[dt_lancamento] [datetime] NULL,
	[cd_sequencial_caixa] [int] NULL,
	[dt_base_fim] [datetime] NULL,
	[dt_base_ini] [datetime] NULL,
	[cd_tipo] [smallint] NULL,
	[dt_cancelamento] [datetime] NULL,
	[cd_usuario_cancelamento] [varchar](50) NULL,
	[motivo_cancelamento] [varchar](1000) NULL,
	[vl_total_bruto] [money] NULL,
	[dt_pgto_comissao] [date] NULL,
	[liberadoVisualizacaoVendedor] [bit] NULL,
	[usuarioLiberadoVisualizacaoVendedor] [int] NULL,
	[usuarioOcultadoVisualizacaoVendedor] [int] NULL,
	[dataLiberadoVisualizacaoVendedor] [datetime] NULL,
	[dataOcultadoVisualizacaoVendedor] [datetime] NULL,
	[executarTrigger] [bit] NULL,
 CONSTRAINT [PK_lote_comissao] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_lote_comissao] ON [dbo].[lote_comissao]
(
	[cd_funcionario] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_comissao_1] ON [dbo].[lote_comissao]
(
	[cd_sequencial_caixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_comissao_2] ON [dbo].[lote_comissao]
(
	[dt_cadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_lote_comissao_3] ON [dbo].[lote_comissao]
(
	[dt_finalizado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[lote_comissao]  WITH NOCHECK ADD  CONSTRAINT [FK_lote_comissao_FUNCIONARIO] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ON UPDATE CASCADE
ALTER TABLE [dbo].[lote_comissao] CHECK CONSTRAINT [FK_lote_comissao_FUNCIONARIO]
ALTER TABLE [dbo].[lote_comissao]  WITH CHECK ADD  CONSTRAINT [FK_lote_comissao_Funcionario11] FOREIGN KEY([usuarioLiberadoVisualizacaoVendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[lote_comissao] CHECK CONSTRAINT [FK_lote_comissao_Funcionario11]
ALTER TABLE [dbo].[lote_comissao]  WITH CHECK ADD  CONSTRAINT [FK_lote_comissao_Funcionario12] FOREIGN KEY([usuarioOcultadoVisualizacaoVendedor])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[lote_comissao] CHECK CONSTRAINT [FK_lote_comissao_Funcionario12]
