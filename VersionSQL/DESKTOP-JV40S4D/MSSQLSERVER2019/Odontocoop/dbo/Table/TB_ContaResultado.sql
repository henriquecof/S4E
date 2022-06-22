/****** Object:  Table [dbo].[TB_ContaResultado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[TB_ContaResultado](
	[ContaMaeOrigem] [varchar](90) NOT NULL,
	[ContaOrigem] [varchar](90) NOT NULL,
	[Sequencial_LancamentoOrigem] [int] NOT NULL,
	[HistoricoOrigem] [varchar](1500) NOT NULL,
	[DataDocumentoOrigem] [datetime] NOT NULL,
	[ValorRealizadoOrigem] [money] NULL,
	[ValorPrevistoOrigem] [money] NULL,
	[ContaMaeDestino] [varchar](90) NULL,
	[ContaDestino] [varchar](90) NULL,
	[Sequencial_LancamentoDestino] [int] NULL,
	[HistoricoDestino] [varchar](1500) NULL,
	[DataDocumentoDestino] [datetime] NULL,
	[ValorRealizadoDestino] [money] NULL,
	[ValorPrevistoDestino] [money] NULL
) ON [PRIMARY]
