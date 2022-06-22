/****** Object:  Table [dbo].[Perc_Tipo_Pagamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Perc_Tipo_Pagamento](
	[cd_tipo_pagamento] [int] NOT NULL,
	[per_retencao] [float] NULL,
	[nome] [varchar](50) NULL,
	[cpf_cnpj] [varchar](14) NULL,
	[fl_dentista] [bit] NULL,
	[variacao] [smallint] NOT NULL,
	[valor_fixo] [float] NULL,
	[cd_funcionario_dentista] [int] NOT NULL,
	[fl_cedente_aux] [bit] NULL,
	[nm_cedente_aux] [varchar](50) NULL,
	[cpf_cnpj_aux] [varchar](14) NULL,
 CONSTRAINT [PK_Perc_Tipo_Pagamento] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC,
	[variacao] ASC,
	[cd_funcionario_dentista] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
