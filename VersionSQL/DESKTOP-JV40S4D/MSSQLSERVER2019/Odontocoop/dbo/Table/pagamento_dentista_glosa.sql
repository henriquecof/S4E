/****** Object:  Table [dbo].[pagamento_dentista_glosa]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[pagamento_dentista_glosa](
	[cd_sequencial] [int] NOT NULL,
	[cd_sequencial_pp] [int] NOT NULL,
	[vl_servico] [money] NOT NULL,
	[ds_motivo] [varchar](500) NOT NULL,
	[dt_glosa] [datetime] NULL,
 CONSTRAINT [PK_pagamento_dentista_glosa] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC,
	[cd_sequencial_pp] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[pagamento_dentista_glosa] ADD  CONSTRAINT [DF_pagamento_dentista_glosa_dt_glosa]  DEFAULT (getdate()) FOR [dt_glosa]
