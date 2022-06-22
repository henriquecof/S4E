/****** Object:  Table [dbo].[arquivo_pagamento_dentista_lancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[arquivo_pagamento_dentista_lancamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_pgto_dentista_lanc] [int] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[nome] [varchar](50) NOT NULL,
	[extensao] [varchar](5) NOT NULL,
	[usuarioInclusao] [int] NULL,
	[dataInclusao] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento]  WITH CHECK ADD  CONSTRAINT [FK_funcionario_cd_funcionario_Exclusao] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento] CHECK CONSTRAINT [FK_funcionario_cd_funcionario_Exclusao]
ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento]  WITH CHECK ADD  CONSTRAINT [FK_funcionario_cd_funcionario_Inclusao] FOREIGN KEY([usuarioInclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento] CHECK CONSTRAINT [FK_funcionario_cd_funcionario_Inclusao]
ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento]  WITH CHECK ADD  CONSTRAINT [FK_pagamento_dentista_lancamento_cd_pgto_dentista_lanc] FOREIGN KEY([cd_pgto_dentista_lanc])
REFERENCES [dbo].[Pagamento_Dentista_Lancamento] ([cd_pgto_dentista_lanc])
ALTER TABLE [dbo].[arquivo_pagamento_dentista_lancamento] CHECK CONSTRAINT [FK_pagamento_dentista_lancamento_cd_pgto_dentista_lanc]
