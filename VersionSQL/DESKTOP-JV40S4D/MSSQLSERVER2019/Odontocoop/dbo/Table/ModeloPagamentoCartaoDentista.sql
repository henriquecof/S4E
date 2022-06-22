/****** Object:  Table [dbo].[ModeloPagamentoCartaoDentista]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ModeloPagamentoCartaoDentista](
	[idModelo] [int] NOT NULL,
	[descricaoModelo] [varchar](50) NOT NULL,
	[sequencial_movimentacao] [int] NOT NULL,
	[percentualRateio] [money] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[datacadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
	[cd_centro_custo] [smallint] NOT NULL,
 CONSTRAINT [PK_ModeloPagamentoCartaoDentista] PRIMARY KEY CLUSTERED 
(
	[idModelo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista]  WITH CHECK ADD  CONSTRAINT [FK_ModeloPagamentoCartaoDentista_Centro_custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista] CHECK CONSTRAINT [FK_ModeloPagamentoCartaoDentista_Centro_custo]
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista]  WITH CHECK ADD  CONSTRAINT [FK_ModeloPagamentoCartaoDentista_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista] CHECK CONSTRAINT [FK_ModeloPagamentoCartaoDentista_FUNCIONARIO]
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista]  WITH CHECK ADD  CONSTRAINT [FK_ModeloPagamentoCartaoDentista_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista] CHECK CONSTRAINT [FK_ModeloPagamentoCartaoDentista_FUNCIONARIO1]
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista]  WITH CHECK ADD  CONSTRAINT [FK_ModeloPagamentoCartaoDentista_TB_MovimentacaoFinanceira] FOREIGN KEY([sequencial_movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[ModeloPagamentoCartaoDentista] CHECK CONSTRAINT [FK_ModeloPagamentoCartaoDentista_TB_MovimentacaoFinanceira]
