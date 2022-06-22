/****** Object:  Table [dbo].[Mensalidade_emitidas]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Mensalidade_emitidas](
	[cd_parcela] [int] NOT NULL,
	[DT_VENCIMENTO] [date] NOT NULL,
	[mes] [smallint] NOT NULL,
	[inicio_cobertura] [smallint] NOT NULL,
	[qt_diasmes] [smallint] NOT NULL,
	[qt_diasmescorrente] [smallint] NULL,
	[vl_debito] [money] NOT NULL,
	[vl_dia] [money] NULL,
	[Janeiro] [money] NULL,
	[Fevereiro] [money] NULL,
	[Marco] [money] NULL,
	[Abril] [money] NULL,
	[Maio] [money] NULL,
	[Junho] [money] NULL,
	[Julho] [money] NULL,
	[Agosto] [money] NULL,
	[Setembro] [money] NULL,
	[Outubro] [money] NULL,
	[Novembro] [money] NULL,
	[Dezembro] [money] NULL,
	[Janeiro_1] [money] NULL,
 CONSTRAINT [PK_Mensalidade_emitidas_1] PRIMARY KEY NONCLUSTERED 
(
	[cd_parcela] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
