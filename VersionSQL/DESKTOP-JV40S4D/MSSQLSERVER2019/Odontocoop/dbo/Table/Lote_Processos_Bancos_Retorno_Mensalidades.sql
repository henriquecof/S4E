/****** Object:  Table [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades](
	[cd_sequencial_retorno] [int] NOT NULL,
	[nr_linha] [int] NOT NULL,
	[cd_parcela] [int] NULL,
	[cd_ocorrencia] [smallint] NOT NULL,
	[dt_venc] [date] NULL,
	[dt_pago] [date] NULL,
	[vl_parcela] [money] NULL,
	[vl_multa] [money] NULL,
	[vl_desconto] [money] NULL,
	[vl_tarifa] [money] NULL,
	[vl_pago] [money] NULL,
	[nn] [varchar](100) NULL,
	[nm_linha] [varchar](1000) NULL,
	[dt_vencimento_new] [datetime] NULL,
	[fl_excluido] [tinyint] NULL,
	[dt_credito] [date] NULL,
	[cd_ocorrencia_auxiliar] [varchar](50) NULL,
	[nsuAdministradora] [varchar](6) NULL,
	[nrAutorizacao] [varchar](6) NULL,
	[vl_tarifaDiferenciada] [money] NULL,
	[pagamentoId] [varchar](36) NULL,
 CONSTRAINT [PK_Lote_Processos_Bancos_Retorno_Mensalidades] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_retorno] ASC,
	[nr_linha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Retorno_Mensalidades] ON [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]
(
	[cd_ocorrencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Retorno_Mensalidades_1] ON [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]
(
	[cd_sequencial_retorno] ASC,
	[cd_ocorrencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Lote_Processos_Bancos_Retorno_Mensalidades_2] ON [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]
(
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_DEB_AUTOMATICO_CR] FOREIGN KEY([cd_ocorrencia])
REFERENCES [dbo].[DEB_AUTOMATICO_CR] ([cd_ocorrencia])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_DEB_AUTOMATICO_CR]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_Lote_Processos_Bancos_Retorno] FOREIGN KEY([cd_sequencial_retorno])
REFERENCES [dbo].[Lote_Processos_Bancos_Retorno] ([cd_sequencial_retorno])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_Lote_Processos_Bancos_Retorno]
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_Processos_Bancos_Retorno_Mensalidades] CHECK CONSTRAINT [FK_Lote_Processos_Bancos_Retorno_Mensalidades_MENSALIDADES]
