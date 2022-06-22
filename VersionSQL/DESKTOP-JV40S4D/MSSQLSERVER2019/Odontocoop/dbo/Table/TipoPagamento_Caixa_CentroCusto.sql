/****** Object:  Table [dbo].[TipoPagamento_Caixa_CentroCusto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoPagamento_Caixa_CentroCusto](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[cd_centro_custo] [smallint] NOT NULL,
	[cd_tipo_pagamento] [int] NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioExclusao] [int] NULL,
	[dataExclusao] [datetime] NULL,
 CONSTRAINT [PK_TipoPagamento_Caixa_CentroCusto] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_Centro_Custo] FOREIGN KEY([cd_centro_custo])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto] CHECK CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_Centro_Custo]
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto] CHECK CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_FUNCIONARIO]
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_FUNCIONARIO1] FOREIGN KEY([usuarioExclusao])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto] CHECK CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_FUNCIONARIO1]
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto] CHECK CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_TB_MovimentacaoFinanceira]
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto]  WITH CHECK ADD  CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_TIPO_PAGAMENTO] FOREIGN KEY([cd_tipo_pagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[TipoPagamento_Caixa_CentroCusto] CHECK CONSTRAINT [FK_TipoPagamento_Caixa_CentroCusto_TIPO_PAGAMENTO]
