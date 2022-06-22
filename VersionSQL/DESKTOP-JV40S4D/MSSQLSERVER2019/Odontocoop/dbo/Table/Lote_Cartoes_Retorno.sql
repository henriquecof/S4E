/****** Object:  Table [dbo].[Lote_Cartoes_Retorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Cartoes_Retorno](
	[cd_sequencial_retorno] [int] IDENTITY(1,1) NOT NULL,
	[dt_processado] [datetime] NOT NULL,
	[cd_centro_custo] [int] NULL,
	[cd_funcionario] [int] NULL,
	[qtde] [int] NULL,
	[valor] [money] NULL,
	[dt_pagIni] [datetime] NULL,
	[dt_pagFin] [datetime] NULL,
	[Requisicao] [varchar](20) NULL,
	[obs] [varchar](1000) NULL,
	[conciliadorId] [int] NULL,
 CONSTRAINT [PK_Lote_Cartoes_Retorno] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_retorno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Cartoes_Retorno]  WITH CHECK ADD  CONSTRAINT [fk_Lote_Cartoes_Retorno_conciliador] FOREIGN KEY([conciliadorId])
REFERENCES [dbo].[Conciliadores] ([id])
ALTER TABLE [dbo].[Lote_Cartoes_Retorno] CHECK CONSTRAINT [fk_Lote_Cartoes_Retorno_conciliador]
