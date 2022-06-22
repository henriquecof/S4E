/****** Object:  Table [dbo].[ConsultasTemp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ConsultasTemp](
	[cd_sequencial] [int] NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[cd_associado] [int] NULL,
	[dt_servico] [datetime] NULL,
	[dt_pericia] [smalldatetime] NULL,
	[cd_servico] [int] NULL,
	[dt_impressao_guia] [datetime] NULL,
	[dt_baixa] [datetime] NULL,
	[dt_cancelamento] [datetime] NULL,
	[motivo_cancelamento] [varchar](100) NULL,
	[usuario_cadastro] [varchar](20) NULL,
	[usuario_baixa] [varchar](20) NULL,
	[usuario_guia] [varchar](20) NULL,
	[cd_UD] [int] NULL,
	[CD_FUNCIONARIO] [int] NULL,
	[oclusal] [bit] NOT NULL,
	[distral] [bit] NOT NULL,
	[mesial] [bit] NOT NULL,
	[vestibular] [bit] NOT NULL,
	[lingual] [bit] NOT NULL,
	[vl_pago_produtividade] [money] NULL,
	[qt_parcela] [smallint] NULL,
	[cd_filial] [int] NULL,
	[cd_sequencial_agenda] [int] NULL,
	[hr_Compromisso] [int] NULL,
	[nr_guia] [int] NULL,
	[fl_foto] [smallint] NULL,
	[Status] [smallint] NULL,
	[cd_clinica] [int] NULL,
	[nr_protocolo] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[fl_Excluir] [bit] NULL,
	[cd_sequencialTemp] [int] IDENTITY(1,1) NOT NULL,
	[ds_informacao_complementar] [varchar](250) NULL,
	[fl_Orcamento] [smallint] NULL,
	[cd_funcionario_analise] [int] NULL,
	[nr_procedimentoliberado] [smallint] NULL,
	[nr_numero_lote] [int] NULL,
	[ds_informacao_glosa] [varchar](500) NULL,
	[cd_sequencial_Exame] [int] NULL,
	[nr_autorizacao] [varchar](30) NULL,
	[Carregando] [smallint] NULL,
	[fl_BaixaConjunto] [bit] NULL,
	[dt_campanha] [datetime] NULL,
	[chaId] [int] NULL,
	[dt_carencia] [datetime] NULL,
	[arcada_superior] [bit] NULL,
	[arcada_inferior] [bit] NULL,
	[cd_especialidade_marcacao] [int] NULL,
	[nr_gto] [varchar](50) NULL,
	[venc_gto] [datetime] NULL,
	[nr_numero_lote_clinica] [int] NULL,
	[Protocolo] [varchar](50) NULL,
	[StatusInclusao] [int] NULL,
	[CD_Funcionario_Solicitante] [int] NULL,
	[vl_glosa] [money] NULL,
	[dt_recebimento_protocolo] [datetime] NULL,
	[rboId] [tinyint] NULL,
	[dt_conhecimento] [datetime] NULL,
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
	[vl_pago_manual] [money] NULL,
	[odontograma] [bit] NULL,
	[validadePaciente] [datetime] NULL,
	[protocoloValidadePaciente] [varchar](20) NULL,
	[ordemRealizacaoGTO] [tinyint] NULL,
	[cd_filial_Solicitante] [int] NULL,
	[vl_franquia] [money] NULL,
	[vl_coparticipacao] [money] NULL,
	[nomeSolicitanteLancamento] [varchar](50) NULL,
	[tipoUsuarioInclusao] [tinyint] NULL,
	[CROSolicitanteLancamento] [varchar](10) NULL,
	[cd_sequencial_agendaDiagnostico] [int] NULL,
	[eleId] [int] NULL,
	[idConsultasKit] [int] NULL,
 CONSTRAINT [PK_ConsultasTemp] PRIMARY KEY CLUSTERED 
(
	[cd_sequencialTemp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_ConsultasTemp_12_1425088513] ON [dbo].[ConsultasTemp]
(
	[cd_sequencial_dep] ASC,
	[dt_cancelamento] ASC,
	[fl_Excluir] ASC,
	[cd_UD] ASC,
	[cd_sequencialTemp] ASC,
	[cd_servico] ASC,
	[CD_FUNCIONARIO] ASC,
	[cd_sequencial] ASC
)
INCLUDE([dt_servico],[dt_pericia],[oclusal],[distral],[mesial],[vestibular],[lingual],[Status],[ds_informacao_complementar],[fl_Orcamento],[cd_funcionario_analise],[nr_procedimentoliberado],[nr_numero_lote],[ds_informacao_glosa],[nr_autorizacao]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IDC_LotePagamentoClinicaTEMP] ON [dbo].[ConsultasTemp]
(
	[nr_numero_lote_clinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Consultas_StatusInclusao] ON [dbo].[ConsultasTemp]
(
	[StatusInclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ConsultasTemp] ON [dbo].[ConsultasTemp]
(
	[StatusInclusao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ConsultasTemp_1] ON [dbo].[ConsultasTemp]
(
	[CD_FUNCIONARIO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ConsultasTemp_2] ON [dbo].[ConsultasTemp]
(
	[id_protocolo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ConsultasTemp_3] ON [dbo].[ConsultasTemp]
(
	[nr_gto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_ConsultasTemp_4] ON [dbo].[ConsultasTemp]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_ConsultasTempChave] ON [dbo].[ConsultasTemp]
(
	[Chave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [XX_ConsultasTemp] ON [dbo].[ConsultasTemp]
(
	[cd_associado] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xx_ConsultasTemp_1] ON [dbo].[ConsultasTemp]
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [xX2_ConsultasTemp_1] ON [dbo].[ConsultasTemp]
(
	[cd_servico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[ConsultasTemp]  WITH CHECK ADD  CONSTRAINT [FK_ConsultasTemp_FuncionarioSolicitante] FOREIGN KEY([CD_Funcionario_Solicitante])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ConsultasTemp] CHECK CONSTRAINT [FK_ConsultasTemp_FuncionarioSolicitante]
