/****** Object:  Table [dbo].[restricoes]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[restricoes](
	[cd_restricao] [smallint] NOT NULL,
	[nm_restricao] [nvarchar](100) NULL,
 CONSTRAINT [PK_restricoes] PRIMARY KEY CLUSTERED 
(
	[cd_restricao] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
