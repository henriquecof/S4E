/****** Object:  Table [dbo].[TipoPagamentoLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TipoPagamentoLancamento](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[tipoPagamento] [int] NOT NULL,
	[tipoEmpresa] [smallint] NULL,
	[centroCusto] [smallint] NULL,
	[tipoPagamentoIndicador] [tinyint] NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[Sequencial_Conta] [int] NOT NULL,
	[tipoLancamento] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD FOREIGN KEY([centroCusto])
REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD FOREIGN KEY([Sequencial_Conta])
REFERENCES [dbo].[TB_Conta] ([Sequencial_Conta])
ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD FOREIGN KEY([tipoEmpresa])
REFERENCES [dbo].[TIPO_EMPRESA] ([tp_empresa])
ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD FOREIGN KEY([tipoPagamentoIndicador])
REFERENCES [dbo].[TipoPagamentoIndicador] ([id])
ALTER TABLE [dbo].[TipoPagamentoLancamento]  WITH CHECK ADD  CONSTRAINT [FK__TipoPagam__tipoP__7311ED85] FOREIGN KEY([tipoPagamento])
REFERENCES [dbo].[TIPO_PAGAMENTO] ([cd_tipo_pagamento])
ALTER TABLE [dbo].[TipoPagamentoLancamento] CHECK CONSTRAINT [FK__TipoPagam__tipoP__7311ED85]
