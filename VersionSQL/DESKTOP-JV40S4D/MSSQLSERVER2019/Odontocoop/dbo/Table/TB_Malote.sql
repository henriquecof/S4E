/****** Object:  Table [dbo].[TB_Malote]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_Malote](
	[cd_sequencial_malote] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[dt_abertura_malote] [datetime] NOT NULL,
	[usuario_abertura_malote] [int] NOT NULL,
	[dt_fechamento_malote] [datetime] NULL,
	[Sequencial_Historico] [int] NULL,
	[nr_cheque] [varchar](50) NULL,
	[dt_pagamento_malote] [datetime] NULL,
	[usuario_fechamento_malote] [int] NULL,
	[valor] [money] NULL,
	[valorExtenso] [varchar](150) NULL,
	[localidade] [varchar](50) NULL,
	[dia] [varchar](2) NULL,
	[mesExtenso] [varchar](50) NULL,
	[ano] [int] NULL,
	[cdLoteEscrituracao] [int] NULL,
 CONSTRAINT [PK_TB_Malote] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_malote] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_Malote]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Malote_TB_HistoricoMovimentacao] FOREIGN KEY([Sequencial_Historico])
REFERENCES [dbo].[TB_HistoricoMovimentacao] ([Sequencial_Historico])
ALTER TABLE [dbo].[TB_Malote] CHECK CONSTRAINT [FK_TB_Malote_TB_HistoricoMovimentacao]
ALTER TABLE [dbo].[TB_Malote]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_Malote_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_Malote] CHECK CONSTRAINT [FK_TB_Malote_TB_MovimentacaoFinanceira]
