/****** Object:  Table [dbo].[Tipo_Pagamento_Auxiliar]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Pagamento_Auxiliar](
	[cd_tipo_pagamento] [int] NOT NULL,
	[cd_parcela] [int] NOT NULL,
	[cd_tipo_pagamento_Destino] [int] NOT NULL,
 CONSTRAINT [PK_Tipo_Pagamento_Auxiliar] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC,
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Tipo_Pagamento_Auxiliar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tipo_Pagamento_Auxiliar_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Tipo_Pagamento_Auxiliar] CHECK CONSTRAINT [FK_Tipo_Pagamento_Auxiliar_TIPO_PAGAMENTO]
ALTER TABLE [dbo].[Tipo_Pagamento_Auxiliar]  WITH NOCHECK ADD  CONSTRAINT [FK_Tipo_Pagamento_Auxiliar_TIPO_PAGAMENTO1] FOREIGN KEY([cd_tipo_pagamento_Destino])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[Tipo_Pagamento_Auxiliar] CHECK CONSTRAINT [FK_Tipo_Pagamento_Auxiliar_TIPO_PAGAMENTO1]
