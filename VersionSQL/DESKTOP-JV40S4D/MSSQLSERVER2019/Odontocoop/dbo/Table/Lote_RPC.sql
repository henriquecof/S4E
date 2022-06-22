/****** Object:  Table [dbo].[Lote_RPC]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Lote_RPC](
	[ano_trimestre] [int] NOT NULL,
	[cd_variacao] [int] NOT NULL,
	[dt_gerado] [datetime] NOT NULL,
	[dt_finalizado] [datetime] NULL,
 CONSTRAINT [PK_Lote_RPC] PRIMARY KEY CLUSTERED 
(
	[ano_trimestre] ASC,
	[cd_variacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
