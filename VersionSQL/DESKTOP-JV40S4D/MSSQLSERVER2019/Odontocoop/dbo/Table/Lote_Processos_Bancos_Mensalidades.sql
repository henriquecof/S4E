/****** Object:  Table [dbo].[Lote_Processos_Bancos_Mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_Bancos_Mensalidades](
	[cd_sequencial_lote] [int] NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[nm_sacado] [varchar](100) NULL,
	[dt_vencimento] [date] NULL,
	[vl_parcela] [money] NOT NULL,
	[cd_retorno] [smallint] NULL,
	[cd_sequencial_retorno] [int] NULL,
	[mensagem] [varchar](500) NULL,
	[cd_tipo_arquivo_banco] [smallint] NULL,
	[cd_acao_banco] [smallint] NULL,
	[vl_tarifa] [money] NULL,
	[dt_credito] [varchar](11) NULL,
	[nr_autorizacao] [varchar](20) NULL,
	[nsu] [varchar](20) NULL,
	[pagamentoId] [varchar](36) NULL,
 CONSTRAINT [PK_Lote_Processos_Bancos_Mensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_lote] ASC,
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Mensalidades] ON [dbo].[Lote_Processos_Bancos_Mensalidades]
(
	[cd_associado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Mensalidades_1] ON [dbo].[Lote_Processos_Bancos_Mensalidades]
(
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Acao_Banco] FOREIGN KEY([cd_acao_banco])
REFERENCES [dbo].[Acao_Banco] ([cd_acao_banco])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Acao_Banco]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Lote_Processos_Bancos] FOREIGN KEY([cd_sequencial_lote])
REFERENCES [dbo].[Lote_Processos_Bancos] ([cd_sequencial])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Lote_Processos_Bancos]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Lote_Processos_Bancos_Retorno] FOREIGN KEY([cd_sequencial_retorno])
REFERENCES [dbo].[Lote_Processos_Bancos_Retorno] ([cd_sequencial_retorno])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Lote_Processos_Bancos_Retorno]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_MENSALIDADES]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Tipo_arquivo_banco] FOREIGN KEY([cd_tipo_arquivo_banco])
REFERENCES [dbo].[Tipo_arquivo_banco] ([cd_tipo_arquivo_banco])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Mensalidades_Tipo_arquivo_banco]
