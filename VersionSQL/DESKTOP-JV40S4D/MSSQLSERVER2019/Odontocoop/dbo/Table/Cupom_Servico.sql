/****** Object:  Table [dbo].[Cupom_Servico]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Cupom_Servico](
	[Id] [int] NOT NULL,
	[CupomId] [int] NOT NULL,
	[ServicoId] [int] NOT NULL,
	[ValorOriginal] [money] NOT NULL,
	[ValorComDesconto] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Cupom_Servico]  WITH CHECK ADD FOREIGN KEY([CupomId])
REFERENCES [dbo].[Cupom] ([Id])
ALTER TABLE [dbo].[Cupom_Servico]  WITH CHECK ADD FOREIGN KEY([ServicoId])
REFERENCES [dbo].[SERVICO] ([CD_SERVICO])
