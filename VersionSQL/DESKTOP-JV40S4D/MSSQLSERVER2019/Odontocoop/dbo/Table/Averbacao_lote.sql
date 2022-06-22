/****** Object:  Table [dbo].[Averbacao_lote]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Averbacao_lote](
	[cd_sequencial] [int] IDENTITY(1,1) NOT NULL,
	[cd_tipo_servico_bancario] [smallint] NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_finalizado] [datetime] NULL,
	[cd_funcionario] [int] NOT NULL,
	[nsa] [int] NULL,
	[convenio] [varchar](20) NULL,
	[qtde] [int] NULL,
	[valor] [money] NULL,
	[nm_arquivo] [varchar](100) NULL,
 CONSTRAINT [PK_Averbacao_lote] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Averbacao_lote]  WITH NOCHECK ADD  CONSTRAINT [FK_Averbacao_lote_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Averbacao_lote] CHECK CONSTRAINT [FK_Averbacao_lote_TIPO_PAGAMENTO]
ALTER TABLE [dbo].[Averbacao_lote]  WITH NOCHECK ADD  CONSTRAINT [FK_Averbacao_lote_tipo_servico_bancario] FOREIGN KEY([cd_tipo_servico_bancario])
REFERENCES [dbo].[tipo_servico_bancario] ([cd_tipo_servico_bancario])
ALTER TABLE [dbo].[Averbacao_lote] CHECK CONSTRAINT [FK_Averbacao_lote_tipo_servico_bancario]
