/****** Object:  Table [dbo].[TB_Lancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Lancamento](
	[Sequencial_Lancamento] [int] IDENTITY(1,1) NOT NULL,
	[Tipo_Lancamento] [smallint] NOT NULL,
	[Historico] [varchar](1500) NULL,
	[Sequencial_Conta] [int] NULL,
	[cd_fornecedor] [int] NULL,
	[cd_funcionario] [int] NULL,
	[cd_associado] [int] NULL,
	[cd_sequencial] [int] NULL,
	[cd_dentista] [int] NULL,
	[cd_associadoempresa] [int] NULL,
	[nome_outros] [varchar](200) NULL,
	[nome_usuario] [varchar](200) NULL,
	[Data_HoraExclusao] [datetime] NULL,
	[Numero_Vias] [int] NULL,
	[Mensagem_Delecao] [varchar](300) NULL,
	[Sequencial_Aprazamento] [int] NULL,
	[Sequencial_Lancamento_Origem] [int] NULL,
	[Conta_Alterada] [smallint] NULL,
	[Sequencial_Lancamento_Origem_Desdobramento] [int] NULL,
	[cd_funcionario_lancamento] [int] NULL,
	[motivo_exclusao] [varchar](100) NULL,
	[protocolo] [varchar](50) NULL,
	[cd_funcionarioexclusao] [int] NULL,
	[numero_NF] [varchar](20) NULL,
	[cd_filial] [int] NULL,
	[iss] [money] NULL,
	[cofins] [money] NULL,
	[csll] [money] NULL,
	[ir] [money] NULL,
	[pis] [money] NULL,
	[valorTotal] [money] NULL,
	[valorLiquido] [money] NULL,
	[liberadoRealizacao] [tinyint] NULL,
	[dataLiberacao] [datetime] NULL,
	[usuarioLiberacao] [int] NULL,
	[motivoLiberacao] [varchar](100) NULL,
	[lancamentoContraParteRateio] [int] NULL,
	[fl_TO] [bit] NULL,
	[cd_sequencial_lote_envio] [int] NULL,
	[cd_sequencial_lote_retorno] [int] NULL,
	[inss] [money] NULL,
	[DataNF] [datetime] NULL,
 CONSTRAINT [PK_TB_Lancamento] PRIMARY KEY NONCLUSTERED 
(
	[Sequencial_Lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_TB_Lancamento_34_955827163__K1_K4] ON [dbo].[TB_Lancamento]
(
	[Sequencial_Lancamento] ASC,
	[Sequencial_Conta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_TB_Lancamento_8_1577577204__K1_K13] ON [dbo].[TB_Lancamento]
(
	[Sequencial_Lancamento] ASC,
	[Data_HoraExclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Lancamento] ON [dbo].[TB_Lancamento]
(
	[Sequencial_Conta] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Lancamento_1] ON [dbo].[TB_Lancamento]
(
	[Tipo_Lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Lancamento_2] ON [dbo].[TB_Lancamento]
(
	[Sequencial_Aprazamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_TB_Lancamento_3] ON [dbo].[TB_Lancamento]
(
	[Tipo_Lancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_TB_Lancamento_protocolo] ON [dbo].[TB_Lancamento]
(
	[protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[TB_Lancamento]  WITH CHECK ADD  CONSTRAINT [FK_TB_Lancamento_FUNCIONARIO] FOREIGN KEY([usuarioLiberacao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TB_Lancamento] CHECK CONSTRAINT [FK_TB_Lancamento_FUNCIONARIO]
ALTER TABLE [dbo].[TB_Lancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Lancamento_TB_Aprazamento] FOREIGN KEY([Sequencial_Aprazamento])
REFERENCES [dbo].[TB_Aprazamento] ([Sequencial_Aprazamento])
ALTER TABLE [dbo].[TB_Lancamento] CHECK CONSTRAINT [FK_TB_Lancamento_TB_Aprazamento]
ALTER TABLE [dbo].[TB_Lancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Lancamento_TB_Conta] FOREIGN KEY([Sequencial_Conta])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TB_Lancamento] CHECK CONSTRAINT [FK_TB_Lancamento_TB_Conta]
ALTER TABLE [dbo].[TB_Lancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Lancamento_TB_Conta1] FOREIGN KEY([Sequencial_Conta])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TB_Lancamento] CHECK CONSTRAINT [FK_TB_Lancamento_TB_Conta1]
