/****** Object:  Table [dbo].[Consultas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Consultas](
	[cd_sequencial] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[CD_FUNCIONARIO] [int] NULL,
	[cd_servico] [int] NULL,
	[cd_UD] [int] NULL,
	[oclusal] [bit] NOT NULL,
	[distral] [bit] NOT NULL,
	[mesial] [bit] NOT NULL,
	[vestibular] [bit] NOT NULL,
	[lingual] [bit] NOT NULL,
	[dt_servico] [datetime] NULL,
	[dt_pericia] [datetime] NULL,
	[dt_impressao_guia] [datetime] NULL,
	[dt_baixa] [datetime] NULL,
	[dt_cancelamento] [datetime] NULL,
	[motivo_cancelamento] [varchar](100) NULL,
	[usuario_cadastro] [varchar](20) NULL,
	[usuario_baixa] [varchar](20) NULL,
	[usuario_cancelamento] [int] NULL,
	[vl_pago_produtividade] [money] NULL,
	[qt_parcela] [smallint] NULL,
	[cd_filial] [int] NOT NULL,
	[nr_autorizacao] [varchar](30) NULL,
	[cd_sequencial_agenda] [int] NULL,
	[fl_foto] [smallint] NULL,
	[Status] [int] NULL,
	[ds_informacao_complementar] [varchar](5000) NULL,
	[ds_informacao_glosa] [varchar](500) NULL,
	[nr_numero_lote] [int] NULL,
	[nr_procedimentoliberado] [smallint] NULL,
	[cd_funcionario_analise] [int] NULL,
	[cd_sequencial_Exame] [int] NULL,
	[cd_sequencial_pericia] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[Carregando] [int] NULL,
	[fl_BaixaConjunto] [bit] NULL,
	[dt_campanha] [datetime] NULL,
	[chaId] [int] NULL,
	[cd_sequencial_pai] [int] NULL,
	[dt_carencia] [datetime] NULL,
	[arcada_superior] [bit] NULL,
	[arcada_inferior] [bit] NULL,
	[nr_gto] [varchar](50) NULL,
	[venc_gto] [datetime] NULL,
	[nr_numero_lote_clinica] [int] NULL,
	[vl_recebido_produtividade] [money] NULL,
	[cd_especialidade_marcacao] [int] NULL,
	[Protocolo] [varchar](50) NULL,
	[StatusInclusao] [int] NULL,
	[CD_Funcionario_Solicitante] [int] NULL,
	[vl_glosa] [money] NULL,
	[dt_recebimento_protocolo] [datetime] NULL,
	[rboId] [tinyint] NULL,
	[dt_conhecimento] [datetime] NULL,
	[vl_acerto_pgto_produtividade] [money] NULL,
	[id_protocolo] [int] NULL,
	[fl_urgencia] [bit] NULL,
	[OrdemRecebimentoProtocolo] [tinyint] NULL,
	[DtImpressaoGTO] [datetime] NULL,
	[ExecutarTrigger] [bit] NULL,
	[cd_funcionarioAnalise] [int] NULL,
	[dt_analise] [datetime] NULL,
	[nr_gtoTISS] [varchar](50) NULL,
	[vl_procedimento_cliente] [money] NULL,
	[Chave] [varchar](30) NULL,
	[DesprezarEspServico] [bit] NULL,
	[dt_bloqueado] [datetime] NULL,
	[fl_indicacao] [bit] NULL,
	[LotePg_indicacaoDentista] [varchar](10) NULL,
	[vl_pago_manual] [money] NULL,
	[odontograma] [bit] NULL,
	[validadePaciente] [datetime] NULL,
	[protocoloValidadePaciente] [varchar](20) NULL,
	[ordemRealizacaoGTO] [tinyint] NULL,
	[cd_filial_Solicitante] [int] NULL,
	[quantidadeArquivoProtocolo] [int] NULL,
	[vl_franquia] [money] NULL,
	[vl_coparticipacao] [money] NULL,
	[nomeSolicitanteLancamento] [varchar](50) NULL,
	[tipoUsuarioInclusao] [tinyint] NULL,
	[data_protocolado] [datetime] NULL,
	[CROSolicitanteLancamento] [varchar](10) NULL,
	[cd_funcionarioProtocolado] [int] NULL,
	[cd_sequencial_agendaDiagnostico] [int] NULL,
	[cd_filialOriginal] [int] NULL,
	[porId] [int] NULL,
	[idIntegrador] [uniqueidentifier] NULL,
	[nr_gtoPrestador] [varchar](50) NULL,
	[cd_funcionarioPericiaFinal] [int] NULL,
	[dtPericiaFinal] [datetime] NULL,
	[Avaliacao] [int] NULL,
	[ComentarioAvaliacao] [varchar](100) NULL,
	[foiAtendido] [int] NULL,
	[cd_funcionarioNotificacaoUpload] [int] NULL,
	[dataNotificacaoUpload] [datetime] NULL,
	[cd_sequencialConsultaVinculado] [int] NULL,
	[tipoAutorizacaoProcedimento] [tinyint] NULL,
	[permitirRealizacaoGlosado] [bit] NULL,
	[vl_pago_produtividade_clinica] [money] NULL,
	[vl_acerto_pgto_produtividade_clinica] [money] NULL,
	[liberadoCoberturaAnterior] [bit] NULL,
	[data_hora_agendamento] [datetime] NULL,
	[observacao_agendamento] [varchar](1000) NULL,
	[cd_funcionarioLiberacaoRealizacaoSemCreditoOrcamento] [int] NULL,
	[dataLiberacaoRealizacaoSemCreditoOrcamento] [datetime] NULL,
	[eleId] [int] NULL,
	[procedimentoVinculadoPrincipal] [bit] NULL,
	[idConsultasKit] [int] NULL,
 CONSTRAINT [PK_Consultas2] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_10_796998366] ON [dbo].[Consultas]
(
	[cd_filial] ASC,
	[dt_servico] ASC,
	[cd_sequencial] ASC,
	[CD_FUNCIONARIO] ASC,
	[nr_numero_lote] ASC,
	[dt_cancelamento] ASC,
	[Status] ASC,
	[cd_sequencial_dep] ASC,
	[cd_servico] ASC,
	[cd_UD] ASC,
	[nr_procedimentoliberado] ASC
)
INCLUDE([oclusal],[distral],[mesial],[vestibular],[lingual]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_Consultas_11_796998366] ON [dbo].[Consultas]
(
	[cd_sequencial_dep] ASC,
	[Status] ASC,
	[cd_servico] ASC,
	[cd_sequencial] ASC,
	[dt_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_Consultas_34_145292173__K29_K1_K2_20_55] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC,
	[cd_sequencial] ASC,
	[cd_sequencial_dep] ASC
)
INCLUDE([vl_pago_produtividade],[vl_acerto_pgto_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_Consultas_5_303808640__K26_K11_K15_K3_K2_K4_K22_K29_20] ON [dbo].[Consultas]
(
	[Status] ASC,
	[dt_servico] ASC,
	[dt_cancelamento] ASC,
	[CD_FUNCIONARIO] ASC,
	[cd_sequencial_dep] ASC,
	[cd_servico] ASC,
	[cd_filial] ASC,
	[nr_numero_lote] ASC
)
INCLUDE([vl_pago_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_Consultas_5_303808640__K29_K26_K11_K15_K4_K2_K3_K22_20] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC,
	[Status] ASC,
	[dt_servico] ASC,
	[dt_cancelamento] ASC,
	[cd_servico] ASC,
	[cd_sequencial_dep] ASC,
	[CD_FUNCIONARIO] ASC,
	[cd_filial] ASC
)
INCLUDE([vl_pago_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_63_303808640__K2_K26_K29_K1_K4_K44_K15_11_20_51_55] ON [dbo].[Consultas]
(
	[cd_sequencial_dep] ASC,
	[Status] ASC,
	[nr_numero_lote] ASC,
	[cd_sequencial] ASC,
	[cd_servico] ASC,
	[nr_gto] ASC,
	[dt_cancelamento] ASC
)
INCLUDE([dt_servico],[vl_pago_produtividade],[vl_glosa],[vl_acerto_pgto_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_63_303808640__K29_K2_K1_K44] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC,
	[cd_sequencial_dep] ASC,
	[cd_sequencial] ASC,
	[nr_gto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_63_303808640__K29_K2_K1_K44_K26_11_51_55] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC,
	[cd_sequencial_dep] ASC,
	[cd_sequencial] ASC,
	[nr_gto] ASC,
	[Status] ASC
)
INCLUDE([dt_servico],[vl_glosa],[vl_acerto_pgto_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [_dta_index_Consultas_7_118096007__K29_K2_20] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC,
	[cd_sequencial_dep] ASC
)
INCLUDE([vl_pago_produtividade]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_7_1245156127__K15_K26_K1_K48] ON [dbo].[Consultas]
(
	[dt_cancelamento] ASC,
	[Status] ASC,
	[cd_sequencial] ASC,
	[Protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_7_1245156127__K48_K15_K22_K3_K26_K1_K2] ON [dbo].[Consultas]
(
	[Protocolo] ASC,
	[dt_cancelamento] ASC,
	[cd_filial] ASC,
	[CD_FUNCIONARIO] ASC,
	[Status] ASC,
	[cd_sequencial] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Consultas_9_796998366] ON [dbo].[Consultas]
(
	[cd_servico] ASC,
	[Status] ASC,
	[cd_sequencial_dep] ASC,
	[cd_sequencial] ASC,
	[CD_FUNCIONARIO] ASC,
	[cd_filial] ASC,
	[usuario_cadastro] ASC,
	[usuario_baixa] ASC,
	[usuario_cancelamento] ASC,
	[cd_sequencial_agenda] ASC,
	[dt_servico] ASC
)
INCLUDE([cd_UD],[oclusal],[distral],[mesial],[vestibular],[lingual],[dt_pericia],[dt_impressao_guia],[dt_baixa],[dt_cancelamento],[motivo_cancelamento],[vl_pago_produtividade],[qt_parcela],[nr_autorizacao],[fl_foto],[ds_informacao_complementar],[ds_informacao_glosa],[nr_numero_lote],[nr_procedimentoliberado],[cd_funcionario_analise],[cd_sequencial_Exame],[cd_sequencial_pericia],[fl_BaixaConjunto],[nr_gto],[venc_gto]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [ind98_Consultas] ON [dbo].[Consultas]
(
	[dt_cancelamento] ASC,
	[Status] ASC,
	[cd_servico] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas] ON [dbo].[Consultas]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_1] ON [dbo].[Consultas]
(
	[cd_sequencial_agenda] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Consultas_10] ON [dbo].[Consultas]
(
	[Protocolo] ASC,
	[Status] ASC,
	[dt_cancelamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_11] ON [dbo].[Consultas]
(
	[id_protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Consultas_12] ON [dbo].[Consultas]
(
	[nr_gto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_15] ON [dbo].[Consultas]
(
	[dt_analise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_2] ON [dbo].[Consultas]
(
	[CD_FUNCIONARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_20] ON [dbo].[Consultas]
(
	[dt_pericia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_3] ON [dbo].[Consultas]
(
	[dt_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_4] ON [dbo].[Consultas]
(
	[chaId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_5] ON [dbo].[Consultas]
(
	[dt_cadastro] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Consultas_6] ON [dbo].[Consultas]
(
	[Protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_7] ON [dbo].[Consultas]
(
	[dt_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_8] ON [dbo].[Consultas]
(
	[nr_numero_lote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_9] ON [dbo].[Consultas]
(
	[StatusInclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_fl_urgencia] ON [dbo].[Consultas]
(
	[fl_urgencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_Consultas_protocoloValidadePaciente] ON [dbo].[Consultas]
(
	[protocoloValidadePaciente] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_StatusInclusao] ON [dbo].[Consultas]
(
	[StatusInclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ConsultasChave] ON [dbo].[Consultas]
(
	[Chave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_11] ON [dbo].[Consultas]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_13] ON [dbo].[Consultas]
(
	[cd_funcionario_analise] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_14] ON [dbo].[Consultas]
(
	[nr_procedimentoliberado] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_18] ON [dbo].[Consultas]
(
	[cd_sequencial_Exame] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_3] ON [dbo].[Consultas]
(
	[dt_impressao_guia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_4] ON [dbo].[Consultas]
(
	[dt_baixa] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_7] ON [dbo].[Consultas]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xix_consultas_9] ON [dbo].[Consultas]
(
	[dt_cancelamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Consultas]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_Consultas] FOREIGN KEY([cd_sequencial])
REFERENCES [dbo].[Consultas] ([cd_sequencial])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_Consultas]
ALTER TABLE [dbo].[Consultas]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_Consultas_Status] FOREIGN KEY([Status])
REFERENCES [dbo].[Consultas_Status] ([Status])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_Consultas_Status]
ALTER TABLE [dbo].[Consultas]  WITH CHECK ADD  CONSTRAINT [FK_Consultas_ConsultasKIT] FOREIGN KEY([idConsultasKit])
REFERENCES [dbo].[ConsultasKIT] ([id])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_ConsultasKIT]
ALTER TABLE [dbo].[Consultas]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_DEPENDENTES]
ALTER TABLE [dbo].[Consultas]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_FILIAL] FOREIGN KEY([cd_filial])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_FILIAL]
ALTER TABLE [dbo].[Consultas]  WITH CHECK ADD  CONSTRAINT [FK_Consultas_PlanejamentoOrtodontico] FOREIGN KEY([porId])
REFERENCES [dbo].[PlanejamentoOrtodontico] ([porId])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_PlanejamentoOrtodontico]
ALTER TABLE [dbo].[Consultas]  WITH CHECK ADD  CONSTRAINT [FK_Consultas_ProtocoloConsultas] FOREIGN KEY([id_protocolo])
REFERENCES [dbo].[ProtocoloConsultas] ([id_protocolo])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_ProtocoloConsultas]
ALTER TABLE [dbo].[Consultas]  WITH NOCHECK ADD  CONSTRAINT [FK_Consultas_SERVICO] FOREIGN KEY([cd_servico])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_Consultas_SERVICO]
ALTER TABLE [dbo].[Consultas]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasTemp_ProtocoloConsultas] FOREIGN KEY([id_protocolo])
REFERENCES [dbo].[ProtocoloConsultas] ([id_protocolo])
ALTER TABLE [dbo].[Consultas] CHECK CONSTRAINT [FK_ConsultasTemp_ProtocoloConsultas]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Status 
1 - procedimento antes do plano   - Não executa regras.                       
2 - procedimento pendente - dt_servico is null,   - Executa regras. 
3 - procedimento executado - dt_servico is not null, - Executa regras.
4 - procedimento cancelado - dt_cancelamento e motivo_cancelamento - Não executa regras.
5 - procedimento inconsistente com as regras    - Executa regras.
6 - procedimento liberado inconsistente    - Não executa regras.

Demais Informações:
Procedimento Glosado            -> Tabela TB_ConsultasGlosados
Procedimento exige documentacao -> Tabela TB_ConsultasDocumentacao
procedimento inconsistente      -> Tabela Inconsistencia_Consulta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Consultas', @level2type=N'COLUMN',@level2name=N'Status'
