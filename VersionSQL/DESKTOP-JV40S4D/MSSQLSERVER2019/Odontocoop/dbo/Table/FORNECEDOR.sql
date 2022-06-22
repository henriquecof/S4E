/****** Object:  Table [dbo].[FORNECEDOR]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[FORNECEDOR](
	[CD_FORNECEDOR] [int] IDENTITY(1,1) NOT NULL,
	[NM_FORNECEDOR] [varchar](50) NOT NULL,
	[nr_cgc] [varchar](18) NOT NULL,
	[NM_ENDERECO] [varchar](60) NULL,
	[bairro] [varchar](25) NULL,
	[nr_cep] [varchar](10) NULL,
	[nm_contato] [varchar](30) NULL,
	[FONE1] [varchar](18) NULL,
	[FONE2] [varchar](18) NULL,
	[celular] [varchar](18) NULL,
	[fax] [varchar](18) NULL,
	[CD_MUNICIPIO] [smallint] NULL,
	[CD_UF] [char](2) NULL,
	[email] [varchar](60) NULL,
	[site] [varchar](60) NULL,
	[nome_usuario] [varchar](20) NULL,
 CONSTRAINT [PK_FORNECEDOR] PRIMARY KEY CLUSTERED 
(
	[CD_FORNECEDOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
