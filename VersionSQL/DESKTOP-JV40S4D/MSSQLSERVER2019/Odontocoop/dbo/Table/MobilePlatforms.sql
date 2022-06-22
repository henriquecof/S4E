/****** Object:  Table [dbo].[MobilePlatforms]    Committed by VersionSQL https://www.versionsql.com ******/

SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
CREATE TABLE [dbo].[MobilePlatforms](
	[platformID] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](45) NOT NULL,
	[registration] [datetime] NOT NULL,
	[nr_order] [varchar](45) NOT NULL,
	[iconFile] [varchar](45) NOT NULL,
 CONSTRAINT [PK_MobilePlatforms] PRIMARY KEY CLUSTERED 
(
	[platformID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
