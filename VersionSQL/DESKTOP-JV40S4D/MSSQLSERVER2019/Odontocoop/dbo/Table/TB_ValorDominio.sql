/****** Object:  Table [dbo].[TB_ValorDominio]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ValorDominio](
	[CodigoDominio] [int] NOT NULL,
	[CodigoValorDominio] [int] NOT NULL,
	[Descricao] [varchar](100) NOT NULL,
	[Valor] [decimal](18, 2) NULL,
	[LimiteMensal] [decimal](18, 2) NULL
) ON [PRIMARY]
