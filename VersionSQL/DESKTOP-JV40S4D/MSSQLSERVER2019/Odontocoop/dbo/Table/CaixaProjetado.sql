/****** Object:  Table [dbo].[CaixaProjetado]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[CaixaProjetado](
	[chave] [varchar](100) NOT NULL,
	[data] [datetime] NOT NULL,
	[dia] [smallint] NOT NULL,
	[dia_semana] [smallint] NULL,
	[vl_pagar] [money] NULL,
	[vl_receber] [money] NULL,
	[vl_recvista] [money] NULL,
	[vl_desvista] [money] NULL,
	[perc] [float] NULL,
 CONSTRAINT [PK_CaixaProjetado] PRIMARY KEY CLUSTERED 
(
	[chave] ASC,
	[data] ASC,
	[dia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
