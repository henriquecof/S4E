/****** Object:  Table [dbo].[TipoBaixaProcedimentoClinica]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoBaixaProcedimentoClinica](
	[tbcId] [tinyint] NOT NULL,
	[tbcDescricao] [varchar](50) NOT NULL,
 CONSTRAINT [PK_TipoPermissaoBaixaProcedimento] PRIMARY KEY CLUSTERED 
(
	[tbcId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
