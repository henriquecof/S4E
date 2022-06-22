/****** Object:  Table [dbo].[PATRIMONIOClassificacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOClassificacao](
	[id_Classificacao] [int] IDENTITY(1,1) NOT NULL,
	[descricao_Classificacao] [varchar](200) NOT NULL,
	[perc_depreciacao_anual] [money] NULL,
	[cpc_27_vida_util] [int] NULL,
 CONSTRAINT [PK_PATRIMONIOClassificacao] PRIMARY KEY CLUSTERED 
(
	[id_Classificacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
