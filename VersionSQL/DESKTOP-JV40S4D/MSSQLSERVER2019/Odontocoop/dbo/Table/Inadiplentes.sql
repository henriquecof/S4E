/****** Object:  Table [dbo].[Inadiplentes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Inadiplentes](
	[cd_tipo_pagamento] [int] NOT NULL,
	[tp_associado_empresa] [smallint] NOT NULL,
	[cd_tipo_parcela] [smallint] NOT NULL,
	[FaturadoQtd] [int] NULL,
	[FaturadoValor] [float] NULL,
	[RecebidodoMesQtd] [int] NULL,
	[RecebidodoMesValor] [float] NULL,
	[RecebidoAdiantadoQtd] [int] NULL,
	[RecebidoAdiantadoValor] [float] NULL,
	[RecebidoateoVencimentoQtd] [int] NULL,
	[RecebidoateoVencimentoValor] [float] NULL,
	[RecebidoAtrasadoQtd] [int] NULL,
	[RecebidoAtrasadoValor] [float] NULL,
	[Recebidoate30diasQtd] [int] NULL,
	[Recebidoate30diasValor] [float] NULL,
	[Recebidoate60diasQtd] [int] NULL,
	[Recebidoate60diasValor] [float] NULL,
	[Recebidoate90diasQtd] [int] NULL,
	[Recebidoate90diasValor] [float] NULL,
	[Recebidoate120diasQtd] [int] NULL,
	[Recebidoate120diasValor] [float] NULL,
 CONSTRAINT [PK_Inadiplentes_1] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_pagamento] ASC,
	[tp_associado_empresa] ASC,
	[cd_tipo_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
