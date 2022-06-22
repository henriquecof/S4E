/****** Object:  Table [dbo].[Lote_PagamentoProducaoMicroCredito]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_PagamentoProducaoMicroCredito](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[sequencial_lancamento] [int] NULL,
	[dataCadastro] [datetime] NOT NULL,
	[usuarioCadastro] [int] NOT NULL,
 CONSTRAINT [PK_Lote_PagamentoProducaoMicroCredito] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_PagamentoProducaoMicroCredito]  WITH CHECK ADD  CONSTRAINT [FK_Lote_PagamentoProducaoMicroCredito_FUNCIONARIO] FOREIGN KEY([usuarioCadastro])
REFERENCES [dbo].[FUNCIONARIO] ([cd_funcionario])
ALTER TABLE [dbo].[Lote_PagamentoProducaoMicroCredito] CHECK CONSTRAINT [FK_Lote_PagamentoProducaoMicroCredito_FUNCIONARIO]
