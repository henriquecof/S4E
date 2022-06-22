/****** Object:  Table [dbo].[PATRIMONIOLocalizacao]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[PATRIMONIOLocalizacao](
	[id_Localizacao] [int] IDENTITY(1,1) NOT NULL,
	[descricao_Localizacao] [varchar](200) NOT NULL,
 CONSTRAINT [PK_PATRIMONIOLocalizacao] PRIMARY KEY CLUSTERED 
(
	[id_Localizacao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
