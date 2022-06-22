/****** Object:  Table [dbo].[Mensalidade_Estorno]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Mensalidade_Estorno](
	[cd_parcela] [int] NOT NULL,
	[dt_estorno] [date] NOT NULL,
	[dt_recuperacao_estorno] [date] NULL,
 CONSTRAINT [PK_Mensalidade_Estorno] PRIMARY KEY CLUSTERED 
(
	[cd_parcela] ASC,
	[dt_estorno] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
