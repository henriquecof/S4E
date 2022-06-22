/****** Object:  Table [dbo].[Aliquota_IR]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Aliquota_IR](
	[vl_minimo] [money] NOT NULL,
	[vl_maximo] [money] NOT NULL,
	[perc_aliquota] [float] NOT NULL,
	[vl_deduzir] [money] NOT NULL,
	[vl_deducao_dependente] [money] NULL,
 CONSTRAINT [PK_Aliquota_IR] PRIMARY KEY CLUSTERED 
(
	[perc_aliquota] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
