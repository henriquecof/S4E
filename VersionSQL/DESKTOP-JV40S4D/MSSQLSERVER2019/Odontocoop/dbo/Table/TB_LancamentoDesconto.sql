/****** Object:  Table [dbo].[TB_LancamentoDesconto]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_LancamentoDesconto](
	[Sequencial_Desconto] [int] IDENTITY(1,1) NOT NULL,
	[Data_Vencimento] [datetime] NOT NULL,
	[cd_associado] [int] NOT NULL,
	[cd_empresa] [int] NOT NULL,
	[Sequencial_Lancamento] [int] NULL,
	[Valor_Mensalidade] [money] NOT NULL,
 CONSTRAINT [PK_TB_LancamentoDesconto] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Desconto] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_LancamentoDesconto]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_LancamentoDesconto_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_LancamentoDesconto] CHECK CONSTRAINT [FK_TB_LancamentoDesconto_TB_Lancamento]
