/****** Object:  Table [dbo].[Boleto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Boleto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_sequencial_lote] [int] NOT NULL,
	[cd_associado_empresa] [varchar](50) NULL,
	[cd_parcela] [varchar](50) NULL,
	[cedente] [varchar](300) NULL,
	[cnpj] [varchar](14) NOT NULL,
	[dt_vencimento] [varchar](10) NOT NULL,
	[agencia] [varchar](50) NOT NULL,
	[dg_ag] [varchar](50) NULL,
	[conta] [varchar](50) NOT NULL,
	[dg_conta] [varchar](50) NULL,
	[convenio] [varchar](50) NOT NULL,
	[carteira] [varchar](50) NULL,
	[dg_convenio] [varchar](50) NULL,
	[nn] [varchar](50) NOT NULL,
	[valor] [money] NOT NULL,
	[pagador] [varchar](200) NOT NULL,
	[cpf_cnpj_pagador] [varchar](50) NULL,
	[end_pagador] [varchar](200) NULL,
	[bai_pagador] [varchar](200) NULL,
	[cep_pagador] [varchar](8) NULL,
	[mun_pagador] [varchar](50) NULL,
	[uf_pagador] [varchar](2) NULL,
	[linha] [varchar](100) NULL,
	[barra] [varchar](44) NULL,
	[vl_multa] [money] NULL,
	[vl_juros] [money] NULL,
	[instrucao1] [varchar](100) NULL,
	[instrucao2] [varchar](100) NULL,
	[instrucao3] [varchar](100) NULL,
	[instrucao4] [varchar](100) NULL,
	[cod_barra] [varchar](220) NULL,
	[instrucao5] [varchar](100) NULL,
	[instrucao6] [varchar](100) NULL,
	[count_Parcela] [int] NULL,
	[fl_lotebanco] [bit] NULL,
 CONSTRAINT [PK_Boleto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [IX_Boleto] ON [dbo].[Boleto]
(
	[cd_sequencial_lote] ASC,
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
