/****** Object:  Table [dbo].[TIPO_PAGAMENTO_resumo]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TIPO_PAGAMENTO_resumo](
	[tp_pagamento_resumo] [int] NOT NULL,
	[ds_pagamento_resumo] [varchar](50) NOT NULL,
	[tp_empresa] [smallint] NOT NULL,
 CONSTRAINT [PK_TIPO_PAGAMENTO_resumo] PRIMARY KEY CLUSTERED 
(
	[tp_pagamento_resumo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TIPO_PAGAMENTO_resumo] ADD  CONSTRAINT [DF_TIPO_PAGAMENTO_resumo_tp_empresa]  DEFAULT ((1)) FOR [tp_empresa]
