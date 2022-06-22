/****** Object:  Table [dbo].[Lote_GratificacaoMensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_GratificacaoMensalidades](
	[Nr_Lote] [int] NULL,
	[cd_parcela] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[cd_funcionario] [int] NULL,
	[Sequencial_Lancamento] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_GratificacaoMensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_GratificacaoMensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_GratificacaoMensalidades] CHECK CONSTRAINT [FK_Lote_GratificacaoMensalidades_MENSALIDADES]
ALTER TABLE [dbo].[Lote_GratificacaoMensalidades]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_GratificacaoMensalidades_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[Lote_GratificacaoMensalidades] CHECK CONSTRAINT [FK_Lote_GratificacaoMensalidades_TB_Lancamento]
