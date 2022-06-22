/****** Object:  Table [dbo].[Taxas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Taxas](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipo_pagamento] [int] NULL,
	[tipo_parcela] [smallint] NULL,
	[vencimento_inicial] [datetime] NULL,
	[vencimento_final] [datetime] NULL,
	[corte] [smallint] NULL,
	[porcentagem] [smallint] NULL,
	[valor] [money] NULL,
 CONSTRAINT [PK_Taxas] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Taxas]  WITH CHECK ADD  CONSTRAINT [FK_Taxas_TIPO_PAGAMENTO] FOREIGN KEY([tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Taxas] CHECK CONSTRAINT [FK_Taxas_TIPO_PAGAMENTO]
ALTER TABLE [dbo].[Taxas]  WITH CHECK ADD  CONSTRAINT [FK_Taxas_Tipo_parcela] FOREIGN KEY([tipo_parcela])
REFERENCES [dbo].[Tipo_parcela] ([cd_tipo_parcela])
ALTER TABLE [dbo].[Taxas] CHECK CONSTRAINT [FK_Taxas_Tipo_parcela]
