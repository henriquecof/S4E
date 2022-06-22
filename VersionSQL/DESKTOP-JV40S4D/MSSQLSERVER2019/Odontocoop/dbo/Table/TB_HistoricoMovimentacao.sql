/****** Object:  Table [dbo].[TB_HistoricoMovimentacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_HistoricoMovimentacao](
	[Sequencial_Historico] [int] IDENTITY(1,1) NOT NULL,
	[Sequencial_Movimentacao] [int] NOT NULL,
	[Data_Abertura] [smalldatetime] NOT NULL,
	[Valor_Saldo_Final] [decimal](18, 2) NULL,
	[Valor_Saldo_Inicial] [decimal](18, 2) NOT NULL,
	[Data_Fechamento] [smalldatetime] NULL,
	[Data_Hora_Abertura] [datetime] NOT NULL,
	[Data_Hora_Fechamento] [datetime] NULL,
	[nome_usuario] [varchar](20) NULL,
	[Data_Hora_Conferencia] [smalldatetime] NULL,
	[cd_sequencial] [int] NULL,
	[Data_LancamentoInicial] [datetime] NULL,
	[Data_LancamentoFinal] [datetime] NULL,
 CONSTRAINT [PK_TB_HistoricoMovimentacao] PRIMARY KEY CLUSTERED 
(
	[Sequencial_Historico] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[TB_HistoricoMovimentacao]  WITH NOCHECK ADD  CONSTRAINT [FK_TB_HistoricoMovimentacao_TB_MovimentacaoFinanceira] FOREIGN KEY([Sequencial_Movimentacao])
REFERENCES [dbo].[TB_MovimentacaoFinanceira] ([Sequencial_Movimentacao])
ALTER TABLE [dbo].[TB_HistoricoMovimentacao] CHECK CONSTRAINT [FK_TB_HistoricoMovimentacao_TB_MovimentacaoFinanceira]
