/****** Object:  Table [dbo].[TB_DadosAnalise_Temp]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_DadosAnalise_Temp](
	[Sequencial_Movimentacao] [int] NOT NULL,
	[Descricao_Caixa] [varchar](60) NOT NULL,
	[Data_Pagamento] [varchar](10) NULL,
	[Codigo_Conta] [varchar](6) NULL,
	[Descricao_Conta] [varchar](80) NULL,
	[Valor_Recebimento] [money] NOT NULL,
	[Valor_Pagamento] [money] NOT NULL,
	[Valor_Recebimento_Mov] [money] NULL,
	[Valor_Pagamento_Mov] [money] NULL
) ON [PRIMARY]
