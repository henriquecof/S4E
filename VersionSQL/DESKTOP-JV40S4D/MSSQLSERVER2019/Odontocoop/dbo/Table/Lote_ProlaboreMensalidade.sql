/****** Object:  Table [dbo].[Lote_ProlaboreMensalidade]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_ProlaboreMensalidade](
	[Nr_Lote] [int] NULL,
	[cd_parcela] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[cd_funcionario] [int] NULL,
	[cd_funcionariodiretor] [int] NULL,
	[Sequencial_Lancamento] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_ProlaboreMensalidade]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_ProlaboreMensalidade_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_ProlaboreMensalidade] CHECK CONSTRAINT [FK_Lote_ProlaboreMensalidade_MENSALIDADES]
ALTER TABLE [dbo].[Lote_ProlaboreMensalidade]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_ProlaboreMensalidade_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[Lote_ProlaboreMensalidade] CHECK CONSTRAINT [FK_Lote_ProlaboreMensalidade_TB_Lancamento]
