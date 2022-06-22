/****** Object:  Table [dbo].[PontuacaoComercial]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PontuacaoComercial](
	[cd_plano] [int] NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[qt_pontotitular] [int] NULL,
	[qt_pontodependente] [int] NULL,
 CONSTRAINT [PK_PontuacaoComercial] PRIMARY KEY CLUSTERED 
(
	[cd_plano] ASC,
	[cd_tipo_pagamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[PontuacaoComercial]  WITH CHECK ADD  CONSTRAINT [FK_PontuacaoComercial_PLANOS] FOREIGN KEY([cd_plano])
REFERENCES [dbo].[PLANOS] ([cd_plano])
ALTER TABLE [dbo].[PontuacaoComercial] CHECK CONSTRAINT [FK_PontuacaoComercial_PLANOS]
ALTER TABLE [dbo].[PontuacaoComercial]  WITH CHECK ADD  CONSTRAINT [FK_PontuacaoComercial_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[PontuacaoComercial] CHECK CONSTRAINT [FK_PontuacaoComercial_TIPO_PAGAMENTO]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PontuacaoComercial', @level2type=N'COLUMN',@level2name=N'cd_plano'
