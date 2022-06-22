/****** Object:  Table [dbo].[TB_HistoricoMovimentacao_2]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_HistoricoMovimentacao_2](
	[Sequencial_Historico] [int] NOT NULL,
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
	[Data_LancamentoFinal] [datetime] NULL
) ON [PRIMARY]
