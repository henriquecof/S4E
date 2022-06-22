/****** Object:  Table [dbo].[TB_OrigemCartao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_OrigemCartao](
	[Codigo_OrigemCartao] [int] NOT NULL,
	[Descricao] [varchar](50) NOT NULL,
	[Exige_CV] [smallint] NOT NULL,
	[Exige_Doc] [smallint] NOT NULL,
	[Exige_CodigoAutorizacao] [smallint] NOT NULL,
	[transacaoWeb] [bit] NULL,
	[id_TipoOrigemCartao] [int] NULL,
 CONSTRAINT [PK_TB_OrigemCartao] PRIMARY KEY CLUSTERED 
(
	[Codigo_OrigemCartao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
