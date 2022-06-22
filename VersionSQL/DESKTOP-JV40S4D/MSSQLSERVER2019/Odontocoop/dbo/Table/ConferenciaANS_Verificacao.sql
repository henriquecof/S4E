/****** Object:  Table [dbo].[ConferenciaANS_Verificacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ConferenciaANS_Verificacao](
	[idConfVerif] [int] IDENTITY(1,1) NOT NULL,
	[cco] [varchar](30) NOT NULL,
	[dataAtualizacao] [bit] NULL,
	[situacao] [bit] NULL,
	[cpf] [bit] NULL,
	[cns] [bit] NULL,
	[nome] [bit] NULL,
	[sexo] [bit] NULL,
	[dataNascimento] [bit] NULL,
	[nomeMae] [bit] NULL,
	[logradouro] [bit] NULL,
	[numero] [bit] NULL,
	[bairro] [bit] NULL,
	[codigoMunicipio] [bit] NULL,
	[cep] [bit] NULL,
	[resideExterior] [bit] NULL,
	[codigoBeneficiario] [bit] NULL,
	[relacaoDependencia] [bit] NULL,
	[dataContratacao] [bit] NULL,
	[dataCancelamento] [bit] NULL,
	[motivoCancelamento] [bit] NULL,
	[numeroPlanoANS] [bit] NULL,
	[coberturaParcialTemporaria] [bit] NULL,
	[itensExcluidosCobertura] [bit] NULL,
	[cnpjEmpresaContratante] [bit] NULL,
	[ceiEmpresaContratante] [bit] NULL,
	[caepfEmpresaContratante] [bit] NULL,
	[dataReativacao] [bit] NULL,
	[ccoBeneficiarioTitular] [bit] NULL,
	[ocorrencia] [smallint] NULL,
	[data_verificacao] [datetime] NULL,
	[cd_arquivo_envio_inc] [int] NULL,
	[tipo_Movimentacao] [tinyint] NULL,
	[dataRetorno] [datetime] NULL,
	[mensagemErro] [varchar](1000) NULL,
	[ocorrenciaRetorno] [int] NULL,
 CONSTRAINT [PK_ConferenciaANS_Verificacao] PRIMARY KEY CLUSTERED 
(
	[idConfVerif] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
