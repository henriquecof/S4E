/****** Object:  Table [dbo].[MensalidadesAlteracoes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MensalidadesAlteracoes](
	[CD_PARCELA] [int] NOT NULL,
	[CD_ASSOCIADO_empresa] [int] NOT NULL,
	[TP_ASSOCIADO_EMPRESA] [smallint] NOT NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[CD_TIPO_PAGAMENTO] [int] NOT NULL,
	[CD_TIPO_RECEBIMENTO] [int] NOT NULL,
	[NOSSO_NUMERO] [varchar](50) NULL,
	[DT_VENCIMENTO] [datetime] NOT NULL,
	[DT_PAGAMENTO] [datetime] NULL,
	[DT_GERADO] [datetime] NOT NULL,
	[DT_IMPRESSO] [datetime] NULL,
	[DT_BAIXA] [datetime] NULL,
	[VL_PARCELA] [money] NOT NULL,
	[VL_Acrescimo] [money] NULL,
	[VL_Desconto] [money] NULL,
	[VL_SERVICO] [money] NULL,
	[VL_PAGO] [money] NULL,
	[CD_USUARIO_BAIXA] [int] NULL,
	[CD_USUARIO_ALTERACAO] [int] NULL,
	[DT_ALTERACAO] [datetime] NULL,
	[cd_lote_processo_banco] [int] NULL,
	[VL_JurosMultaReferencia] [money] NULL,
	[chaId] [int] NULL,
	[chaId_retorno_corresp] [int] NULL,
	[Chave] [varchar](50) NULL,
	[NF] [bigint] NULL,
	[cd_usuario_cadastro] [int] NULL,
	[lnfId] [int] NULL,
	[NFeRPS] [varchar](50) NULL,
	[vl_referenciaNF] [money] NULL,
	[dt_vencimento_new] [datetime] NULL,
	[obs] [varchar](500) NULL,
	[vl_imposto] [money] NULL,
	[vl_desconto_recebimento] [money] NULL,
	[vl_taxa] [money] NULL,
	[vl_titulo] [money] NULL,
	[vl_multa] [money] NULL,
	[dt_cancelado_contabil] [date] NULL,
	[VL_AcrescimoAvulso] [money] NULL,
	[VL_DescontoAvulso] [money] NULL,
	[VL_Final] [money] NULL,
	[linkNota] [varchar](300) NULL,
	[dt_negociado] [date] NULL,
	[dt_credito] [date] NULL,
	[obsNF] [varchar](500) NULL,
	[dt_emissao] [date] NULL,
	[id_parcela] [int] IDENTITY(1,1) NOT NULL,
	[obsBoleto] [varchar](500) NULL,
	[dt_inicio_cobertura] [date] NULL,
	[dt_inclusao_tabela] [datetime] NULL,
	[dataRemessa] [datetime] NULL,
	[parcelaProtestada] [bit] NULL,
	[dataParcelaProtestada] [datetime] NULL,
	[usuarioParcelaProtestada] [int] NULL,
	[dataPagamentoTerceiro] [datetime] NULL,
 CONSTRAINT [PK_MensalidadesAlteracoes_1] PRIMARY KEY CLUSTERED 
(
	[id_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_MensalidadesAlteracoes] ON [dbo].[MensalidadesAlteracoes]
(
	[CD_PARCELA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[MensalidadesAlteracoes]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesAlteracoes_FUNCIONARIOProtesto] FOREIGN KEY([usuarioParcelaProtestada])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[MensalidadesAlteracoes] CHECK CONSTRAINT [FK_MensalidadesAlteracoes_FUNCIONARIOProtesto]
ALTER TABLE [dbo].[MensalidadesAlteracoes]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesAlteracoes_MENSALIDADES] FOREIGN KEY([CD_PARCELA])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[MensalidadesAlteracoes] CHECK CONSTRAINT [FK_MensalidadesAlteracoes_MENSALIDADES]
ALTER TABLE [dbo].[MensalidadesAlteracoes]  WITH CHECK ADD  CONSTRAINT [FK_MensalidadesAlteracoes_MENSALIDADES1] FOREIGN KEY([CD_PARCELA])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[MensalidadesAlteracoes] CHECK CONSTRAINT [FK_MensalidadesAlteracoes_MENSALIDADES1]
