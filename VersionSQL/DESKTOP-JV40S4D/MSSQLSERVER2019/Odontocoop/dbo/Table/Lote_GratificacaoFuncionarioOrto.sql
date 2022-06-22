/****** Object:  Table [dbo].[Lote_GratificacaoFuncionarioOrto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_GratificacaoFuncionarioOrto](
	[Nr_Lote] [int] NULL,
	[cd_parcela] [int] NULL,
	[dt_cadastro] [datetime] NULL,
	[funcionarioCadastro] [int] NULL,
	[funcionarioGratificacao] [int] NULL,
	[Sequencial_Lancamento] [int] NULL
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto]  WITH CHECK ADD  CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_FUNCIONARIO] FOREIGN KEY([funcionarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto] CHECK CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_FUNCIONARIO]
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto]  WITH CHECK ADD  CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_FUNCIONARIOGratf] FOREIGN KEY([funcionarioGratificacao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto] CHECK CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_FUNCIONARIOGratf]
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto]  WITH CHECK ADD  CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto] CHECK CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_MENSALIDADES]
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto]  WITH CHECK ADD  CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[Lote_GratificacaoFuncionarioOrto] CHECK CONSTRAINT [FK_Lote_GratificacaoFuncionarioOrto_TB_Lancamento]
