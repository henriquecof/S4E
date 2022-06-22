/****** Object:  Table [dbo].[Origem_Campanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[Origem_Campanha](
	[cd_origem_campanha] [tinyint] IDENTITY(1,1) NOT NULL,
	[ds_origem_campanha] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Origem_Campanha] PRIMARY KEY CLUSTERED 
(
	[cd_origem_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
