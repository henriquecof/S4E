/****** Object:  Table [dbo].[Funcionario_modelo_pagamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Funcionario_modelo_pagamento](
	[cd_funcionario] [int] NOT NULL,
	[cd_modelo] [smallint] NOT NULL,
	[perc_receita] [float] NOT NULL,
	[qt_dependentes] [int] NULL,
	[cd_filialPrestador] [int] NULL,
 CONSTRAINT [PK_Funcionario_modelo_pagamento] PRIMARY KEY CLUSTERED 
(
	[cd_funcionario] ASC,
	[cd_modelo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Funcionario_modelo_pagamento]  WITH CHECK ADD  CONSTRAINT [FK_Funcionario_modelo_pagamento_FILIAL] FOREIGN KEY([cd_filialPrestador])
REFERENCES [dbo].[FILIAL] ([cd_filial])
ALTER TABLE [dbo].[Funcionario_modelo_pagamento] CHECK CONSTRAINT [FK_Funcionario_modelo_pagamento_FILIAL]
ALTER TABLE [dbo].[Funcionario_modelo_pagamento]  WITH NOCHECK ADD  CONSTRAINT [FK_Funcionario_modelo_pagamento_Modelo_Pagamento_Prestador] FOREIGN KEY([cd_modelo])
REFERENCES [dbo].[Modelo_Pagamento_Prestador] ([cd_modelo_pgto_prestador])
ALTER TABLE [dbo].[Funcionario_modelo_pagamento] CHECK CONSTRAINT [FK_Funcionario_modelo_pagamento_Modelo_Pagamento_Prestador]
