/****** Object:  Table [dbo].[Lote_Conciliacao_Inconsistencia]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Conciliacao_Inconsistencia](
	[Sequencial_FormaLancamento] [int] NULL,
	[Sequencial_Conciliador] [varchar](500) NULL,
	[Numero_Parcela] [int] NULL,
	[Valor_Bruto] [decimal](18, 2) NULL,
	[Valor_Liquido] [decimal](18, 2) NULL,
	[Taxa_Percentual] [decimal](18, 2) NULL,
	[Taxa_Valor] [decimal](18, 2) NULL,
	[Codigo_Autorizacao] [varchar](20) NULL,
	[Data_Previsao] [datetime] NULL,
	[Data_Credito] [datetime] NULL,
	[Data_Cadastro] [datetime] NOT NULL,
	[Data_Pagamento] [datetime] NULL,
	[NSU] [varchar](100) NULL,
	[compraId] [varchar](250) NULL
) ON [PRIMARY]
