/****** Object:  Table [dbo].[ordem_campanha]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[ordem_campanha](
	[cd_ordem_campanha] [tinyint] NOT NULL,
	[ds_ordem_campanha] [varchar](50) NOT NULL,
 CONSTRAINT [PK_ordem_campanha] PRIMARY KEY CLUSTERED 
(
	[cd_ordem_campanha] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
