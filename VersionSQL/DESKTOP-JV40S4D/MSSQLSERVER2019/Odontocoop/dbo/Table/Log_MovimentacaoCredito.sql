/****** Object:  Table [dbo].[Log_MovimentacaoCredito]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Log_MovimentacaoCredito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[usuarioOrigem] [int] NOT NULL,
	[tipoTransacao] [tinyint] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[tipoCreditoOrigem] [tinyint] NOT NULL,
	[valor] [money] NOT NULL,
	[usuarioDestino] [int] NULL,
	[tipoCreditoDestino] [tinyint] NULL,
	[cd_parcela] [int] NULL,
	[orcamentoOrigem] [int] NULL,
	[orcamentoDestino] [int] NULL,
 CONSTRAINT [PK_Log_MovimentacaoCredito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_DEPENDENTES] FOREIGN KEY([usuarioDestino])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_DEPENDENTES]
ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_FUNCIONARIO]
ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_Log_MovimentacaoCredito] FOREIGN KEY([usuarioOrigem])
REFERENCES [dbo].[DEPENDENTES] ([CD_SEQUENCIAL])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_Log_MovimentacaoCredito]
ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_MENSALIDADES] FOREIGN KEY([cd_parcela])
REFERENCES [dbo].[MENSALIDADES] ([CD_PARCELA])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_MENSALIDADES]
ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_orcamento_clinico] FOREIGN KEY([orcamentoOrigem])
REFERENCES [dbo].[orcamento_clinico] ([cd_orcamento])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_orcamento_clinico]
ALTER TABLE [dbo].[Log_MovimentacaoCredito]  WITH CHECK ADD  CONSTRAINT [FK_Log_MovimentacaoCredito_orcamento_clinico1] FOREIGN KEY([orcamentoDestino])
REFERENCES [dbo].[orcamento_clinico] ([cd_orcamento])
ALTER TABLE [dbo].[Log_MovimentacaoCredito] CHECK CONSTRAINT [FK_Log_MovimentacaoCredito_orcamento_clinico1]
