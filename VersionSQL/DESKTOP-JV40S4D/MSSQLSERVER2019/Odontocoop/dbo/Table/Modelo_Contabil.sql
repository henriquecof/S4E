/****** Object:  Table [dbo].[Modelo_Contabil]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Modelo_Contabil](
	[cd_modelo_expcontabil] [smallint] NOT NULL,
	[ds_modelo_expcontabil] [varchar](100) NOT NULL,
 CONSTRAINT [PK_Modelo_Contabil] PRIMARY KEY CLUSTERED 
(
	[cd_modelo_expcontabil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
