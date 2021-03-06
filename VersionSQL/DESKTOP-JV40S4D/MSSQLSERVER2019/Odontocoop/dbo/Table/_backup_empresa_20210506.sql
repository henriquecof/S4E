/****** Object:  Table [dbo].[_backup_empresa_20210506]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[_backup_empresa_20210506](
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
	[portalMovimentacaoCadastral] [bit] NULL
) ON [PRIMARY]
