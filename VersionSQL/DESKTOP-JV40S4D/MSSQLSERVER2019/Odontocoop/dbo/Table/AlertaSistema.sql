/****** Object:  Table [dbo].[AlertaSistema]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[AlertaSistema](
	[asiId] [int] IDENTITY(1,1) NOT NULL,
	[asiDescricao] [varchar](100) NOT NULL,
	[asiImagem] [varchar](100) NULL,
	[asiURL] [varchar](500) NULL,
	[asiMensagem] [varchar](max) NULL,
	[asiDtCadastro] [datetime] NOT NULL,
	[asiDtExclusao] [datetime] NULL,
	[asiDtInicioExibicao] [datetime] NOT NULL,
	[asiDtFimExibicao] [datetime] NULL,
	[asiExibirAssociado] [bit] NULL,
	[asiExibirEmpresa] [bit] NULL,
	[asiExibirDentista] [bit] NULL,
	[asiExibirClinica] [bit] NULL,
	[asiExibirColaborador] [bit] NULL,
	[asiExibirVendedorPF] [bit] NULL,
	[asiExibirVendedorPJ] [bit] NULL,
	[cd_funcionarioCadastro] [int] NOT NULL,
	[cd_funcionarioExclusao] [int] NULL,
	[centroCustoExibidos] [varchar](200) NULL,
	[link] [varchar](100) NULL,
	[asiAcao] [tinyint] NULL,
	[ufIds] [varchar](100) NULL,
	[municipioIds] [varchar](8000) NULL,
	[filialIds] [varchar](8000) NULL,
	[empresaIds] [varchar](8000) NULL,
	[dependenteIds] [varchar](8000) NULL,
	[ColaboradoresEspecificos] [varchar](255) NULL,
 CONSTRAINT [PK_AlertaSistema] PRIMARY KEY CLUSTERED 
(
	[asiId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
