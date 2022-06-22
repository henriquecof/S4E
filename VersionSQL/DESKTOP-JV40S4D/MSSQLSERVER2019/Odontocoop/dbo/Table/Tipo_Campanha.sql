/****** Object:  Table [dbo].[Tipo_Campanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Tipo_Campanha](
	[cd_tipo_campanha] [smallint] NOT NULL,
	[ds_tipo_campanha] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Tipo_Campanha] PRIMARY KEY CLUSTERED 
(
	[cd_tipo_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
