/****** Object:  Table [dbo].[Lote_RadiologiaMensalidades]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_RadiologiaMensalidades](
	[Nr_Lote] [int] NULL,
	[cd_parcela] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[cd_funcionario] [int] NULL,
	[Sequencial_Lancamento] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_RadiologiaMensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_RadiologiaMensalidades_FUNCIONARIO] FOREIGN KEY([cd_funcionario])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_RadiologiaMensalidades] CHECK CONSTRAINT [FK_Lote_RadiologiaMensalidades_FUNCIONARIO]
ALTER TABLE [dbo].[Lote_RadiologiaMensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_RadiologiaMensalidades_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_RadiologiaMensalidades] CHECK CONSTRAINT [FK_Lote_RadiologiaMensalidades_MENSALIDADES]
ALTER TABLE [dbo].[Lote_RadiologiaMensalidades]  WITH CHECK ADD  CONSTRAINT [FK_Lote_RadiologiaMensalidades_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[Lote_RadiologiaMensalidades] CHECK CONSTRAINT [FK_Lote_RadiologiaMensalidades_TB_Lancamento]
