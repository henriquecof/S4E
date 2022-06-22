/****** Object:  Table [dbo].[sispag_retorno_registros]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[sispag_retorno_registros](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[sequencial_FormaLancamento] [int] NOT NULL,
	[IdLote] [int] NOT NULL,
	[linha] [int] NOT NULL,
	[dt_vencimento] [datetime] NULL,
	[dt_pagamento] [datetime] NULL,
	[valor_documento] [money] NULL,
	[valor_pagamento] [money] NULL,
	[cd_ocorrencia1] [smallint] NULL,
	[cd_ocorrencia2] [smallint] NULL,
	[cd_ocorrencia3] [smallint] NULL,
	[cd_ocorrencia4] [smallint] NULL,
	[cd_ocorrencia5] [smallint] NULL,
	[obs] [varchar](1000) NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[sispag_retorno_registros]  WITH CHECK ADD  CONSTRAINT [FK_lote_sispag_retorno_id] FOREIGN KEY([IdLote])
REFERENCES [dbo].[lote_sispag_retorno] ([Id])
ALTER TABLE [dbo].[sispag_retorno_registros] CHECK CONSTRAINT [FK_lote_sispag_retorno_id]
