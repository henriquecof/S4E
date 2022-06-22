/****** Object:  Table [dbo].[SPC_IMP]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[SPC_IMP](
	[CONSUMIDOR] [varchar](250) NULL,
	[CPF_CNPJ] [varchar](20) NULL,
	[ASSOCIADO] [varchar](250) NULL,
	[DATA_INCLUSAO] [datetime] NULL,
	[CONTRATO] [varchar](50) NULL,
	[DATA_VENCIMENTO] [datetime] NULL,
	[DATA_COMPRA] [datetime] NULL,
	[valor] [float] NULL,
	[ORIGEM_INCLUSAO] [varchar](250) NULL,
	[DATA_LIQUIDACAO] [datetime] NULL,
	[ORIGEM_EXCLUSAO] [varchar](250) NULL,
	[dt_leitura] [date] NULL
) ON [PRIMARY]
