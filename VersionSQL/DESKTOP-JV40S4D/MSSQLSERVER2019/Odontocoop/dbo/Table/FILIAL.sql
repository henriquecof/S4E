/****** Object:  Table [dbo].[FILIAL]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FILIAL](
	[cd_filial] [int] IDENTITY(1,1) NOT NULL,
	[nm_filial] [varchar](100) NOT NULL,
	[nr_cgc] [varchar](14) NULL,
	[nm_responsavel] [varchar](100) NULL,
	[LogCep] [varchar](8) NULL,
	[CHAVE_TIPOLOGRADOURO] [int] NULL,
	[EndLogradouro] [varchar](100) NULL,
	[EndNumero] [int] NULL,
	[EndComplemento] [varchar](100) NULL,
	[BaiId] [int] NULL,
	[CidID] [int] NULL,
	[ufId] [smallint] NULL,
	[cd_clinica] [smallint] NOT NULL,
	[fl_online] [tinyint] NULL,
	[fl_consultorio] [bit] NOT NULL,
	[fl_ativa] [tinyint] NULL,
	[fl_DiasIntervaloConsultaVar] [smallint] NULL,
	[senha] [varchar](50) NULL,
	[url_mapalocalizacao] [varchar](50) NULL,
	[observacao] [varchar](500) NULL,
	[fl_biometria] [bit] NOT NULL,
	[flanalisaProcedimentoPag] [bit] NOT NULL,
	[CNES] [varchar](10) NULL,
	[cd_tipo_faturamento] [tinyint] NULL,
	[dt_corte] [int] NULL,
	[nm_titular_cta] [varchar](100) NULL,
	[cd_banco] [int] NULL,
	[nr_agencia] [varchar](20) NULL,
	[nr_conta] [varchar](20) NULL,
	[dt_vencimento] [int] NULL,
	[Sequencial_Conta] [int] NULL,
	[Vl_fixo_Produtividade] [money] NULL,
	[qt_incremento_mes_fatura] [smallint] NULL,
	[nr_cpf_responsavel] [varchar](11) NULL,
	[cd_funcionario_responsavel] [int] NULL,
	[cd_centro_custo] [smallint] NULL,
	[fl_orcamentoUnico] [bit] NULL,
	[vl_teto_filial] [money] NULL,
	[tp_estabecimento] [varchar](4) NULL,
	[tp_contratacao] [varchar](1) NULL,
	[dt_contrato] [datetime] NULL,
	[dt_iniVinculo] [datetime] NULL,
	[cd_classificacao_est] [tinyint] NULL,
	[nr_ANSinter] [varchar](6) NULL,
	[cd_dispon_serv] [varchar](1) NULL,
	[cd_ind_urgencia] [varchar](1) NULL,
	[cd_tipo_baixa_agenda] [tinyint] NULL,
	[fl_PesquisaOrtoOdontograma] [bit] NULL,
	[fl_OdontogramaCompleto] [bit] NULL,
	[cro_filial] [varchar](20) NULL,
	[nr_contrato] [varchar](14) NULL,
	[tp_relacaoContrato] [tinyint] NULL,
	[cd_tabela] [smallint] NULL,
	[cd_modelo_biometria] [smallint] NULL,
	[fl_biometria_funcionario] [smallint] NULL,
	[tbcId] [tinyint] NULL,
	[alias_interno] [varchar](50) NULL,
	[cd_tabelaParticular] [smallint] NULL,
	[nm_fantasia] [varchar](150) NULL,
	[QtdeDiasBaixaRetroativa] [smallint] NULL,
	[QtdeBaixaPrestadorUsuario] [tinyint] NULL,
	[ReferenciaLimiteBaixaPrestadorUsuario] [tinyint] NULL,
	[QtdeMaximaBaixaUsuarioMes] [tinyint] NULL,
	[tesId] [tinyint] NULL,
	[tbcIdPendente] [tinyint] NULL,
	[tbcIdRealizado] [tinyint] NULL,
	[cd_filialSubstituta] [int] NULL,
	[dt_descredenciamento] [datetime] NULL,
	[fl_divulgar_rede_atendimento] [bit] NULL,
	[nm_razsoc] [varchar](100) NULL,
	[cod_easy] [int] NULL,
	[ValidadeElegibilidade] [int] NULL,
	[TipoValidadeElegibilidade] [tinyint] NULL,
	[TipoImpressaoGTO] [tinyint] NULL,
	[DiasValidadeGTO] [tinyint] NULL,
	[QtdeProcedimentosGTO] [tinyint] NULL,
	[id_regiao] [int] NULL,
	[fl_OrcamentoFechaSemPagTotal] [tinyint] NULL,
	[QtDiasBloqueioProcedimento] [tinyint] NULL,
	[dt_alteracao_senha] [datetime] NULL,
	[executarTrigger] [bit] NULL,
	[exameConclusaoOdontograma] [bit] NULL,
	[DataInicioCreditoOrto] [datetime] NULL,
	[atualizar_contato_dias] [int] NULL,
	[atualizar_contato_data_referencia] [datetime] NULL,
	[ufId_cro] [smallint] NULL,
	[conta_operacao] [int] NULL,
	[tipoAcaoBiometriaBaixaAgenda] [smallint] NULL,
	[cd_tabelaParceiro] [smallint] NULL,
	[exigirDocumentacaoProcedimento] [tinyint] NULL,
	[realizacaoProcedimentoSomenteAposUpload] [tinyint] NULL,
	[cd_tipoautorizador] [tinyint] NULL,
	[pontuacao] [tinyint] NULL,
	[classificacaoFilialDominio] [int] NULL,
	[cd_tabelaMicroCredito] [int] NULL,
	[latitude] [varchar](50) NULL,
	[longitude] [varchar](50) NULL,
	[tipoChecagemProcPendenteRepetido] [tinyint] NULL,
	[idRegiaoEndereco] [int] NULL,
	[flPrioridade] [int] NULL,
	[DataInicioCreditoClinico] [datetime] NULL,
	[usuarioAtualizacao] [int] NULL,
	[dt_atualizacao] [datetime] NULL,
	[us_referencia] [numeric](5, 2) NULL,
	[tipoRede] [tinyint] NULL,
	[QtdeProcedimentosGTOAcao] [tinyint] NULL,
	[QtdeProcedimentosGTOSituacao] [tinyint] NULL,
	[informacoesFinanceirasCorpoClinico] [bit] NULL,
	[biometriaFacial] [bit] NULL,
	[idGrupoClinica] [tinyint] NULL,
	[dataEmailBoasVindas] [datetime] NULL,
	[LinkExterno] [varchar](150) NULL,
	[imprimir_vl_GTO] [bit] NULL,
	[fl_cadastroANS] [bit] NULL,
	[pontosMaximosProcedimentoUsuarioLote] [float] NULL,
	[qtdeMaximaProcedimentoUsuarioLote] [int] NULL,
	[croDataExpedicao_filial] [date] NULL,
	[pontoDeReferencia] [varchar](200) NULL,
	[QtdeProcedimentosGTOTipoContagem] [tinyint] NULL,
	[GTODigital] [tinyint] NULL,
	[fl_vip] [smallint] NULL,
	[regulamento] [varchar](500) NULL,
	[token] [uniqueidentifier] NULL,
	[dtVencimentoAlvaraFuncionamento] [date] NULL,
	[dtVencimentoAlvaraSanitario] [date] NULL,
	[tipoProcedimentoImpressoGTO] [tinyint] NULL,
	[elegibilidadeTokenSMS] [bit] NULL,
	[useBancoArquivos] [bit] NULL,
	[loginAlternativo] [varchar](50) NULL,
	[DbCPF] [varchar](11) NULL,
	[DbCNPJ] [varchar](14) NULL,
 CONSTRAINT [PK_FILIAL] PRIMARY KEY NONCLUSTERED 
(
	[cd_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FILIAL_34_1603445432__K1_K27_K26_K29_K24_K28_2_3_30_33] ON [dbo].[FILIAL]
(
	[cd_filial] ASC,
	[cd_banco] ASC,
	[nm_titular_cta] ASC,
	[nr_conta] ASC,
	[cd_tipo_faturamento] ASC,
	[nr_agencia] ASC
)
INCLUDE([nm_filial],[nr_cgc],[dt_vencimento],[qt_incremento_mes_fatura]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_FILIAL_9_1581001159] ON [dbo].[FILIAL]
(
	[cd_filial] ASC,
	[nm_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FILIAL] ON [dbo].[FILIAL]
(
	[BaiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FILIAL_1] ON [dbo].[FILIAL]
(
	[cd_clinica] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FILIAL_2] ON [dbo].[FILIAL]
(
	[CidID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_FILIAL_3] ON [dbo].[FILIAL]
(
	[nm_filial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_FILIAL_4] ON [dbo].[FILIAL]
(
	[ufId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_Filial_Banco] ON [dbo].[FILIAL]
(
	[cd_banco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[FILIAL] ADD  CONSTRAINT [DF_FILIAL_fl_consultorio]  DEFAULT ((0)) FOR [fl_consultorio]
ALTER TABLE [dbo].[FILIAL]  WITH CHECK ADD  CONSTRAINT [FK_ClinicaSubstituta] FOREIGN KEY([cd_filialSubstituta])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[FILIAL] CHECK CONSTRAINT [FK_ClinicaSubstituta]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Filial|&' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nm_filial'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CGC' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nr_cgc'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Responsável' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nm_responsavel'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cep' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'LogCep'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Tipo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'CHAVE_TIPOLOGRADOURO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Endereço' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'EndLogradouro'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Número' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'EndNumero'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Complemento' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'EndComplemento'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bairro' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'BaiId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Município' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'CidID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'UF' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'ufId'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Clinica|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'cd_clinica'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Online|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'fl_online'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Consultorio' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'fl_consultorio'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Ativa|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'fl_ativa'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Dias Intervalo Consulta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'fl_DiasIntervaloConsultaVar'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Senha' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'senha'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Nome Titular Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nm_titular_cta'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Banco' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'cd_banco'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Agencia' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nr_agencia'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Conta' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FILIAL', @level2type=N'COLUMN',@level2name=N'nr_conta'
