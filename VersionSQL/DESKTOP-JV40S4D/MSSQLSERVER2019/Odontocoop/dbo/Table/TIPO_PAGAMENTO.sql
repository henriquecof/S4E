/****** Object:  Table [dbo].[TIPO_PAGAMENTO]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TIPO_PAGAMENTO](
	[cd_tipo_pagamento] [int] IDENTITY(1,1) NOT NULL,
	[nm_tipo_pagamento] [varchar](50) NOT NULL,
	[fl_aceita_venda] [bit] NOT NULL,
	[fl_aceita_baixa] [bit] NOT NULL,
	[fl_recebimento_caixa] [bit] NOT NULL,
	[Cedente] [varchar](60) NOT NULL,
	[EndCedente] [varchar](100) NULL,
	[banco] [int] NULL,
	[ag] [varchar](50) NULL,
	[dv_ag] [char](1) NULL,
	[cta] [varchar](50) NULL,
	[dv_cta] [char](1) NULL,
	[carteira] [int] NULL,
	[VariacaoCarteira] [int] NULL,
	[convenio] [varchar](20) NULL,
	[dv_convenio] [char](1) NULL,
	[cd_tabela] [int] NOT NULL,
	[fl_exige_Dados_ServidorPublico] [bit] NOT NULL,
	[fl_exige_Dados_cartao] [bit] NOT NULL,
	[fl_exige_Dados_conta] [bit] NOT NULL,
	[cd_tipo_servico_bancario] [smallint] NULL,
	[Perc_juros] [int] NULL,
	[Perc_multa] [int] NULL,
	[nr_cnpj] [char](14) NOT NULL,
	[dt_exclusao] [datetime] NULL,
	[dias_protesto] [smallint] NULL,
	[fl_averbacao] [bit] NOT NULL,
	[fl_envia_arquivo] [tinyint] NULL,
	[fl_boleto] [bit] NULL,
	[nm_mensagem1] [varchar](100) NULL,
	[nm_mensagem2] [varchar](100) NULL,
	[nm_mensagem3] [varchar](100) NULL,
	[fl_relatorio] [bit] NULL,
	[fl_cobranca_registrada] [bit] NULL,
	[qtdl_digitosCartao] [tinyint] NULL,
	[cd_tipo_pagamento2via] [int] NULL,
	[percentual_desconto_intermediadora] [float] NULL,
	[vl_parcelaMinima] [money] NULL,
	[fl_aceitamultiplosservicobancario] [bit] NULL,
	[impressaoSomenteAposArquivoRegistro] [bit] NULL,
	[alteracaoExternaParcelaRegistrada] [bit] NULL,
	[visivelOrcamento] [bit] NULL,
	[tipoEnvioBanco] [tinyint] NULL,
	[dias_baixa] [int] NULL,
	[taxaParcelaVirtual] [money] NULL,
	[tipoMovimentacaoRegistroBanco] [tinyint] NULL,
	[impressaoExterna] [bit] NULL,
	[acaoImpressaoRegistro] [tinyint] NULL,
	[nm_tipo_pagamentoExterno] [varchar](50) NULL,
	[exigeDvAgencia] [smallint] NULL,
	[codigoContaExclusiva] [varchar](4) NULL,
	[convenioOdontocob] [varchar](100) NULL,
	[cd_centro_custo] [int] NULL,
	[CedenteImpressao] [varchar](60) NULL,
	[nr_cnpjImpressao] [char](14) NULL,
	[clienteOdontocob] [varchar](450) NULL,
	[impressaoOdontocob] [bit] NOT NULL,
	[cedenteIR] [varchar](100) NULL,
	[endCedenteIR] [varchar](100) NULL,
	[CNPJIR] [varchar](14) NULL,
 CONSTRAINT [PK_TIPO_PAGAMENTO] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_fl_ativo]  DEFAULT ((1)) FOR [fl_aceita_venda]
ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_fl_exige_SP]  DEFAULT ((0)) FOR [fl_exige_Dados_ServidorPublico]
ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_fl_exige_cartao]  DEFAULT ((0)) FOR [fl_exige_Dados_cartao]
ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_fl_exige_conta]  DEFAULT ((0)) FOR [fl_exige_Dados_conta]
ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_fl_averbacao]  DEFAULT ((0)) FOR [fl_averbacao]
ALTER TABLE [dbo].[TIPO_PAGAMENTO] ADD  DEFAULT ((0)) FOR [impressaoOdontocob]
ALTER TABLE [dbo].[TIPO_PAGAMENTO]  WITH NOCHECK ADD  CONSTRAINT [FK_TIPO_PAGAMENTO_Tabela] FOREIGN KEY([cd_tabela])
REFERENCES [dbo].[Tabela] ([cd_tabela])
ALTER TABLE [dbo].[TIPO_PAGAMENTO] CHECK CONSTRAINT [FK_TIPO_PAGAMENTO_Tabela]
ALTER TABLE [dbo].[TIPO_PAGAMENTO]  WITH NOCHECK ADD  CONSTRAINT [FK_TIPO_PAGAMENTO_TB_Banco] FOREIGN KEY([banco])
REFERENCES [dbo].[TB_Banco_Contratos] ([cd_banco])
ALTER TABLE [dbo].[TIPO_PAGAMENTO] CHECK CONSTRAINT [FK_TIPO_PAGAMENTO_TB_Banco]
ALTER TABLE [dbo].[TIPO_PAGAMENTO]  WITH NOCHECK ADD  CONSTRAINT [FK_TIPO_PAGAMENTO_tipo_servico_bancario] FOREIGN KEY([cd_tipo_servico_bancario])
REFERENCES [dbo].[tipo_servico_bancario] ([cd_tipo_servico_bancario])
ALTER TABLE [dbo].[TIPO_PAGAMENTO] CHECK CONSTRAINT [FK_TIPO_PAGAMENTO_tipo_servico_bancario]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo Pagamento|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'nm_tipo_pagamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Venda|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_aceita_venda'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Baixa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_aceita_baixa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Caixa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_recebimento_caixa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cedente|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'Cedente'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Endereço Cedente' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'EndCedente'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Banco|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agência|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'ag'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dv Ag|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'dv_ag'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'cta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'DV Cta|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'dv_cta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Carteira|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'carteira'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Variacao|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'VariacaoCarteira'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Convenio|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'convenio'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tabela' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'cd_tabela'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dados Servidor Público' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_exige_Dados_ServidorPublico'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dados Cartão' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_exige_Dados_cartao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dados Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'fl_exige_Dados_conta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TIPO_PAGAMENTO', @level2type=N'COLUMN',@level2name=N'cd_tipo_servico_bancario'
