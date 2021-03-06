/****** Object:  Table [dbo].[Configuracao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Configuracao](
	[cd_configuracao] [smallint] IDENTITY(1,1) NOT NULL,
	[nome_site] [varchar](100) NOT NULL,
	[Pronome] [varchar](1) NOT NULL,
	[URL_Site] [varchar](100) NOT NULL,
	[Pasta_Site] [varchar](100) NOT NULL,
	[Pasta_Site_SQL] [varchar](100) NOT NULL,
	[Email_Assinatura] [varchar](100) NOT NULL,
	[Nome_Email_Remetente] [varchar](100) NOT NULL,
	[Email_Remetente] [varchar](100) NOT NULL,
	[Email_Reply] [varchar](100) NOT NULL,
	[Email_Suporte] [varchar](100) NOT NULL,
	[Telefone_Geral] [varchar](10) NOT NULL,
	[cd_modelo_biometria] [smallint] NULL,
	[nr_ANS] [varchar](6) NOT NULL,
	[nr_cnpj] [varchar](14) NOT NULL,
	[RazaoSocial] [varchar](100) NOT NULL,
	[ProcPendImpressaoEntrada] [bit] NOT NULL,
	[EndCompleto] [varchar](1000) NOT NULL,
	[MarcarPlanoTratamento] [bit] NOT NULL,
	[ComplementoCadastral] [bit] NOT NULL,
	[NF_orcamento] [bit] NULL,
	[QtDiasExameInicial] [int] NOT NULL,
	[fl_exibe_rateio] [bit] NULL,
	[fl_contr_cred_ADM] [bit] NULL,
	[QtDiasPergTelefone] [smallint] NOT NULL,
	[TP_Parcelas_IR] [varchar](10) NULL,
	[fl_Baixa_com_Orca_Pago] [bit] NULL,
	[fl_Multiplas_Clinicas] [bit] NULL,
	[fl_Imprimir_Saida_Incompleta] [bit] NULL,
	[fl_Exibir_Produt_Dentista_Interno] [bit] NULL,
	[fl_UsaCpfVirtual] [bit] NULL,
	[fl_MarcacaoSomenteClienteAut] [bit] NULL,
	[fl_OrcamentoGravaSemFormPag] [bit] NULL,
	[TipoBaixaOrcamento] [tinyint] NULL,
	[fl_Imprime_Exame_Inicial] [bit] NULL,
	[DescontoPadrao] [money] NULL,
	[qt_marc_orto_mes] [tinyint] NULL,
	[fl_exibir_contatos_cliente] [bit] NULL,
	[URL_CorporativoS4E] [varchar](100) NULL,
	[LicencaS4E] [varchar](50) NULL,
	[fl_BaixaAgendaContinuo] [bit] NULL,
	[fl_Exibe_Todos_Bancos_Previsto] [bit] NULL,
	[fl_Maior14a_aumentaProdDent] [bit] NULL,
	[tpmId] [tinyint] NULL,
	[Valor_Acrecimo14anos] [money] NULL,
	[taeId] [tinyint] NULL,
	[NFeQuantidadeRpsLote] [smallint] NULL,
	[PermiteCancBaixaAgenda] [bit] NULL,
	[QtMesesBaixaTituloAns] [tinyint] NOT NULL,
	[tsiId] [tinyint] NULL,
	[fl_exibir_dados_dentista] [bit] NULL,
	[fl_orcamentoUnico] [bit] NULL,
	[fl_ImpressaoTermoOrcamento] [bit] NULL,
	[sviSIP_Chave] [varchar](20) NULL,
	[toleranciaPonto] [smallint] NULL,
	[fl_CRMVisualizacaoUnificada] [bit] NULL,
	[fl_NaoChecarStatusBaixa] [bit] NULL,
	[fl_BaixaAutoExameOdontograma] [bit] NULL,
	[fl_calcula_prorata] [bit] NULL,
	[cd_tipoautorizador] [tinyint] NULL,
	[fl_NrContratoManual] [bit] NULL,
	[fl_gera_carteira] [bit] NULL,
	[cd_padrao_senha_dentista] [int] NULL,
	[cd_padrao_sequencial_dep] [int] NULL,
	[cd_padrao_numero_contrato] [int] NULL,
	[fl_valor_proc_GTO] [int] NULL,
	[fl_ExibirCarenciaPreCadastro] [bit] NULL,
	[Texto_CoordenadorTiss] [varchar](max) NULL,
	[cd_regra_baixa_agenda] [tinyint] NULL,
	[mod_contratacao] [smallint] NULL,
	[cd_tipo_usuario_autorizacao] [tinyint] NULL,
	[DiasValidadeGTO] [int] NULL,
	[fl_ConsiderarUrgenciaBaixa] [bit] NULL,
	[IdadeMaxDesconsiderarBiometria] [tinyint] NULL,
	[qt_VidasTiraCarenciaEmpresa] [int] NULL,
	[fl_DiscriminacaoOrtoNF] [bit] NULL,
	[qt_DiasExpiracaoProcedimento] [int] NULL,
	[fl_ExibirPontuacaoAutorizador] [bit] NULL,
	[fl_UsaNrCarteira] [bit] NULL,
	[fl_BuscaExternaAssociadoDetalhada] [bit] NULL,
	[fl_buscaNumericaEmpresa] [bit] NULL,
	[fl_buscaNumericaColaborador] [bit] NULL,
	[fl_ReaproveitarGTO] [bit] NULL,
	[QtLimiteMesesProdAndamentoDentista] [tinyint] NULL,
	[fl_ImprimirProcedimentoPendenteGTO] [bit] NULL,
	[fl_ParcelasAbertas_SitCancelado] [bit] NULL,
	[email_faturamento] [varchar](100) NULL,
	[FL_ImprimeRecAutomatc] [bit] NULL,
	[fl_CalcProdCenCusto] [bit] NULL,
	[tipoRPC] [tinyint] NULL,
	[cd_Centrocusto_padraoprodutividade] [smallint] NULL,
	[fl_Empresa_EndCobranca] [bit] NULL,
	[DiasLimiteRecursoGlosa] [smallint] NULL,
	[LocalTabelaPagamentoDentista] [tinyint] NULL,
	[RefAtualizacaoTabelaDentista] [tinyint] NULL,
	[TipoValorCalculoProdutividadeDentista] [tinyint] NULL,
	[fl_UsaPainelAtendimento] [bit] NULL,
	[qt_meses_cancela_regaux_pf] [smallint] NULL,
	[qt_meses_renegocia_regaux_pf] [smallint] NULL,
	[TipoVisualizacaoUtilizacaoFichaClinica] [tinyint] NULL,
	[cd_InconsistenciaAgrupada] [tinyint] NULL,
	[qt_meses_cancela_regaux_pj] [smallint] NULL,
	[qt_meses_renegocia_regaux_pj] [smallint] NULL,
	[TipoImportacaoCobertura] [tinyint] NULL,
	[ConfirmacaoTelefoneObrigatorio] [bit] NULL,
	[TipoVisualizacaoProcRealizadoFichaClinica] [tinyint] NULL,
	[TipoChecagemProcPendenteRepetido] [tinyint] NULL,
	[fl_bloqueioacesso] [bit] NULL,
	[TipoVisualizacaoPlanoANS] [tinyint] NULL,
	[ExibirNegativaGTO] [bit] NULL,
	[fl_mostraCodigoConta] [bit] NULL,
	[TipoParcelaVinculadaCobranca] [tinyint] NULL,
	[fl_MostraUploadPreCadastro] [bit] NULL,
	[UsuarioCorrelacionadoAutomatico] [bit] NULL,
	[FinanceiroPlanoContasProprio] [bit] NULL,
	[cd_padrao_senha_clinica] [tinyint] NULL,
	[fl_AnexoEmpresa] [bit] NULL,
	[fl_PrecoPlanoEmpresaCorretor] [bit] NULL,
	[fl_ContatoEmpresaCorretor] [bit] NULL,
	[cd_sem_equipe] [smallint] NULL,
	[ProgramacaoAtendimentoCompartilhado] [bit] NULL,
	[email_faturamento_PF] [varchar](100) NULL,
	[ExibirProdutosRedeAtendimento] [bit] NULL,
	[fl_calculaMultaContratual] [bit] NULL,
	[EnviarEmailAutomaticoCRM] [bit] NULL,
	[EnviarConfConsultaEmailPac] [bit] NULL,
	[TipoBuscaExternaAssociadoDetalhada] [tinyint] NULL,
	[DataImplantacaoSistema] [date] NULL,
	[QtDiasBloqueioProcedimento] [tinyint] NULL,
	[tipo_imp_regaux_emipf] [smallint] NULL,
	[tipo_DtEmissao_RegAux_Emipf] [smallint] NULL,
	[tipo_imp_regaux_emipj] [smallint] NULL,
	[tipo_DtEmissao_RegAux_Emipj] [smallint] NULL,
	[tipo_DataVendaContrato] [tinyint] NULL,
	[qt_dias_expira_boletovirtual] [smallint] NULL,
	[fl_geracomissaoseparado] [bit] NULL,
	[NomeFantasia] [varchar](100) NULL,
	[cd_tabelaCalculoRescisao] [smallint] NULL,
	[cd_tabelaCalculoPIN] [int] NULL,
	[ConsiderarCartaoPrevistoCallCenter] [bit] NULL,
	[fl_envia_email_fatautomatico] [smallint] NULL,
	[TipoLiberacaoVisualizacaoLoteFechadoPrestador] [tinyint] NULL,
	[fl_OrcamentoFechaSemPagTotal] [bit] NULL,
	[NegativaGTOCarencia] [bit] NULL,
	[DiasSemanaGeracaoGTO] [varchar](13) NULL,
	[fl_exibirPeriodoDataBase] [bit] NULL,
	[responsavel_faturamento] [varchar](100) NULL,
	[telefone_faturamento] [varchar](100) NULL,
	[autorizarLancamento] [bit] NULL,
	[QtDiasPergTelefoneDentista] [tinyint] NULL,
	[gearman] [bit] NULL,
	[usarEnderecoBoleto] [tinyint] NULL,
	[exigecontatodependenteprecadastro] [smallint] NULL,
	[utilizaTabelaTextoContratos] [bit] NULL,
	[chatSrc] [varchar](200) NULL,
	[autorizadorAgenda] [bit] NULL,
	[fl_BloqueioProvisionado] [bit] NULL,
	[versaoTissMonitor] [smallint] NULL,
	[fl_utilizaProtocoloPreCadastro] [bit] NULL,
	[flExigeConfirmacaoDoc] [bit] NULL,
	[flExigeConfirmacaoAut] [bit] NULL,
	[flExigeConfirmacaoCV] [bit] NULL,
	[vidas_empresa_vip] [int] NULL,
	[ocultarRecuperadoPrevistoGerenciaCallcenter] [bit] NULL,
	[tipoOdontogramaPadrao] [tinyint] NULL,
	[spcCpfCnpjAssociadoEmpresa] [bit] NULL,
	[usarfaturaeletronicacompleta] [bit] NULL,
	[exigeObrigatoriedadeCompCadastral] [bit] NOT NULL,
	[versaoGearMan] [varchar](10) NULL,
	[aceita_remarcar_consulta] [bit] NULL,
	[codigoContasFinanceirasTaxas] [varchar](4) NULL,
	[chaveGoogleMaps] [varchar](100) NULL,
	[mdeId] [smallint] NULL,
	[fl_Inconsistencia_CoParticipacao] [bit] NULL,
	[abrangenciaRegionalRedeAtendimento] [bit] NULL,
	[usarLoginCorretor] [bit] NULL,
	[qt_lote_visualizacao_produtividade_prestador] [tinyint] NULL,
	[canalAtendimento] [varchar](200) NULL,
	[usaPercentualValorFixoParametroComissao] [bit] NULL,
	[validadeDenteHigido] [tinyint] NULL,
	[regAuxRec_Competencia] [tinyint] NULL,
	[disqueAns] [varchar](15) NULL,
	[siteAns] [varchar](50) NULL,
	[fl_exibirTipoFaturamento] [bit] NULL,
	[UsarConveniosExternos] [bit] NOT NULL,
	[tipoValorEnvioDMED] [tinyint] NULL,
	[localCentroCustoEnvioDMED] [tinyint] NULL,
	[incluirProcPartProdutividade] [bit] NULL,
	[acertoPrestadorBruto] [bit] NULL,
	[DesmembrarPrevisto] [bit] NULL,
	[tipoChecagemInconsistencia] [tinyint] NULL,
	[AceitaExclusaoProcedimentoDentista] [bit] NULL,
	[avisarPrestadorLiberacaoProcedimento] [tinyint] NULL,
	[utilizaDatacompetenciaSIB] [tinyint] NULL,
	[exibiDataInstituicaoFinanceira] [bit] NULL,
	[biometriaFacial] [bit] NULL,
	[AceitaProcedimentoDenteAusente] [bit] NULL,
	[exibirPrevisaoSolucaoExternoCRM] [bit] NULL,
	[fl_ExibeTipoPreco] [int] NULL,
	[nmMunicipioPrestador] [varchar](50) NULL,
	[ufSiglaPrestador] [varchar](2) NULL,
	[acaoBaixaOrtoPlanejamentoOrto] [tinyint] NULL,
	[RealizarPrevistoEmMassa] [bit] NULL,
	[ExibeValorProtocolo] [bit] NULL,
	[qt_DiasExpiracaoProcedimentoRealizado] [int] NULL,
	[qt_MesesCompetenciaPagamentoPrestador] [tinyint] NULL,
	[inicioContagemDiasCarencia] [tinyint] NULL,
	[tipoExibicaoRedeCredenciada] [tinyint] NULL,
	[TipoSubstituicaoAgenda] [tinyint] NULL,
	[cadSusCnesCnes] [varchar](50) NULL,
	[cadSusCnesUsuario] [varchar](50) NULL,
	[cadSusCnesSenha] [varchar](50) NULL,
	[calculo_ppsc] [smallint] NULL,
	[visualizaCarteiraPortal] [bit] NULL,
	[Telefone_Secundario] [varchar](10) NULL,
	[auditoriaClinicoPagamentoProtocolo] [bit] NULL,
	[colaborador_app] [int] NULL,
	[qtdeRecursoGlosaGTO] [tinyint] NULL,
	[cadSusClientCredentialsUserName] [varchar](50) NULL,
	[cadSusClientCredentialsPassword] [varchar](50) NULL,
	[cd_tipo_pagamento_odontocob] [varchar](100) NULL,
	[cep_operadora] [varchar](8) NULL,
	[end_numero_operadora] [int] NULL,
	[limitePausaManutencaoOrto] [tinyint] NULL,
	[confirmacaoContatoBeneficiarioPorPrestador] [bit] NULL,
	[confirmacaoContatoBeneficiarioPorColaborador] [bit] NULL,
	[agruparComissoesPorAdesionista] [bit] NULL,
	[LiberaPercEspecialidadeDentista] [tinyint] NULL,
	[qtdeLimiteRegistrosPaginaAnaliseAssinatura] [int] NULL,
	[qtdeLimiteRegistrosPaginaAnaliseDocumentacao] [int] NULL,
	[motivosExclusaoCrm] [varchar](100) NULL,
	[incluiMensalidadesAgrupadasElegibilidade] [bit] NULL,
	[multiSelectMarcacaoConsulta] [tinyint] NULL,
	[visualizaEmpresasLoginEmpresaGrupo] [bit] NULL,
	[tipoExtensaoArquivoSimples] [varchar](500) NULL,
	[tipoExtensaoArquivo] [varchar](max) NULL,
	[diaCorteFaturamentoDigital] [tinyint] NULL,
	[EnderecoChatExterno] [varchar](300) NULL,
	[elegibilidadeTokenSMS] [bit] NULL,
	[fl_exibeValorCanceladoRelContraprestacaoPecuniaria] [tinyint] NULL,
	[EmailsNotificacaoNovoCentroCusto] [varchar](1000) NULL,
	[formularioOdontogramaPadrao] [tinyint] NULL,
	[TipoFiltroCentroCusto] [varchar](10) NULL,
	[permiteLoginMultiplo] [bit] NULL,
	[permiteDesmarcarConsultaPassada] [bit] NULL,
	[permitirBuscaPrestadorPlanoNaoClassificado] [bit] NULL,
	[tipoFormularioLogin] [tinyint] NULL,
	[fl_separarproducaocompetencia] [bit] NULL,
	[ConvenioCnabSantander] [varchar](25) NULL,
	[fl_CalcProdConvenio] [bit] NULL,
	[procedimentoImportadoRegrasPontos] [bit] NULL,
	[exibirNumeroGTOProcedimentoPendente] [bit] NULL,
	[checkRXGrupoDentes] [bit] NULL,
	[mesesCheckRXGrupoDentes] [smallint] NULL,
	[permiteMarcacaoAvulsaPrestador] [tinyint] NULL,
 CONSTRAINT [PK_Configuracao] PRIMARY KEY CLUSTERED 
(
	[cd_configuracao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

ALTER TABLE [dbo].[Configuracao] ADD  CONSTRAINT [DF__Configura__QtMes__4314C8ED]  DEFAULT ((3)) FOR [QtMesesBaixaTituloAns]
ALTER TABLE [dbo].[Configuracao] ADD  DEFAULT ((1)) FOR [exigeObrigatoriedadeCompCadastral]
ALTER TABLE [dbo].[Configuracao] ADD  DEFAULT ((0)) FOR [UsarConveniosExternos]
ALTER TABLE [dbo].[Configuracao]  WITH CHECK ADD  CONSTRAINT [FK_Configuracao_equipe_vendas] FOREIGN KEY([cd_sem_equipe])
REFERENCES [dbo].[equipe_vendas] ([cd_equipe])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_Configuracao_equipe_vendas]
ALTER TABLE [dbo].[Configuracao]  WITH NOCHECK ADD  CONSTRAINT [FK_Configuracao_modelo_biometria] FOREIGN KEY([cd_modelo_biometria])
REFERENCES [dbo].[modelo_biometria] ([cd_modelo_Biometria])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_Configuracao_modelo_biometria]
ALTER TABLE [dbo].[Configuracao]  WITH NOCHECK ADD  CONSTRAINT [FK_Configuracao_TipoAcaoConclusaoExameClinico] FOREIGN KEY([taeId])
REFERENCES [dbo].[TipoAcaoConclusaoExameClinico] ([taeId])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_Configuracao_TipoAcaoConclusaoExameClinico]
ALTER TABLE [dbo].[Configuracao]  WITH NOCHECK ADD  CONSTRAINT [FK_Configuracao_TipoProximaDataMarcacao] FOREIGN KEY([tpmId])
REFERENCES [dbo].[TipoProximaDataMarcacao] ([tpmId])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_Configuracao_TipoProximaDataMarcacao]
ALTER TABLE [dbo].[Configuracao]  WITH CHECK ADD  CONSTRAINT [FK_Configuracao_VersaoTissMonitor] FOREIGN KEY([versaoTissMonitor])
REFERENCES [dbo].[VersaoTissMonitor] ([id])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_Configuracao_VersaoTissMonitor]
ALTER TABLE [dbo].[Configuracao]  WITH CHECK ADD  CONSTRAINT [FK_CRMMotivoDetalhado_mdeId] FOREIGN KEY([mdeId])
REFERENCES [dbo].[CRMMotivoDetalhado] ([mdeId])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_CRMMotivoDetalhado_mdeId]
ALTER TABLE [dbo].[Configuracao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Configuracao_TipoSistema] FOREIGN KEY([tsiId])
REFERENCES [dbo].[TipoSistema] ([tsiId])
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [FK_TB_Configuracao_TipoSistema]
ALTER TABLE [dbo].[Configuracao]  WITH CHECK ADD  CONSTRAINT [CHK_TipoFiltroCentroCusto] CHECK  (([TipoFiltroCentroCusto]='MUNICIPIO' OR [TipoFiltroCentroCusto]='EMPRESA' OR [TipoFiltroCentroCusto]='ASSOCIADO'))
ALTER TABLE [dbo].[Configuracao] CHECK CONSTRAINT [CHK_TipoFiltroCentroCusto]
