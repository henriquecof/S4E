/****** Object:  Table [dbo].[EMPRESA]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[EMPRESA](
	[CD_EMPRESA] [bigint] IDENTITY(1,1) NOT NULL,
	[NM_RAZSOC] [varchar](100) NOT NULL,
	[NM_FANTASIA] [varchar](100) NOT NULL,
	[NR_CGC] [varchar](14) NULL,
	[cgf] [varchar](12) NULL,
	[TP_EMPRESA] [smallint] NOT NULL,
	[DT_FECHAMENTO_CONTRATO] [datetime] NULL,
	[CD_Sequencial_historico] [int] NULL,
	[NM_CONTATO] [varchar](50) NULL,
	[dt_vencimento] [smallint] NOT NULL,
	[dt_corte] [smallint] NOT NULL,
	[mm_aaaa_1pagamento_empresa] [int] NOT NULL,
	[CD_ORGAO] [varchar](6) NULL,
	[CD_VERBA] [varchar](6) NULL,
	[cd_grupo] [smallint] NULL,
	[fl_acrescimo] [bit] NULL,
	[vl_ajuste] [money] NULL,
	[percentual_retencao] [money] NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[senha] [varchar](50) NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[cd_forma_pagamento] [smallint] NULL,
	[qt_funcionarios] [int] NULL,
	[cd_ramo_atividade] [smallint] NULL,
	[Codigo_Sistema_Destino] [varchar](10) NULL,
	[Codigo_Evento] [int] NULL,
	[SQTipoArquivoImportacao] [smallint] NULL,
	[nf_pre_pospaga] [int] NULL,
	[nm_arquivo_carteira] [varchar](8) NULL,
	[DiasIntervaloConsulta] [smallint] NULL,
	[fl_online] [bit] NOT NULL,
	[Cep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[ufId] [smallint] NULL,
	[cd_municipio] [int] NULL,
	[BaiId] [int] NULL,
	[fl_exige_matricula] [bit] NOT NULL,
	[cd_situacao] [int] NULL,
	[qt_vigencia] [smallint] NOT NULL,
	[ds_percentual_retencao] [varchar](50) NULL,
	[qt_dias_carencia] [int] NULL,
	[rcaId] [int] NOT NULL,
	[responsavel_legal] [varchar](50) NULL,
	[cpf_responsavel_legal] [varchar](11) NULL,
	[fl_exigeautadesao] [bit] NULL,
	[qt_incremento_mes_fatura] [smallint] NULL,
	[dias_tolerancia_atendimento] [smallint] NULL,
	[nr_inscricao_municipal] [int] NULL,
	[cd_tipo_rede_atendimento] [tinyint] NULL,
	[fl_beneficiario_cancelamento] [bit] NULL,
	[cd_tabela] [int] NULL,
	[pdvId] [tinyint] NULL,
	[cd_func_vendedor] [int] NULL,
	[fl_EnderecoSIB] [tinyint] NULL,
	[dia_inicio_cobertura] [smallint] NULL,
	[fl_gera_carteira] [int] NULL,
	[fl_prorata] [bit] NULL,
	[peso_proc_mes] [smallint] NULL,
	[EndLogradouro_COBRA] [varchar](100) NULL,
	[EndNumero_COBRA] [int] NULL,
	[EndComplemento_COBRA] [varchar](100) NULL,
	[CHAVE_LOGRADOURO_COBRA] [int] NULL,
	[UF_COBRA] [smallint] NULL,
	[cd_muncipio_COBRA] [int] NULL,
	[baiId_COBRA] [int] NULL,
	[CepCOBRA] [varchar](8) NULL,
	[fl_CarenciaAtendimentoEmpresa] [bit] NULL,
	[cd_func_adesionista] [int] NULL,
	[cd_tipo_preco] [int] NULL,
	[TipoInclusaoPortal] [tinyint] NULL,
	[cd_RegraCancelamentoDependente] [int] NULL,
	[QtDiasBloqueioProcedimento] [tinyint] NULL,
	[vl_minimo_fatura] [money] NULL,
	[Dias_Liberacao_Plano_tratamento] [int] NULL,
	[dt_alteracao_senha] [datetime] NULL,
	[executarTrigger] [bit] NULL,
	[emiteNotaFiscal] [bit] NULL,
	[cd_tipoautorizador] [tinyint] NULL,
	[Codigo_OrigemCartao] [int] NULL,
	[vendaSite] [bit] NULL,
	[tp_faturamento] [smallint] NULL,
	[msgCarteira] [varchar](25) NULL,
	[tmiId] [tinyint] NULL,
	[nr_cgcCRM] [varchar](14) NULL,
	[aliasCRM] [varchar](100) NULL,
	[vl_cobrado_carteira_inclusao_usuario] [money] NULL,
	[pontoDeReferencia] [varchar](200) NULL,
	[exigirComplementoCadastralMarcacao] [bit] NULL,
	[fechaFaturamentoAutomatico] [bit] NULL,
	[obs_comercial] [varchar](500) NULL,
	[obs_contrato] [varchar](500) NULL,
	[vl_multa_contratual] [smallint] NULL,
	[qt_mes_minimo_cancelamento] [smallint] NULL,
	[vencimentoEmpresaAssociado] [tinyint] NULL,
	[qtdeDiasAntecipacaoFaturamento] [smallint] NULL,
	[cd_empresa_prefeitura] [tinyint] NULL,
	[enviarDMED] [bit] NULL,
	[impressaoBoletoLote] [int] NULL,
	[tipo_exigencia_complemento_cadastral_marcacao] [tinyint] NULL,
	[valorUso] [money] NULL,
	[cd_funcionario] [int] NULL,
	[idIndiceReajuste] [int] NULL,
	[DT_MOVIMENTACAO_MAXIMA] [int] NULL,
	[ISMax] [float] NULL,
	[CHAVE_TIPOLOGRADOURO_FATURA] [int] NULL,
	[EndLogradouro_FATURA] [varchar](100) NULL,
	[EndNumero_FATURA] [int] NULL,
	[EndComplemento_FATURA] [varchar](100) NULL,
	[ufId_FATURA] [smallint] NULL,
	[cd_municipio_FATURA] [int] NULL,
	[BaiId_FATURA] [int] NULL,
	[Cep_FATURA] [varchar](8) NULL,
	[endBoleto] [varchar](40) NULL,
	[tp_patrocinio] [int] NULL,
	[AcessoPortal] [bit] NULL,
	[EnvioGrafica] [bit] NULL,
	[VisualizaBoleto] [bit] NULL,
	[VisualizaFaturas] [bit] NULL,
	[fl_adesaoretida] [bit] NULL,
	[cd_empresa_mae] [int] NULL,
	[fl_vip_emp] [smallint] NULL,
	[fl_vip] [smallint] NULL,
	[cd_funcionario_cadastro] [int] NULL,
	[dias_movimentacao] [int] NULL,
	[nr_inscricao_estadual] [varchar](15) NULL,
	[TextoMovimentacaoCadastral] [varchar](1000) NULL,
	[arquivoCarteira] [varchar](200) NULL,
	[taxaAdm] [money] NULL,
	[fl_atualizar_contatos_aplicativo] [bit] NULL,
	[dias_atualizar_contatos_aplicativo] [int] NULL,
	[fl_mei] [bit] NULL,
	[fl_utilizadiautil] [bit] NULL,
	[nomeImpressoCarteira] [varchar](130) NULL,
	[cd_centro_custo_aux] [smallint] NULL,
	[numeroCNPJCAEPF] [tinyint] NULL,
	[exibirIRPF] [bit] NULL,
	[aplicacaoReajustePor] [tinyint] NULL,
	[portalMovimentacaoCadastral] [bit] NULL,
 CONSTRAINT [PK_EMPRESA_GERAIS] PRIMARY KEY NONCLUSTERED 
(
	[CD_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_36_2003095218__K19_K6_K1_K8_3] ON [dbo].[EMPRESA]
(
	[cd_centro_custo] ASC,
	[TP_EMPRESA] ASC,
	[CD_EMPRESA] ASC,
	[CD_Sequencial_historico] ASC
)
INCLUDE([NM_FANTASIA]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_5_1077695733__K3_1_48] ON [dbo].[EMPRESA]
(
	[NM_FANTASIA] ASC
)
INCLUDE([CD_EMPRESA],[fl_exigeautadesao]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_5_954343060__K1_K19_K6] ON [dbo].[EMPRESA]
(
	[CD_EMPRESA] ASC,
	[cd_centro_custo] ASC,
	[TP_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_5_954343060__K6_K19_K1_K8_K21_K38_K3_7_10_12] ON [dbo].[EMPRESA]
(
	[TP_EMPRESA] ASC,
	[cd_centro_custo] ASC,
	[CD_EMPRESA] ASC,
	[CD_Sequencial_historico] ASC,
	[cd_tipo_pagamento] ASC,
	[cd_municipio] ASC,
	[NM_FANTASIA] ASC
)
INCLUDE([DT_FECHAMENTO_CONTRATO],[dt_vencimento],[mm_aaaa_1pagamento_empresa]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_7_1723569624__K6_1] ON [dbo].[EMPRESA]
(
	[TP_EMPRESA] ASC
)
INCLUDE([CD_EMPRESA]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_EMPRESA_9_1506572901] ON [dbo].[EMPRESA]
(
	[CD_EMPRESA] ASC,
	[TP_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA] ON [dbo].[EMPRESA]
(
	[BaiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_EMPRESA_1] ON [dbo].[EMPRESA]
(
	[NM_FANTASIA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_10] ON [dbo].[EMPRESA]
(
	[TP_EMPRESA] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_11] ON [dbo].[EMPRESA]
(
	[ufId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_12] ON [dbo].[EMPRESA]
(
	[CD_EMPRESA] ASC,
	[cd_centro_custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_2] ON [dbo].[EMPRESA]
(
	[cd_centro_custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_3] ON [dbo].[EMPRESA]
(
	[cd_forma_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_4] ON [dbo].[EMPRESA]
(
	[cd_municipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_5] ON [dbo].[EMPRESA]
(
	[CD_Sequencial_historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_6] ON [dbo].[EMPRESA]
(
	[cd_tipo_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_7] ON [dbo].[EMPRESA]
(
	[dt_corte] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_EMPRESA_8] ON [dbo].[EMPRESA]
(
	[dt_vencimento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_EMPRESA_9] ON [dbo].[EMPRESA]
(
	[NM_RAZSOC] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_cd_tipo_boleto]  DEFAULT ((1)) FOR [cd_tipo_pagamento]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_SequencialTipoArquivoImportacao]  DEFAULT ((3)) FOR [SQTipoArquivoImportacao]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_DiasIntervaloConsulta]  DEFAULT ((10)) FOR [DiasIntervaloConsulta]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_fl_online]  DEFAULT ((0)) FOR [fl_online]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_fl_exige_matricula]  DEFAULT ((0)) FOR [fl_exige_matricula]
ALTER TABLE [dbo].[EMPRESA] ADD  CONSTRAINT [DF_EMPRESA_dia_inicio_cobertura]  DEFAULT ((1)) FOR [dia_inicio_cobertura]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_DIA_PAGAMENTO] FOREIGN KEY([dt_vencimento])
REFERENCES [dbo].[DIA_PAGAMENTO] ([cd_dia])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_DIA_PAGAMENTO]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_EMPRESA] FOREIGN KEY([CD_EMPRESA])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_EMPRESA]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_FORMA_PAGAMENTO_EMPRESA] FOREIGN KEY([cd_forma_pagamento])
REFERENCES [dbo].[FORMA_PAGAMENTO_EMPRESA] ([cd_forma_pagamento])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_FORMA_PAGAMENTO_EMPRESA]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_FUNCIONARIO_VENDEDOR] FOREIGN KEY([CD_EMPRESA])
REFERENCES [dbo].[EMPRESA] ([CD_EMPRESA])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_FUNCIONARIO_VENDEDOR]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_GRUPO] FOREIGN KEY([cd_grupo])
REFERENCES [dbo].[GRUPO] ([CD_GRUPO])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_GRUPO]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_empresa_idIndiceReajuste_IndiceReajuste_id] FOREIGN KEY([idIndiceReajuste])
REFERENCES [dbo].[IndiceReajuste] ([id])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_empresa_idIndiceReajuste_IndiceReajuste_id]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_MUNICIPIO] FOREIGN KEY([cd_municipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_MUNICIPIO]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_Padrao_Venda] FOREIGN KEY([pdvId])
REFERENCES [dbo].[Padrao_Venda] ([pdvId])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_Padrao_Venda]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_ramo_atividade] FOREIGN KEY([cd_ramo_atividade])
REFERENCES [dbo].[ramo_atividade] ([cd_ramo_atividade])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_ramo_atividade]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_RegrasCancelamentoDependente] FOREIGN KEY([cd_RegraCancelamentoDependente])
REFERENCES [dbo].[RegrasCancelamentoDependente] ([cd_regra])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_RegrasCancelamentoDependente]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_tabela] FOREIGN KEY([cd_tabela])
REFERENCES [dbo].[Tabela] ([cd_tabela])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_tabela]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_TIPO_EMPRESA] FOREIGN KEY([TP_EMPRESA])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_TIPO_EMPRESA]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_TIPO_PAGAMENTO]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_EMPRESA_tipo_preco] FOREIGN KEY([cd_tipo_preco])
REFERENCES [dbo].[tipo_preco] ([cd_tipo_preco])
ON UPDATE CASCADE
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_tipo_preco]
ALTER TABLE [dbo].[EMPRESA]  WITH NOCHECK ADD  CONSTRAINT [FK_EMPRESA_UF] FOREIGN KEY([ufId])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_EMPRESA_UF]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_FUNCIONARIO_EMPRESA_cd_funcionario] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_FUNCIONARIO_EMPRESA_cd_funcionario]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_TB_EMPRESA_MUNICIPIO_COBRANCA] FOREIGN KEY([cd_muncipio_COBRA])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_TB_EMPRESA_MUNICIPIO_COBRANCA]
ALTER TABLE [dbo].[EMPRESA]  WITH CHECK ADD  CONSTRAINT [FK_TB_EMPRESA_UF_COBRANCA] FOREIGN KEY([UF_COBRA])
REFERENCES [dbo].[UF] ([ufId])
ALTER TABLE [dbo].[EMPRESA] CHECK CONSTRAINT [FK_TB_EMPRESA_UF_COBRANCA]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Razão Social|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'NM_RAZSOC'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome Fantasia|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'NM_FANTASIA'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CNPJ#' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'NR_CGC'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CGF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cgf'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo Empresa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'TP_EMPRESA'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Data Contrato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'DT_FECHAMENTO_CONTRATO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Situação|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'CD_Sequencial_historico'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contato' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'NM_CONTATO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Vencimento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'dt_vencimento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Corte' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'dt_corte'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ano e Mes 1o Pagamento#9999/99' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'mm_aaaa_1pagamento_empresa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Orgão' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'CD_ORGAO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Verba' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'CD_VERBA'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Grupo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_grupo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Valor Desconto' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'vl_ajuste'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Centro de Custo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_centro_custo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Convênio' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_tipo_pagamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Forma Pagamento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_forma_pagamento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Qtde Funcionarios' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'qt_funcionarios'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ramo Atividade' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_ramo_atividade'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código no Sistema de Destino' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'Codigo_Sistema_Destino'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Código do Evento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'Codigo_Evento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo Arquivo Importação' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'SQTipoArquivoImportacao'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo NF (1-Pré, 2-Pós)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'nf_pre_pospaga'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome Arquivo Carteira' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'nm_arquivo_carteira'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dias Intervalo Consulta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'DiasIntervaloConsulta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Empresa Online' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'fl_online'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cep#' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'Cep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'CHAVE_TIPOLOGRADOURO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Endereço' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'EndLogradouro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'EndNumero'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Complemento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'EndComplemento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'ufId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Municipio' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'cd_municipio'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bairro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'BaiId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Exige Matricula' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMPRESA', @level2type=N'COLUMN',@level2name=N'fl_exige_matricula'
