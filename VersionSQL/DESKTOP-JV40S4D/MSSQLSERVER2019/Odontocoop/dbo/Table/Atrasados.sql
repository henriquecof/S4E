/****** Object:  Table [dbo].[Atrasados]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Atrasados](
	[cd_tipo_pagamento] [int] NOT NULL,
	[tp_associado_empresa] [smallint] NOT NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[FaturadoValor] [float] NOT NULL,
	[FaturadoQtde] [int] NOT NULL,
	[RecebidoValor] [float] NULL,
	[RecebidoValorDiferenca] [float] NULL,
	[RecebidoQtde] [int] NULL,
	[RecebidoValorFora] [float] NULL,
	[RecebidoValorForaDiferenca] [float] NULL,
	[RecebidoQtdeFora] [int] NULL,
	[AtrasadoValor] [float] NULL,
	[AtrasadoQtde] [int] NULL,
	[PagoValorFora] [float] NULL,
	[PagoValorForaAtrasado] [float] NULL,
	[PagoQtdeFora] [int] NULL,
	[QtdePeso] [int] NULL,
	[ValorPeso] [float] NULL,
	[perc_faturado] [float] NULL,
	[perc_rec_rec_fora] [float] NULL,
	[CanceladoQtde] [int] NULL,
	[CanceladoValor] [float] NULL,
 CONSTRAINT [PK_Atrasados_1] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC,
	[tp_associado_empresa] ASC,
	[cd_tipo_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
