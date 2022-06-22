/****** Object:  Table [dbo].[TB_FormaLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_FormaLancamento](
	[Sequencial_FormaLancamento] [int] IDENTITY(1,1) NOT NULL,
	[Tipo_ContaLancamento] [smallint] NOT NULL,
	[Forma_Lancamento] [smallint] NOT NULL,
	[Valor_Lancamento] [decimal](18, 2) NULL,
	[Valor_Previsto] [decimal](18, 2) NULL,
	[Data_Documento] [datetime] NOT NULL,
	[Data_pagamento] [datetime] NULL,
	[Data_Lancamento] [datetime] NULL,
	[Data_HoraLancamento] [datetime] NOT NULL,
	[Sequencial_Lancamento] [int] NOT NULL,
	[SequencialCartao_Car] [int] NULL,
	[Sequencial_Historico] [int] NULL,
	[Sequencial_Historico_Consulta] [int] NULL,
	[nome_usuario] [varchar](20) NULL,
	[Sequencial_FormaLancamento_Vale] [int] NULL,
	[Imprimir_lancamento] [smallint] NULL,
	[Sequencial_HistoricoVale] [int] NULL,
	[Conta_PrevistaAparecer] [smallint] NULL,
	[Sequencial_Cartao] [int] NULL,
	[Origem_Cartao] [smallint] NULL,
	[Data_Efetiva_Cartao] [datetime] NULL,
	[DOC] [varchar](36) NULL,
	[CODAUT] [varchar](20) NULL,
	[CV] [varchar](9) NULL,
	[Numero_Documento] [varchar](500) NULL,
	[Lancamento_Automatico] [smallint] NULL,
	[Controlar_Chegada_Conta] [smallint] NULL,
	[Conta_Chegou] [smallint] NULL,
	[cd_sequencial_malote] [int] NULL,
	[fl_AlteraValorPrev] [bit] NULL,
	[valorMulta] [money] NULL,
	[percMulta] [money] NULL,
	[valorJuros] [money] NULL,
	[percJuros] [money] NULL,
	[valorTaxaAdministracao] [money] NULL,
	[percTaxaAdministracao] [money] NULL,
	[valorTaxaAntecipacao] [money] NULL,
	[percTaxaAntecipacao] [money] NULL,
	[Fl_Conciliado] [tinyint] NULL,
	[lccId] [int] NULL,
	[idLoteMicroCredito] [int] NULL,
	[lccErroConciliacao] [varchar](500) NULL,
	[lccRequisicao] [varchar](50) NULL,
	[nrParcelaLoteC] [smallint] NULL,
	[pagamentoId] [varchar](36) NULL,
	[contaAuditadaContabilidade] [bit] NULL,
 CONSTRAINT [PK_TB_FormaLancamento] PRIMARY KEY NONCLUSTERED 
(
	[Sequencial_FormaLancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_TB_FormaLancamento_34_1697961671__K10_K12_K7_K2_6_8_9] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_Lancamento] ASC,
	[Sequencial_Historico] ASC,
	[Data_pagamento] ASC,
	[Tipo_ContaLancamento] ASC
)
INCLUDE([Data_Documento],[Data_Lancamento],[Data_HoraLancamento]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_TB_FormaLancamento_7_255964634__K10_K7] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_Lancamento] ASC,
	[Data_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_TB_FormaLancamento_8_1689577603__K10_K12] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_Lancamento] ASC,
	[Sequencial_Historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_Lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento_1] ON [dbo].[TB_FormaLancamento]
(
	[Data_Documento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento_2] ON [dbo].[TB_FormaLancamento]
(
	[Tipo_ContaLancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento_3] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_Lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento_4] ON [dbo].[TB_FormaLancamento]
(
	[Sequencial_FormaLancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_FormaLancamento_5] ON [dbo].[TB_FormaLancamento]
(
	[Data_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH CHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_Lote_PagamentoProducaoMicroCredito] FOREIGN KEY([idLoteMicroCredito])
REFERENCES [dbo].[Lote_PagamentoProducaoMicroCredito] ([id])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_Lote_PagamentoProducaoMicroCredito]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_TB_FormaLancamento] FOREIGN KEY([Sequencial_FormaLancamento_Vale])
REFERENCES [dbo].[TB_FormaLancamento] ([Sequencial_FormaLancamento])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_TB_FormaLancamento]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_TB_HistoricoMovimentacao] FOREIGN KEY([Sequencial_Historico])
REFERENCES [dbo].[TB_HistoricoMovimentacao] ([Sequencial_Historico])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_TB_HistoricoMovimentacao]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_TB_HistoricoMovimentacao1] FOREIGN KEY([Sequencial_Historico_Consulta])
REFERENCES [dbo].[TB_HistoricoMovimentacao] ([Sequencial_Historico])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_TB_HistoricoMovimentacao1]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_TB_Lancamento]
ALTER TABLE [dbo].[TB_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_FormaLancamento_TB_Malote] FOREIGN KEY([cd_sequencial_malote])
REFERENCES [dbo].[TB_Malote] ([cd_sequencial_malote])
ALTER TABLE [dbo].[TB_FormaLancamento] CHECK CONSTRAINT [FK_TB_FormaLancamento_TB_Malote]
