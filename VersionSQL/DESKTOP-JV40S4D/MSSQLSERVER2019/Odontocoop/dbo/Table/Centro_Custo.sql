/****** Object:  Table [dbo].[Centro_Custo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Centro_Custo](
	[cd_centro_custo] [smallint] IDENTITY(1,1) NOT NULL,
	[ds_centro_custo] [varchar](50) NOT NULL,
	[contrato] [bit] NOT NULL,
	[financeiro] [bit] NOT NULL,
	[DiasAtrasTaxaCob] [tinyint] NOT NULL,
	[PercTaxaCobranca] [money] NOT NULL,
	[DiasLimAtrasRecParc] [tinyint] NOT NULL,
	[AceitaAcordo] [bit] NOT NULL,
	[cd_tabela_contabilidade] [int] NOT NULL,
	[CNPJ] [varchar](14) NULL,
	[InscricaoMunicipal] [varchar](10) NULL,
	[NFeNaturezaOperacao] [tinyint] NULL,
	[NFeOptanteSimplesNacional] [tinyint] NULL,
	[NFeIncentivadorCultural] [tinyint] NULL,
	[NFeItemListaServico] [varchar](10) NULL,
	[NFeCodigoTributacaoMunicipio] [varchar](20) NULL,
	[NFeDiscriminacao] [varchar](500) NULL,
	[NFecd_municipio] [int] NULL,
	[tenId] [tinyint] NULL,
	[CNAE] [varchar](15) NULL,
	[NFe_EndWebServ] [varchar](100) NULL,
	[NFe_EndCertificado] [varchar](300) NULL,
	[fl_modulofinanceiro] [bit] NULL,
	[fl_ativo] [bit] NULL,
	[vl_ProlaboreParcelasOrto] [money] NULL,
	[NFe_PwCertificado] [varchar](10) NULL,
	[NFe_AliasCertificado] [varchar](100) NULL,
	[SerieNF] [varchar](10) NULL,
	[nr_ANS] [varchar](6) NULL,
	[end_LogoMarca] [varchar](50) NULL,
	[cd_centro_custoPrinc] [smallint] NULL,
	[nm_fantasia] [varchar](100) NULL,
	[PastaLayoutPersonalizado] [varchar](50) NULL,
	[PercValorPadrao_Dentista] [money] NULL,
	[PercValorPadrao_Funcionario] [money] NULL,
	[TipoDescontoFinanceiro] [tinyint] NULL,
	[ValorMaxDescontoFinanceiro] [money] NULL,
	[cc_codigoLoja] [int] NULL,
	[perc_receitavista] [float] NULL,
	[perc_despesaprodutividade] [float] NULL,
	[vl_receitavista] [money] NULL,
	[vl_despesaprodutividade] [money] NULL,
	[PercValorPadrao_DentistaMax] [money] NULL,
	[PercValorPadrao_FuncionarioMax] [money] NULL,
	[taxaOperacaoCielo] [money] NULL,
	[taxaOperacaoRede] [money] NULL,
	[taxaOperacaoCenterCob] [money] NULL,
	[impostoIntermediadora] [money] NULL,
	[taxaOperacaoIntermediadora] [money] NULL,
	[percRepasseIntermediadora] [money] NULL,
	[gearman_token] [varchar](25) NULL,
	[aceitaCpfDuplicado] [bit] NULL,
	[vl_RepasseRadiologiaParcelaOrto] [money] NULL,
	[exigeValidacaoProcedimento] [bit] NULL,
	[taxaOperacaoIntermediadoraCentercob] [money] NULL,
	[gerarGratificacaoClinicoPeriodo] [bit] NULL,
	[deducao_pagamento] [money] NULL,
	[formaPagamentoOrcamento] [int] NULL,
	[TipoDescontoFuncionario] [tinyint] NULL,
	[TipoAcrescimoFuncionario] [tinyint] NULL,
	[TipoDescontoDentista] [tinyint] NULL,
	[TipoAcrescimoDentista] [tinyint] NULL,
	[utilizaPlanoParceiro] [bit] NULL,
	[funcionarioVendedorParceiro] [int] NULL,
	[mesesBloqueioAssociado] [tinyint] NULL,
	[emissaoNFFinanceiro] [bit] NULL,
	[tokenNFSe] [varchar](150) NULL,
	[tipoDescontoPadrao] [tinyint] NULL,
	[valorDescontoPadrao] [money] NULL,
	[tipoCustoOperacional2] [tinyint] NULL,
	[tipoCustoOperacional3] [tinyint] NULL,
	[custoOperacional2] [money] NULL,
	[custoOperacional3] [money] NULL,
	[contaContabil] [int] NULL,
	[usaMicroCredito] [bit] NULL,
	[NfeTributacaoMunicipio] [int] NULL,
	[pagamentoGratificacao] [int] NULL,
	[ValorRateio] [money] NULL,
	[percentualImpostoFederal] [varchar](10) NULL,
	[taxaAdm] [money] NULL,
	[atendimentoClinicoEletivo] [bit] NULL,
	[atendimentoClinicoUrgencia] [bit] NULL,
	[abrangenciaCreditoOrcamento] [tinyint] NULL,
	[EndCompleto] [varchar](1000) NULL,
	[DadosNfe] [varchar](8000) NULL,
 CONSTRAINT [PK_Centro_Custo] PRIMARY KEY CLUSTERED 
(
	[cd_centro_custo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IN_Centro_custo_NFecd_municipio] ON [dbo].[Centro_Custo]
(
	[NFecd_municipio] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
ALTER TABLE [dbo].[Centro_Custo]  WITH NOCHECK ADD  CONSTRAINT [FK_Centro_Custo_MUNICIPIO] FOREIGN KEY([NFecd_municipio])
REFERENCES [dbo].[MUNICIPIO] ([CD_MUNICIPIO])
ALTER TABLE [dbo].[Centro_Custo] CHECK CONSTRAINT [FK_Centro_Custo_MUNICIPIO]
ALTER TABLE [dbo].[Centro_Custo]  WITH NOCHECK ADD  CONSTRAINT [FK_Centro_Custo_TipoExportacaoNFe] FOREIGN KEY([tenId])
REFERENCES [dbo].[TipoExportacaoNFe] ([tenId])
ALTER TABLE [dbo].[Centro_Custo] CHECK CONSTRAINT [FK_Centro_Custo_TipoExportacaoNFe]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Centro de Custo|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Centro_Custo', @level2type=N'COLUMN',@level2name=N'ds_centro_custo'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contrato|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Centro_Custo', @level2type=N'COLUMN',@level2name=N'contrato'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Financeiro|' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Centro_Custo', @level2type=N'COLUMN',@level2name=N'financeiro'
EXEC sys.sp_addextendedproperty @name=N'descricaoNfeTributacaoMunicipio', @value=N'0 – Tributação no município; 1 - Tributação fora do município; ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Centro_Custo', @level2type=N'COLUMN',@level2name=N'NfeTributacaoMunicipio'
