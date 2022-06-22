/****** Object:  Table [dbo].[Lote_Cartoes_Retorno_FormaLancamento]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_Cartoes_Retorno_FormaLancamento](
	[cd_sequencial_retorno] [int] NOT NULL,
	[Sequencial_FormaLancamento] [int] NOT NULL,
	[dt_credito] [date] NULL,
	[dt_pago] [date] NULL,
	[vl_parcela] [money] NULL,
	[vl_tarifa] [money] NULL,
	[fl_excluido] [tinyint] NULL,
 CONSTRAINT [PK_Lote_Cartoes_Retorno_FormaLancamento] PRIMARY KEY CLUSTERED 
(
	[cd_sequencial_retorno] ASC,
	[Sequencial_FormaLancamento] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]

ALTER TABLE [dbo].[Lote_Cartoes_Retorno_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Cartoes_Retorno_FormaLancamento_Lote_Cartoes_Retorno] FOREIGN KEY([cd_sequencial_retorno])
REFERENCES [dbo].[Lote_Cartoes_Retorno] ([cd_sequencial_retorno])
ALTER TABLE [dbo].[Lote_Cartoes_Retorno_FormaLancamento] CHECK CONSTRAINT [FK_Lote_Cartoes_Retorno_FormaLancamento_Lote_Cartoes_Retorno]
ALTER TABLE [dbo].[Lote_Cartoes_Retorno_FormaLancamento]  WITH NOCHECK ADD  CONSTRAINT [FK_Lote_Cartoes_Retorno_FormaLancamento_TB_FormaLancamento] FOREIGN KEY([Sequencial_FormaLancamento])
REFERENCES [dbo].[TB_FormaLancamento] ([Sequencial_FormaLancamento])
ALTER TABLE [dbo].[Lote_Cartoes_Retorno_FormaLancamento] CHECK CONSTRAINT [FK_Lote_Cartoes_Retorno_FormaLancamento_TB_FormaLancamento]
