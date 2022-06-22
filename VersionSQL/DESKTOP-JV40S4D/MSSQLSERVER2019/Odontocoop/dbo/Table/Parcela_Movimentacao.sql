/****** Object:  Table [dbo].[Parcela_Movimentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Parcela_Movimentacao](
	[cd_parcela] [int] NOT NULL,
	[cd_sequencial_dep] [int] NOT NULL,
	[acao] [varchar](1) NULL,
 CONSTRAINT [PK_Parcela_Movimentacao] PRIMARY KEY CLUSTERED 
(
	[cd_parcela] ASC,
	[cd_sequencial_dep] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Parcela_Movimentacao]  WITH CHECK ADD  CONSTRAINT [FK_Parcela_Movimentacao_DEPENDENTES] FOREIGN KEY([cd_sequencial_dep])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Parcela_Movimentacao] CHECK CONSTRAINT [FK_Parcela_Movimentacao_DEPENDENTES]
ALTER TABLE [dbo].[Parcela_Movimentacao]  WITH CHECK ADD  CONSTRAINT [FK_Parcela_Movimentacao_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Parcela_Movimentacao] CHECK CONSTRAINT [FK_Parcela_Movimentacao_MENSALIDADES]
