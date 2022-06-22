/****** Object:  Table [dbo].[deb_automatico_cr_conversao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[deb_automatico_cr_conversao](
	[banco] [int] NOT NULL,
	[cd_ocorrencia] [varchar](10) NOT NULL,
	[cd_ocorrencia_new] [int] NULL,
 CONSTRAINT [PK_deb_automatico_cr_conversao] PRIMARY KEY CLUSTERED 
(
	[banco] ASC,
	[cd_ocorrencia] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
