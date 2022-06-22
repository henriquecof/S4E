/****** Object:  Table [dbo].[Conferencia_ANS]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Conferencia_ANS](
	[dataAtualizacao] [varchar](10) NULL,
	[situacao] [varchar](20) NULL,
	[cco] [varchar](30) NULL,
	[cpf] [varchar](30) NULL,
	[cns] [varchar](30) NULL,
	[nome] [varchar](60) NULL,
	[sexo] [smallint] NULL,
	[dataNascimento] [varchar](10) NULL,
	[nomeMae] [varchar](60) NULL,
	[logradouro] [varchar](100) NULL,
	[numero] [varchar](8) NULL,
	[bairro] [varchar](100) NULL,
	[codigoMunicipio] [int] NULL,
	[cep] [varchar](8) NULL,
	[resideExterior] [bit] NULL,
	[codigoBeneficiario] [varchar](100) NULL,
	[relacaoDependencia] [smallint] NULL,
	[dataContratacao] [varchar](10) NULL,
	[dataCancelamento] [varchar](10) NULL,
	[motivoCancelamento] [smallint] NULL,
	[numeroPlanoANS] [varchar](50) NULL,
	[coberturaParcialTemporaria] [smallint] NULL,
	[itensExcluidosCobertura] [smallint] NULL,
	[cnpjEmpresaContratante] [varchar](14) NULL,
	[cd_sequencial_dep] [int] NULL,
	[dataReativacao] [varchar](10) NULL,
	[ccoBeneficiarioTitular] [varchar](50) NULL,
	[numeroLinhaRegistro] [bigint] NULL,
	[numeroArquivo] [tinyint] NULL,
	[totalRegArquivo] [bigint] NULL,
	[agrupadorLoteVerificacao] [int] NULL,
	[verificado] [bit] NULL,
	[caepfEmpresaContratante] [varchar](14) NULL,
	[ceiEmpresaContratante] [varchar](14) NULL,
	[nomeArquivo] [varchar](300) NULL
) ON [PRIMARY]

SET ANSI_PADDING ON

CREATE NONCLUSTERED INDEX [_dta_index_Conferencia_ans_56_667878192__K26_K5_K3_K6_K41] ON [dbo].[Conferencia_ANS]
(
	[cco] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
