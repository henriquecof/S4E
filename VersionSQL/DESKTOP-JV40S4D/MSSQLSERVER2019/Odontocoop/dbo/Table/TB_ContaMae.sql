/****** Object:  Table [dbo].[TB_ContaMae]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaMae](
	[Sequencial_ContaMae] [int] IDENTITY(1,1) NOT NULL,
	[Codigo_ContaMae] [varchar](10) NOT NULL,
	[Descricao_ContaMae] [varchar](80) NOT NULL,
	[Tipo_Conta] [smallint] NOT NULL,
	[Tipo_Classificacao] [smallint] NOT NULL,
	[nome_usuario] [varchar](20) NULL,
	[Conta_Lancamento] [int] NULL,
	[Codigo_FluxoCaixa] [int] NULL,
	[Codigo_DRE] [int] NULL,
	[cd_contaresultado_contabil] [int] NULL,
 CONSTRAINT [PK_TB_ContaMae] PRIMARY KEY CLUSTERED 
(
	[Sequencial_ContaMae] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
