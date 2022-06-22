/****** Object:  Table [dbo].[SessionVirtual]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SessionVirtual](
	[sviId] [int] IDENTITY(1,1) NOT NULL,
	[sviDtAcesso] [datetime] NOT NULL,
	[sviDtLimiteConexao] [datetime] NOT NULL,
	[sviChave] [varchar](100) NOT NULL,
	[sviPermissoes] [varchar](5000) NULL,
	[sviCNPJ] [varchar](14) NULL,
	[sviCPF] [varchar](11) NULL,
	[sviTipoUsuario] [tinyint] NOT NULL,
	[sviCodigoUsuario] [int] NULL,
	[sviNomeUsuario] [varchar](100) NULL,
	[sviFavoritosUsuario] [varchar](5000) NULL,
	[sviGrupoUsuario] [bit] NULL,
	[sviCodigoFilial] [int] NULL,
	[sviNomeFilial] [varchar](100) NULL,
	[sviCodigoFilialPadrao] [int] NULL,
	[sviNomeFilialPadrao] [varchar](100) NULL,
	[sviCodigoDentista] [int] NULL,
	[sviNomeDentista] [varchar](100) NULL,
	[sviCodigoCargoDentista] [int] NULL,
	[sviCodigoEspecialidadesDentista] [varchar](100) NULL,
	[sviCRODentista] [varchar](20) NULL,
	[sviCodigoCargoColaborador] [int] NULL,
	[sviRamalInterno] [varchar](11) NULL,
	[sviMultiplasClinicas] [bit] NULL,
	[sviTipoClinicaDentista] [smallint] NULL,
	[sviSIP_id] [varchar](20) NULL,
	[svisSIP_filas] [varchar](300) NULL,
	[sviSIP_Status] [int] NULL,
	[sviSIP_DSStatus] [varchar](60) NULL,
	[sviSIP_MotPausa] [int] NULL,
	[sviSIP_Chave] [varchar](20) NULL,
	[sviSIP_hora_pausa] [varchar](10) NULL,
	[sviSIP_cpf] [varchar](11) NULL,
	[sviSIP_callidnum] [varchar](15) NULL,
	[sviSIP_idchamada] [varchar](30) NULL,
	[sviSIP_DSMotPausa] [varchar](100) NULL,
	[sviCodigoCentroCustoPadrao] [int] NULL,
	[sviCodigoCentroCusto] [int] NULL,
	[sviCentroCustoUsuario] [varchar](1000) NULL,
	[sviCodigoCentroCustoUsuario] [int] NULL,
	[sviNomeCentroCustoUsuario] [varchar](50) NULL,
	[sviMultiplosCentrosCustos] [bit] NULL,
	[sviTipoSistema] [tinyint] NULL,
	[sviTipoAutorizador] [tinyint] NULL,
	[sviTipoBaixaAgenda] [tinyint] NULL,
	[sviPastaLayoutPersonalizado] [varchar](50) NULL,
	[svifl_adesionista] [bit] NULL,
	[sviCPFDentista] [varchar](11) NULL,
	[sviFl_aceitaVenda] [bit] NULL,
	[sviUrgenciaDentista] [bit] NULL,
	[sviDiagnosticoDentista] [bit] NULL,
	[sviVersaoSistemaTelefonia] [tinyint] NULL,
	[sviTipoAcessoUsuario] [tinyint] NULL,
	[sviTipoEmpresa] [tinyint] NULL,
	[sviDiasSemanaGeracaoGTO] [varchar](13) NULL,
	[sviTabelaCoparticipacao] [int] NULL,
	[sviTrocarClinica] [bit] NULL,
	[sviHorariosAcessoSistema] [varchar](50) NULL,
	[sviOdontogramaResumido] [bit] NULL,
	[sviSituacaoUsuario] [int] NULL,
	[sviClassificacaoPlanoANS] [smallint] NULL,
	[sviCodigoDependente] [int] NULL,
	[sviTipoCorretor] [tinyint] NULL,
	[operadorCallCenter] [varchar](50) NULL,
	[sviTokenADMS4E] [varchar](50) NULL,
	[sviDadosAuxiliares] [varchar](1000) NULL,
	[sviAcompanhamentoMediador] [tinyint] NULL,
	[sviInformacoesFinanceirasCorpoClinico] [bit] NULL,
	[sviMenuFaturaEmpresa] [bit] NULL,
	[sviPerfilComercial] [tinyint] NULL,
	[sviAcessoLogin] [bit] NULL,
	[sviCodigoGrupoEmpresa] [int] NULL,
	[sviPericiaFinalDentista] [bit] NULL,
	[sviIntegracaoSistema] [bit] NULL,
	[sviTipoRedeClinica] [tinyint] NULL,
	[sviIPMaquinaLocal] [varchar](15) NULL,
	[sviIP] [varchar](15) NULL,
	[sviTipoValorCalculoProdutividadeDentista] [tinyint] NULL,
 CONSTRAINT [PK_SessionVirtual] PRIMARY KEY CLUSTERED 
(
	[sviId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SessionVirtual] ON [dbo].[SessionVirtual]
(
	[sviChave] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
CREATE NONCLUSTERED INDEX [IX_SessionVirtual_1] ON [dbo].[SessionVirtual]
(
	[sviDtLimiteConexao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [IX_SessionVirtual_2] ON [dbo].[SessionVirtual]
(
	[sviChave] ASC,
	[sviDtLimiteConexao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
