/****** Object:  Table [dbo].[TB_LancamentoEstoque]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_LancamentoEstoque](
	[Sequencial_LancamentoEstoque] [int] IDENTITY(1,1) NOT NULL,
	[Valor_Lancamento] [decimal](18, 2) NOT NULL,
	[Data_Previsao] [datetime] NOT NULL,
	[Historico] [varchar](500) NOT NULL,
	[Sequencial_Lancamento] [int] NULL,
	[Data_HoraExclusao] [datetime] NULL,
	[CD_Filial] [int] NOT NULL,
	[CD_Fornecedor] [int] NULL,
	[Nome_Usuario] [varchar](20) NULL,
	[Origem_Registro] [smallint] NULL,
	[Sequencial_RegistroOrigem] [int] NULL,
 CONSTRAINT [PK_TB_LancamentoEstoque] PRIMARY KEY CLUSTERED 
(
	[Sequencial_LancamentoEstoque] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_LancamentoEstoque]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_LancamentoEstoque_TB_Lancamento] FOREIGN KEY([Sequencial_Lancamento])
REFERENCES [dbo].[TB_Lancamento] ([Sequencial_Lancamento])
ALTER TABLE [dbo].[TB_LancamentoEstoque] CHECK CONSTRAINT [FK_TB_LancamentoEstoque_TB_Lancamento]
